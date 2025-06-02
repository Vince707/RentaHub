<?php
// C:\xampp3\htdocs\3Y2S\functions\generate-electric-bill.php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Start output buffering at the very beginning to prevent "headers already sent" errors
ob_start();

$xmlFile = '../apartment.xml';

if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    // If XML file not found, clean buffer and exit
    ob_end_clean();
    exit('XML file not found.');
}

// Find Electricity utility node
$utility = null;
foreach ($xml->billing->utilityBills->utility as $util) {
    if ((string)$util['type'] === 'Electricity') {
        $utility = $util;
        break;
    }
}
if (!$utility) {
    // If Electricity utility not found, clean buffer and exit
    ob_end_clean();
    exit('Electricity utility not found in XML.');
}

// Determine new reading ID
if (!isset($utility->reading)) {
    $newReadingId = 0;
} else {
    $lastReadingId = -1;
    foreach ($utility->reading as $readingNode) {
        $id = (int)$readingNode['id'];
        if ($id > $lastReadingId) $lastReadingId = $id;
    }
    $newReadingId = $lastReadingId + 1;
}

// Set readingDate to today
$readingDate = date('Y-m-d');

// Set periodEnd to 10th of current month
$periodEnd = date('Y-m-10');

// Use posted due date or default to today
$dueDate = $_POST['monthDue'] ?? date('Y-m-d');

$status = 'Unpaid';

$renters = $_POST['renters'] ?? [];

// Calculate total consumed kWh and total bill amount, removing commas
$consumedKwhTotal = 0;
$totalBill = 0;
foreach ($renters as $renter) {
    $consumedKwhTotal += floatval(str_replace(',', '', $renter['consumedKwh'] ?? 0));
    $totalBill += floatval(str_replace(',', '', $renter['total'] ?? 0));
}

// Create new reading node
$reading = $utility->addChild('reading');
$reading->addAttribute('id', $newReadingId);
$reading->addChild('readingDate', htmlspecialchars($readingDate));
$reading->addChild('periodEnd', htmlspecialchars($periodEnd));
$reading->addChild('dueDate', htmlspecialchars($dueDate));
$reading->addChild('consumedKwhTotal', $consumedKwhTotal);
$reading->addChild('totalBill', $totalBill);
$reading->addChild('status', $status);

$billsNode = $reading->addChild('bills');

// Determine next bill ID
$lastBillId = -1;
// Iterate through all existing readings to find the highest bill ID
foreach ($utility->reading as $rd) {
    if (isset($rd->bills->bill)) { // Ensure 'bill' exists before iterating
        foreach ($rd->bills->bill as $billNode) {
            // Extract numeric part of ID (e.g., "E123" -> 123)
            $billId = (int)preg_replace('/\D/', '', (string)$billNode['id']);
            if ($billId > $lastBillId) $lastBillId = $billId;
        }
    }
}
$nextBillId = $lastBillId + 1;

// Add bill nodes for each renter
$once = true; // Flag to add amountPerKwh only once per reading
foreach ($renters as $renterId => $renter) {
    $bill = $billsNode->addChild('bill');
    $billIdStr = "E" . $nextBillId++; // Increment for each new bill
    $bill->addAttribute('id', $billIdStr);
    $bill->addChild('renterId', htmlspecialchars($renterId));
    $bill->addChild('currentReading', htmlspecialchars($renter['currentReading'] ?? ''));
    $bill->addChild('consumedKwh', htmlspecialchars(str_replace(',', '', $renter['consumedKwh'] ?? ''))); // Ensure comma removal
    $bill->addChild('amount', htmlspecialchars(str_replace(',', '', $renter['total'] ?? ''))); // Ensure comma removal
    $bill->addChild('overpaid', 0);
    $bill->addChild('debt', 0);
    $bill->addChild('status', $status);

    if ($once) {
        $reading->addChild('amountPerKwh', htmlspecialchars(str_replace(',', '', $renter['amountPerKwh'] ?? '')));
        $once = false;
    }
}

// Save XML
if ($xml->asXML($xmlFile) === false) {
    // If saving fails, clean buffer and exit
    ob_end_clean();
    exit('Failed to save XML file.');
} else {
    // XML saved successfully.
    // Clean the buffer before redirection to ensure no accidental output
    ob_end_clean();
    header("Location: ../caretaker-billings.xml?electricbill=added");
    exit(); // Always exit after a header redirect
}
?>