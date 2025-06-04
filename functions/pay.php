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
$readingId = $_POST['reading_id'] ?? null; // This is for single bill payments
$amountPaid = floatval($_POST['payment_amount'] ?? 0);
$paymentDate = $_POST['payment_date'] ?? date('Y-m-d');
$receiptNumber = $_POST['receipt_number'] ?? '';
$overdueBillIds = isset($_POST['overdue_bill_ids']) ? array_filter(explode(',', $_POST['overdue_bill_ids'])) : [];
// Ensure readingBillIds correctly maps to overdueBillIds by index
$readingBillIds = isset($_POST['overdue_reading_ids']) ? array_filter(explode(',', $_POST['overdue_reading_ids'])) : [];
$paymentMethod = $_POST['payment_method'] ?? '';
$paymentAmountType = $_POST['payment_amount_type'] ?? '';
$paymentRemarks = $_POST['payment_remarks'] ?? '';

// Initialize variables
$totalPaid = 0;
$paidBills = [];

if (!$renterId || $amountPaid <= 0) {
    // Error: Invalid payment data. Missing renter ID or payment amount.
    // In a production environment, you might log this error or redirect to an error page.
    exit;
}

// Helper: Update a bill (partial/full/over)
function updateBill(&$bill, $amountPaid) {
    $origAmount = floatval($bill->amount);
    $origDebt = isset($bill->debt) ? floatval($bill->debt) : 0;

    if ((string)$bill->status === 'Paid') {
        return 0; // Bill already paid, no amount applied
    }

    $toPay = $origDebt > 0 ? $origDebt : $origAmount;

    if ($amountPaid < $toPay) {
        // Partial payment
        $bill->debt = $toPay - $amountPaid;
        $bill->status = 'Partial';
        $bill->amount = $origAmount; // Amount remains the original total
        $bill->overpaid = 0;
        return $amountPaid; // Return the amount that was actually applied
    } else {
        // Full payment or overpayment
        $overpaid = $amountPaid - $toPay;
        $bill->debt = 0;
        $bill->status = 'Paid';
        $bill->amount = $origAmount; // Amount remains the original total
        $bill->overpaid = $overpaid;
        return $toPay; // Return the amount required to pay off the bill
    }
}

// Helper: Update reading status based on all child bills
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

// Find utility bill by ID and return [bill, reading]
// Now accepts an optional expectedReadingId to narrow the search
function &findUtilityBill($utility, $billId, $expectedReadingId = null) {
    foreach ($utility->reading as $reading) {
        $currentReadingId = (string)$reading['id'];

        // If an expected reading ID is provided, only check bills within that reading
        if ($expectedReadingId !== null && $currentReadingId !== $expectedReadingId) {
            continue; // Skip to the next reading if it doesn't match the expected ID
        }

        if (isset($reading->bills)) {
            foreach ($reading->bills->bill as $bill) {
                if ((string)$bill['id'] === $billId) {
                    $result = ['bill' => $bill, 'reading' => $reading];
                    return $result;
                }
            }
        }
    }
    $null = null;
    return $null;
}

// Find rent bill by ID (using map key as ID)
function &findRentBill(&$xml, $billId) {
    foreach ($xml->billing->rentBills->bill as $bill) {
        if ((string)$bill['id'] === $billId || (string)$bill->attributes()->id === $billId) {
            return $bill;
        }
    }
    // Fallback: This part might be redundant if 'id' attribute is always used correctly.
    foreach ($xml->billing->rentBills->bill as $bill) {
        if ((string)$billId === (string)$bill['id'] || (string)$billId === (string)$bill->attributes()->id) {
            return $bill;
        }
    }
    $null = null;
    return $null;
}

// ---
// Main Payment Logic
// ---

if (!empty($overdueBillIds)) {
    // Processing as OVERDUE BILLS payment
    // IMPORTANT: This current logic applies the *entire* amountPaid to *each* found overdue bill.
    // If you intend to distribute `amountPaid` across `overdueBillIds` (e.g., pay smallest debts first),
    // you'll need to implement more complex payment distribution logic here.

    foreach ($overdueBillIds as $index => $oid) {
        $oid = trim($oid);
        $found = false;

        // Get the corresponding reading ID for this overdue bill ID
        // Ensure $readingBillIds has an element at this $index, otherwise, treat as unknown reading.
        $currentReadingId = $readingBillIds[$index] ?? null;

        // Electric
        foreach ($xml->billing->utilityBills->utility as $utility) {
            if ((string)$utility['type'] === 'Electricity') {
                // Pass the current reading ID to findUtilityBill
                $result = &findUtilityBill($utility, $oid, $currentReadingId);
                if ($result && isset($result['bill'])) {
                    $paid = updateBill($result['bill'], $amountPaid);
                    $totalPaid += $paid;
                    $paidBills[] = $oid;
                    updateReadingStatus($result['reading']);
                    $found = true;
                    break; // Bill found and updated, move to the next overdue bill ID
                }
            }
        }
        // Water
        if (!$found) {
            foreach ($xml->billing->utilityBills->utility as $utility) {
                if ((string)$utility['type'] === 'Water') {
                    // Pass the current reading ID to findUtilityBill
                    $result = &findUtilityBill($utility, $oid, $currentReadingId);
                    if ($result && isset($result['bill'])) {
                        $paid = updateBill($result['bill'], $amountPaid);
                        $totalPaid += $paid;
                        $paidBills[] = $oid;
                        updateReadingStatus($result['reading']);
                        $found = true;
                        break; // Bill found and updated, move to the next overdue bill ID
                    }
                }
            }
        }
        // Rent (Rent bills typically do not have associated reading IDs)
        if (!$found) {
            $bill = &findRentBill($xml, $oid);
            if ($bill) {
                $paid = updateBill($bill, $amountPaid);
                $totalPaid += $paid;
                $paidBills[] = $oid;
                // Rent bills don't have a parent reading to update status for, so no updateReadingStatus here.
            }
        }
    }
} else {
    // Processing as SINGLE BILL payment
    if ($billType === 'Electricity' || $billType === 'Water') {
        foreach ($xml->billing->utilityBills->utility as $utility) {
            $utilityType = (string)$utility['type'];
            if ($utilityType === $billType) {
                // For single utility payments, use the directly provided $readingId if available
                $result = &findUtilityBill($utility, $billId, $readingId);
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

// ---
// Record Payment
// ---

// === Record Payment ===
if (!isset($xml->payments)) {
    $xml->addChild('payments');
}
$payment = $xml->payments->addChild('payment');
$payment->addAttribute('id', htmlspecialchars($receiptNumber));
$payment->addChild('renterId', $renterId);
$payment->addChild('paymentType', $billType);
$payment->addChild('paymentAmountType', htmlspecialchars($paymentAmountType));
$payment->addChild('paymentDate', $paymentDate);
$payment->addChild('amount', $amountPaid); // This should be the original payment amount from the form
$payment->addChild('paymentMethod', htmlspecialchars($paymentMethod));
$payment->addChild('remarks', htmlspecialchars($paymentRemarks));
$payment->addChild('billIds', implode(',', $paidBills));

// ---
// Save Changes & Redirect
// ---

// === Save changes ===
// Uncomment these lines when you are ready to enable saving and redirection
$xml->asXML($xmlFile);
header("Location: ../caretaker-billings.xml?pay=recorded");
exit();
?>