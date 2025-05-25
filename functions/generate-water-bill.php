<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$xmlFile = '../apartment.xml';

if (file_exists($xmlFile)) {
    echo "XML file found.<br>";
    $xml = simplexml_load_file($xmlFile);
} else {
    exit('XML file not found.');
}

// Find Water utility node
$utility = null;
foreach ($xml->billing->utilityBills->utility as $util) {
    if ((string)$util['type'] === 'Water') {
        $utility = $util;
        break;
    }
}
if (!$utility) {
    exit('Water utility not found in XML.');
}
echo "Water utility node found.<br>";

// Determine new reading ID
if (!isset($utility->reading)) {
    $newReadingId = 0;
    echo "No existing readings, starting at ID 0.<br>";
} else {
    $lastReadingId = -1;
    foreach ($utility->reading as $readingNode) {
        $id = (int)$readingNode['id'];
        if ($id > $lastReadingId) $lastReadingId = $id;
    }
    $newReadingId = $lastReadingId + 1;
    echo "Last reading ID: $lastReadingId, new reading ID: $newReadingId<br>";
}

// Set readingDate to today
$readingDate = date('Y-m-d');

// Set periodEnd to 10th of current month
$periodEnd = date('Y-m-10');

// Use posted due date or default to today
$dueDate = $_POST['monthDue'] ?? date('Y-m-d');

$status = 'Unpaid';

echo "Reading Date: $readingDate<br>";
echo "Period End: $periodEnd<br>";
echo "Due Date: $dueDate<br>";

$renters = $_POST['renters'] ?? [];

echo "Renters data received:<br>";
echo "<pre>" . print_r($renters, true) . "</pre>";

// Calculate total consumed water and total bill amount, removing commas
$consumedWaterTotal = 0;
$totalBill = 0;
foreach ($renters as $renter) {
    $consumedWaterTotal += floatval(str_replace(',', '', $renter['consumedM3'] ?? 0));
    $totalBill += floatval(str_replace(',', '', $renter['total'] ?? 0));
}
echo "Total consumed water (m3): $consumedWaterTotal<br>";
echo "Total Bill (sum of renters): $totalBill<br>";

// Create new reading node
$reading = $utility->addChild('reading');
$reading->addAttribute('id', $newReadingId);
$reading->addChild('readingDate', htmlspecialchars($readingDate));
$reading->addChild('periodEnd', htmlspecialchars($periodEnd));
$reading->addChild('dueDate', htmlspecialchars($dueDate));
$reading->addChild('consumedWaterTotal', $consumedWaterTotal);
$reading->addChild('totalBill', $totalBill);
$reading->addChild('status', $status);

$billsNode = $reading->addChild('bills');

// Determine next bill ID
$lastBillId = -1;
foreach ($utility->reading as $rd) {
    foreach ($rd->bills->bill as $billNode) {
        $billId = (int)preg_replace('/\D/', '', (string)$billNode['id']);
        if ($billId > $lastBillId) $lastBillId = $billId;
    }
}
$nextBillId = $lastBillId + 1;
echo "Last bill ID: $lastBillId, next bill ID: $nextBillId<br>";

// Add bill nodes for each renter
$once = true;
foreach ($renters as $renterId => $renter) {
    $bill = $billsNode->addChild('bill');
    $billIdStr = "W" . $nextBillId++; // Prefix W for Water bills
    $bill->addAttribute('id', $billIdStr);
    $bill->addChild('renterId', htmlspecialchars($renterId));
    $bill->addChild('currentReading', htmlspecialchars($renter['currentReading'] ?? ''));
    $bill->addChild('previousReading', htmlspecialchars($renter['previousReading'] ?? ''));
    $bill->addChild('consumedM3', htmlspecialchars($renter['consumedM3'] ?? ''));
    $bill->addChild('amountPerM3', htmlspecialchars(str_replace(',', '', $renter['amountPerM3'] ?? '')));
    $bill->addChild('amount', htmlspecialchars(str_replace(',', '', $renter['total'] ?? '')));
    $bill->addChild('overpaid', 0);
    $bill->addChild('debt', 0);
    $bill->addChild('status', $status);

    if ($once) {
        $reading->addChild('amountPerM3', htmlspecialchars(str_replace(',', '', $renter['amountPerM3'] ?? '')));
        $once = false;
    }

    echo "Added water bill for renter ID $renterId with bill ID $billIdStr<br>";
}

// Save XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML file.');
} else {
    echo "XML file saved successfully.<br>";
}

// Redirect after processing
header("Location: ../caretaker-billings.xml?waterbill=added");
exit();
?>
