<?php
$xmlFile = '../apartment.xml';

if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$renterId = $_POST['renter_id'] ?? null;
$billType = $_POST['payment_type'] ?? null; // 'Electric', 'Water', 'Rent', or 'Overdue'
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
    header("Location: ../caretaker-billings.xml?pay=error");
    exit;
}

// Helper: Update a bill (partial/full/over)
function updateBill(&$bill, $amountPaid) {
    $origAmount = floatval($bill->amount);
    $origDebt = isset($bill->debt) ? floatval($bill->debt) : 0;
    $origOverpaid = isset($bill->overpaid) ? floatval($bill->overpaid) : 0;

    if ((string)$bill->status === 'Paid') return 0;

    $toPay = $origDebt > 0 ? $origDebt : $origAmount;

    if ($amountPaid < $toPay) {
        // Partial payment
        $bill->debt = $toPay - $amountPaid;
        $bill->status = 'Partial';
        $bill->amount = $origAmount;
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

// Helper: Update reading status based on all child bills
function updateReadingStatus($reading) {
    $allPaid = true;
    $anyPartial = false;
    if (isset($reading->bills)) {
        foreach ($reading->bills->bill as $bill) {
            if ((string)$bill->status === 'Partial') $anyPartial = true;
            if ((string)$bill->status !== 'Paid') $allPaid = false;
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

// Find utility bill by ID and return [bill, reading]
function &findUtilityBill($utility, $billId) {
    foreach ($utility->reading as $reading) {
        if (isset($reading->bills)) {
            foreach ($reading->bills->bill as $bill) {
                if ((string)$bill['id'] === $billId) {
                    // Return both bill and reading as array
                    $result = ['bill' => $bill, 'reading' => $reading];
                    return $result;
                }
            }
        }
    }
    $null = null;
    return $null;
}

// Find rent bill by ID
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
    foreach ($overdueBillIds as $oid) {
        $oid = trim($oid);
        $found = false;

        // Electric
        foreach ($xml->billing->utilityBills->utility as $utility) {
            if ((string)$utility['type'] === 'Electricity') {
                $result = &findUtilityBill($utility, $oid);
                if ($result && isset($result['bill'])) {
                    $paid = updateBill($result['bill'], $amountPaid); // You may want to split amountPaid
                    $totalPaid += $paid;
                    $paidBills[] = $oid;
                    updateReadingStatus($result['reading']);
                    $found = true;
                    break;
                }
            }
        }
        // Water
        if (!$found) {
            foreach ($xml->billing->utilityBills->utility as $utility) {
                if ((string)$utility['type'] === 'Water') {
                    $result = &findUtilityBill($utility, $oid);
                    if ($result && isset($result['bill'])) {
                        $paid = updateBill($result['bill'], $amountPaid);
                        $totalPaid += $paid;
                        $paidBills[] = $oid;
                        updateReadingStatus($result['reading']);
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
    // Single bill
    if ($billType === 'Electric' || $billType === 'Water') {
        foreach ($xml->billing->utilityBills->utility as $utility) {
            if ((string)$utility['type'] === $billType) {
                $result = &findUtilityBill($utility, $billId);
                if ($result && isset($result['bill'])) {
                    $paid = updateBill($result['bill'], $amountPaid);
                    $totalPaid += $paid;
                    $paidBills[] = $billId;
                    updateReadingStatus($result['reading']);
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

// === Record Payment ===
if (!isset($xml->payments)) {
    $xml->addChild('payments');
}
$payment = $xml->payments->addChild('payment');
$payment->addChild('renterId', $renterId);
$payment->addChild('paymentType', $billType);
$payment->addChild('paymentAmountType', htmlspecialchars($paymentAmountType));
$payment->addChild('paymentDate', $paymentDate);
$payment->addChild('amount', $amountPaid);
$payment->addChild('paymentMethod', htmlspecialchars($paymentMethod));
$payment->addChild('remarks', htmlspecialchars($paymentRemarks));
$payment->addChild('billIds', implode(',', $paidBills));
$payment->addChild('receiptNumber', htmlspecialchars($receiptNumber));

// === Save changes ===
$xml->asXML($xmlFile);

// === Redirect to billing page with success flag ===
header("Location: ../caretaker-billings.xml?pay=recorded");
exit;
?>
