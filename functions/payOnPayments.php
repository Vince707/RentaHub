<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$xmlFile = '../apartment.xml';

if (!file_exists($xmlFile)) {
    exit('XML file not found.');
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$renterId = $_POST['renter_id'] ?? null;
$billType = $_POST['payment_type'] ?? null; // 'Electricity', 'Water', or 'Rent'
$amountPaid = floatval($_POST['payment_amount'] ?? 0);
$paymentDate = $_POST['payment_date'] ?? date('Y-m-d');
$receiptNumber = $_POST['receipt_number'] ?? '';
$paymentMethod = $_POST['payment_method'] ?? '';
$paymentAmountType = $_POST['payment_amount_type'] ?? '';
$paymentRemarks = $_POST['payment_remarks'] ?? '';

// Validate required fields
if (!$renterId || !$billType || $amountPaid <= 0) {
    exit("Invalid input data.");
}

$totalPaid = 0;
$paidBills = [];

// Helper: Update a bill (partial/full/over)
function updateBill(&$bill, &$amountRemaining) {
    $origAmount = floatval($bill->amount);
    $origDebt = isset($bill->debt) ? floatval($bill->debt) : 0;

    if ((string)$bill->status === 'Paid') {
        return 0; // Already paid
    }

    $toPay = $origDebt > 0 ? $origDebt : $origAmount;

    if ($amountRemaining <= 0) {
        return 0; // No money left to pay
    }

    if ($amountRemaining < $toPay) {
        // Partial payment
        $bill->debt = $toPay - $amountRemaining;
        $bill->status = 'Partial';
        $bill->amount = $origAmount;
        $bill->overpaid = 0;
        $paid = $amountRemaining;
        $amountRemaining = 0;
        return $paid;
    } else {
        // Full payment or overpayment
        $overpaid = $amountRemaining - $toPay;
        $bill->debt = 0;
        $bill->status = 'Paid';
        $bill->amount = $origAmount;
        $bill->overpaid = $overpaid;
        $paid = $toPay;
        $amountRemaining -= $toPay;
        return $paid;
    }
}

// Helper: Update reading status based on child bills
function updateReadingStatus($reading) {
    $allPaid = true;
    $anyPartial = false;
    if (isset($reading->bills)) {
        foreach ($reading->bills->bill as $bill) {
            $status = (string)$bill->status;
            if ($status === 'Partial') $anyPartial = true;
            if ($status !== 'Paid') $allPaid = false;
        }
        if ($allPaid) {
            $reading->status = 'Paid';
        } elseif ($anyPartial) {
            $reading->status = 'Partial';
        } else {
            $reading->status = 'Unpaid';
        }
    }
}

// Find rent bills for renter with unpaid or partial status, sorted by dueDate ascending
function getRentBillsForRenter($xml, $renterId) {
    $bills = [];
    foreach ($xml->billing->rentBills->bill as $bill) {
        if ((string)$bill->renterId === (string)$renterId) {
            $status = (string)$bill->status;
            if ($status === 'Unpaid' || $status === 'Partial') {
                $dueDate = $bill->dueDate ? (string)$bill->dueDate : '9999-12-31';
                $bills[] = ['bill' => $bill, 'dueDate' => $dueDate];
            }
        }
    }
    usort($bills, fn($a, $b) => strcmp($a['dueDate'], $b['dueDate']));
    return $bills;
}

// Find utility bills for renter with unpaid or partial status, sorted by reading dueDate ascending
// Returns array of ['bill' => billNode, 'reading' => readingNode, 'dueDate' => readingDueDate]
function getUtilityBillsForRenter($utility, $renterId) {
    $results = [];
    foreach ($utility->reading as $reading) {
        $readingDueDate = $reading->dueDate ? (string)$reading->dueDate : '9999-12-31';
        if (!isset($reading->bills)) continue;
        foreach ($reading->bills->bill as $bill) {
            if ((string)$bill->renterId === (string)$renterId) {
                $status = (string)$bill->status;
                if ($status === 'Unpaid' || $status === 'Partial') {
                    $results[] = ['bill' => $bill, 'reading' => $reading, 'dueDate' => $readingDueDate];
                }
            }
        }
    }
    usort($results, fn($a, $b) => strcmp($a['dueDate'], $b['dueDate']));
    return $results;
}

// Main payment processing
$amountRemaining = $amountPaid;

if ($billType === 'Rent') {
    $rentBills = getRentBillsForRenter($xml, $renterId);
    foreach ($rentBills as $entry) {
        if ($amountRemaining <= 0) break;
        $paid = updateBill($entry['bill'], $amountRemaining);
        if ($paid > 0) {
            $totalPaid += $paid;
            $paidBills[] = (string)$entry['bill']['id'];
        }
    }
} elseif ($billType === 'Electricity' || $billType === 'Water') {
    // Find the utility node
    $utility = null;
    foreach ($xml->billing->utilityBills->utility as $util) {
        if ((string)$util['type'] === $billType) {
            $utility = $util;
            break;
        }
    }
    if ($utility === null) {
        exit("Utility type not found.");
    }

    $utilityBills = getUtilityBillsForRenter($utility, $renterId);
    foreach ($utilityBills as $entry) {
        if ($amountRemaining <= 0) break;
        $paid = updateBill($entry['bill'], $amountRemaining);
        if ($paid > 0) {
            $totalPaid += $paid;
            $paidBills[] = (string)$entry['bill']['id'];
            updateReadingStatus($entry['reading']);
        }
    }
} else {
    exit("Invalid bill type.");
}

if ($totalPaid <= 0) {
    exit("No unpaid bills found or payment amount is zero.");
}

// Record payment (this part will still process the *data* in memory, but not save to XML)
if (!isset($xml->payments)) {
    $xml->addChild('payments');
}
$payment = $xml->payments->addChild('payment');
$payment->addAttribute('id', htmlspecialchars($receiptNumber));
$payment->addChild('renterId', $renterId);
$payment->addChild('paymentType', $billType);
$payment->addChild('paymentAmountType', htmlspecialchars($paymentAmountType));
$payment->addChild('paymentDate', $paymentDate);
$payment->addChild('amount', $amountPaid);
$payment->addChild('paymentMethod', htmlspecialchars($paymentMethod));
$payment->addChild('remarks', htmlspecialchars($paymentRemarks));
$payment->addChild('billIds', implode(',', $paidBills));

// Removed XML saving and redirection
$xml->asXML($xmlFile);
header("Location: ../caretaker-billings.xml?pay=recorded");
exit();
?>