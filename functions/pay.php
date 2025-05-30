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
// --- FIX: Use the correct POST variable for overdue bill IDs ---
$overdueBillIds = isset($_POST['overdue_bill_ids']) ? array_filter(explode(',', $_POST['overdue_bill_ids'])) : [];
$paymentMethod = $_POST['payment_method'] ?? '';
$paymentAmountType = $_POST['payment_amount_type'] ?? '';
$paymentRemarks = $_POST['payment_remarks'] ?? '';

// Debug: Show all POST data
echo "<h3>Input Data</h3>";
echo "<pre>";
echo "Renter ID: " . htmlspecialchars($renterId) . "\n";
echo "Bill Type: " . htmlspecialchars($billType) . "\n";
echo "Bill ID: " . htmlspecialchars($billId) . "\n";
echo "Reading ID: " . htmlspecialchars($readingId) . "\n";
echo "Amount Paid: " . htmlspecialchars($amountPaid) . "\n";
echo "Payment Date: " . htmlspecialchars($paymentDate) . "\n";
echo "Receipt Number: " . htmlspecialchars($receiptNumber) . "\n";
echo "Overdue Bill IDs: " . htmlspecialchars(implode(', ', $overdueBillIds)) . "\n";
echo "Payment Method: " . htmlspecialchars($paymentMethod) . "\n";
echo "Payment Amount Type: " . htmlspecialchars($paymentAmountType) . "\n";
echo "Payment Remarks: " . htmlspecialchars($paymentRemarks) . "\n";
echo "</pre>";

if (!$renterId || $amountPaid <= 0) {
    echo "<p style='color:red;'>Error: Invalid payment data. Missing renter ID or payment amount.</p>";
    exit;
}

// Helper: Update a bill (partial/full/over)
function updateBill(&$bill, $amountPaid) {
    $origAmount = floatval($bill->amount);
    $origDebt = isset($bill->debt) ? floatval($bill->debt) : 0;
    $origOverpaid = isset($bill->overpaid) ? floatval($bill->overpaid) : 0;

    echo "Processing bill ID: " . $bill['id'] . "<br>";
    echo "Original Amount: $origAmount, Original Debt: $origDebt, Original Overpaid: $origOverpaid<br>";

    if ((string)$bill->status === 'Paid') {
        echo "Bill is already paid. Skipping.<br>";
        return 0;
    }

    $toPay = $origDebt > 0 ? $origDebt : $origAmount;
    if ($amountPaid < $toPay) {
        // Partial payment
        $bill->debt = $toPay - $amountPaid;
        $bill->status = 'Partial';
        $bill->amount = $origAmount;
        $bill->overpaid = 0;
        echo "Partial payment applied.<br>";
        echo "UPDATED: Bill Status: " . $bill->status . ", Remaining Debt: " . $bill->debt . ", Amount Paid: " . $amountPaid . "<br>";
        return $amountPaid;
    } else {
        // Full payment or overpayment
        $overpaid = $amountPaid - $toPay;
        $bill->debt = 0;
        $bill->status = 'Paid';
        $bill->amount = $origAmount;
        $bill->overpaid = $overpaid;
        echo "Full payment applied.<br>";
        echo "UPDATED: Bill Status: " . $bill->status . ", Overpaid Amount: " . $bill->overpaid . ", Amount Paid: " . $amountPaid . "<br>";
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
            echo "All bills in reading are paid. Setting reading status to Paid.<br>";
        } elseif ($anyPartial) {
            $reading->status = 'Partial';
            echo "Some bills in reading are partially paid. Setting reading status to Partial.<br>";
        } else {
            $reading->status = 'Unpaid';
            echo "No bills in reading are paid. Setting reading status to Unpaid.<br>";
        }
    }
}

// Find utility bill by ID and return [bill, reading]
function &findUtilityBill($utility, $billId) {
    foreach ($utility->reading as $reading) {
        if (isset($reading->bills)) {
            foreach ($reading->bills->bill as $bill) {
                if ((string)$bill['id'] === $billId) {
                    echo "Found bill ID: $billId in utility " . $utility['type'] . " reading ID: " . $reading['id'] . "<br>";
                    $result = ['bill' => $bill, 'reading' => $reading];
                    return $result;
                }
            }
        }
    }
    $null = null;
    echo "Bill ID: $billId not found in utility " . $utility['type'] . "<br>";
    return $null;
}

// Find rent bill by ID (using map key as ID)
function &findRentBill(&$xml, $billId) {
    foreach ($xml->billing->rentBills->bill as $bill) {
        // Use either the XML attribute or the map key as ID
        if ((string)$bill['id'] === $billId || (string)$bill->attributes()->id === $billId) {
            echo "Found rent bill ID: $billId<br>";
            return $bill;
        }
    }
    // Try fallback: use the key (since you use the map key as ID)
    foreach ($xml->billing->rentBills->bill as $bill) {
        if ((string)$billId === (string)$bill['id'] || (string)$billId === (string)$bill->attributes()->id) {
            echo "Found rent bill by map key: $billId<br>";
            return $bill;
        }
    }
    $null = null;
    echo "Rent bill ID: $billId not found.<br>";
    return $null;
}

// === Payment Logic ===
$totalPaid = 0;
$paidBills = [];

echo "<h3>Processing Payment</h3>";

if (!empty($overdueBillIds)) {
    echo "Processing overdue payment for bill IDs: " . implode(', ', $overdueBillIds) . "<br>";
    foreach ($overdueBillIds as $oid) {
        $oid = trim($oid);
        $found = false;
        // Electric
        foreach ($xml->billing->utilityBills->utility as $utility) {
            if ((string)$utility['type'] === 'Electricity') {
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
    echo "Processing single bill payment for bill ID: $billId<br>";
    if ($billType === 'Electricity' || $billType === 'Water') {
    echo "<p>Processing SINGLE utility bill payment for: <strong>$billType</strong></p>";
    echo "<p>Looking for bill ID: <strong>$billId</strong> in utility: <strong>$billType</strong></p>";
       foreach ($xml->billing->utilityBills->utility as $utility) {
        $utilityType = (string)$utility['type'];
        echo "<p>Checking utility: <strong>$utilityType</strong></p>";
        if ($utilityType === $billType) {
            echo "<p>Found matching utility: <strong>$utilityType</strong></p>";
            // ECHO ALL BILL IDs IN THIS UTILITY
            echo "<p>All bill IDs in this utility:</p>";
            foreach ($utility->reading as $reading) {
                if (isset($reading->bills)) {
                    foreach ($reading->bills->bill as $bill) {
                        echo "<p>Bill ID: " . (string)$bill['id'] . "</p>";
                    }
                }
            }
            $result = &findUtilityBill($utility, $billId);
            if ($result && isset($result['bill'])) {
                $paid = updateBill($result['bill'], $amountPaid);
                $totalPaid += $paid;
                $paidBills[] = $billId;
                updateReadingStatus($result['reading']);
                break;
            } else {
                echo "<p>Bill ID: <strong>$billId</strong> not found in utility: <strong>$utilityType</strong></p>";
            }
        }
    }
} elseif ($billType === 'Rent') {
    echo "<p>Processing SINGLE rent bill payment for bill ID: <strong>$billId</strong></p>";
    $bill = &findRentBill($xml, $billId);
    if ($bill) {
        $paid = updateBill($bill, $amountPaid);
        $totalPaid += $paid;
        $paidBills[] = $billId;
    } else {
    }
}

}

// === Record Payment ===
if (!isset($xml->payments)) {
    $xml->addChild('payments');
    echo "Created new payments section in XML.<br>";
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

// === Save changes ===
$xml->asXML($xmlFile);

// Redirect or notify success
header("Location: ../caretaker-billings.xml?pay=recorded");
exit();
?>
