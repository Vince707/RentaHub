<?php
// File path
$xmlFile = '../apartment.xml';

// Load XML
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$renterId = $_POST['renter_id'] ?? null;
$renterName = $_POST['renter_name'] ?? null;

$billType = $_POST['payment_type'] ?? null; // e.g., 'Electric', 'Water', 'Rent', or 'Overdue'
$billId = $_POST['bill_id'] ?? null;
$readingId = $_POST['reading_id'] ?? null;
$amountPaid = floatval($_POST['payment_amount'] ?? 0);
$paymentDate = $_POST['payment_date'] ?? date('Y-m-d');
$receiptNumber = $_POST['receipt_number'] ?? '';
$overdueBillIds = isset($_POST['overdue_bill_ids']) ? explode(',', $_POST['overdue_bill_ids']) : [];
$paymentMethod = $_POST['payment_method'] ?? '';
$paymentAmountType = $_POST['payment_amount_type'] ?? '';
$paymentRemarks = $_POST['payment_remarks'] ?? '';

if (!$renterId || $amountPaid <= 0) {
    die("Invalid payment data.");
}

// Helper function to update a bill element (for partial/full payments)
function updateBill(&$bill, $amountPaid) {
    $origAmount = floatval($bill->amount);
    $origDebt = floatval($bill->debt);
    $origOverpaid = floatval($bill->overpaid);

    // If bill is already paid, skip
    if ((string)$bill->status === 'Paid') return 0;

    // Determine how much is left to pay
    $toPay = $origDebt > 0 ? $origDebt : $origAmount;

    if ($amountPaid < $toPay) {
        // Partial payment
        $bill->debt = $toPay - $amountPaid;
        $bill->status = 'Partial';
        $bill->amount = $origAmount; // Always keep original amount
        $bill->overpaid = 0;
        return $amountPaid;
    } else {
        // Full payment or overpayment
        $overpaid = $amountPaid - $toPay;
        $bill->debt = 0;
        $bill->status = 'Paid';
        $bill->amount = $origAmount;
        $bill->overpaid = $overpaid;
        return $toPay;
    }
}

// Helper to find a bill by ID in readings (works for both <bills><bill> and direct <bill>)
function &findBillInUtility($utility, $billId) {
    foreach ($utility->reading as $reading) {
        // Check <bills><bill>
        if (isset($reading->bills)) {
            foreach ($reading->bills->bill as $bill) {
                if ((string)$bill['id'] === $billId) {
                    return $bill;
                }
            }
        }
        // Check direct <bill>
        foreach ($reading->bill as $bill) {
            if ((string)$bill['id'] === $billId) {
                return $bill;
            }
        }
    }
    $null = null;
    return $null;
}

// Helper to find a rent bill by ID
function &findRentBill(&$xml, $billId) {
    foreach ($xml->billing->rentBills->bill as $bill) {
        if ((string)$bill['id'] === $billId) {
            return $bill;
        }
    }
    $null = null;
    return $null;
}

// === Payment Logic ===
$totalPaid = 0;
$paidBills = [];

if ($billType === 'Overdue' && !empty($overdueBillIds)) {
    // Handle multiple bills (overdue)
    foreach ($overdueBillIds as $oid) {
        $oid = trim($oid);
        $found = false;
        // Electric
        foreach ($xml->billing->utilityBills->utility as $utility) {
            if ((string)$utility['type'] === 'Electricity') {
                $bill = &findBillInUtility($utility, $oid);
                if ($bill) {
                    $paid = updateBill($bill, $amountPaid); // You might want to split amountPaid per bill
                    $totalPaid += $paid;
                    $paidBills[] = $oid;
                    $found = true;
                    break;
                }
            }
        }
        // Water
        if (!$found) {
            foreach ($xml->billing->utilityBills->utility as $utility) {
                if ((string)$utility['type'] === 'Water') {
                    $bill = &findBillInUtility($utility, $oid);
                    if ($bill) {
                        $paid = updateBill($bill, $amountPaid);
                        $totalPaid += $paid;
                        $paidBills[] = $oid;
                        $found = true;
                        break;
                    }
                }
            }
        }
        // Rent
        if (!$found) {
            $bill = &findRentBill($xml, $oid);
            if ($bill) {
                $paid = updateBill($bill, $amountPaid);
                $totalPaid += $paid;
                $paidBills[] = $oid;
            }
        }
    }
} else {
    // Single bill (Electric, Water, Rent)
    if ($billType === 'Electric' || $billType === 'Water') {
        foreach ($xml->billing->utilityBills->utility as $utility) {
            if ((string)$utility['type'] === $billType) {
                $bill = &findBillInUtility($utility, $billId);
                if ($bill) {
                    $paid = updateBill($bill, $amountPaid);
                    $totalPaid += $paid;
                    $paidBills[] = $billId;
                    break;
                }
            }
        }
    } elseif ($billType === 'Rent') {
        $bill = &findRentBill($xml, $billId);
        if ($bill) {
            $paid = updateBill($bill, $amountPaid);
            $totalPaid += $paid;
            $paidBills[] = $billId;
        }
    }
}

// === Record Payment (optional, if you have a <payments> section) ===
if (!isset($xml->payments)) {
    $xml->addChild('payments');
}
$payment = $xml->payments->addChild('payment');
$payment->addChild('renterId', $renterId);
$payment->addChild('date', $paymentDate);
$payment->addChild('amount', $amountPaid);
$payment->addChild('receiptNumber', htmlspecialchars($receiptNumber));
$payment->addChild('billType', $billType);
$payment->addChild('billIds', implode(',', $paidBills));

// === Save changes ===
$xml->asXML($xmlFile);

// === Response ===
header('Content-Type: application/json');
echo json_encode([
    'success' => true,
    'paidBills' => $paidBills,
    'totalPaid' => $totalPaid,
    'message' => 'Payment recorded successfully.'
]);
exit;
?>
