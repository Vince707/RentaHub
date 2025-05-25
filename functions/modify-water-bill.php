<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$xmlFile = '../apartment.xml';

if (!file_exists($xmlFile)) {
    exit('XML file not found.');
}
echo "XML file loaded.<br>";

$xml = simplexml_load_file($xmlFile);

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

$readingIdToModify = $_POST['readingId'] ?? null;
if ($readingIdToModify === null) {
    exit('Reading ID to modify not specified.');
}
echo "Reading ID to modify: $readingIdToModify<br>";

$dueDate = $_POST['monthDue'] ?? date('Y-m-d');
$totalBill = floatval(str_replace(',', '', $_POST['totalBill'] ?? '0'));
$status = 'Unpaid';

$renters = $_POST['renters'] ?? [];

if (empty($renters)) {
    exit('No renters data received.');
}
echo "Number of renters received: " . count($renters) . "<br>";

// Remove existing reading node using DOM to properly delete it
$domUtility = dom_import_simplexml($utility);
$readings = $domUtility->getElementsByTagName('reading');

$removed = false;
foreach ($readings as $readingNode) {
    if ($readingNode->getAttribute('id') == $readingIdToModify) {
        $domUtility->removeChild($readingNode);
        $removed = true;
        break;
    }
}

if (!$removed) {
    exit("Reading ID $readingIdToModify not found.");
}
echo "Existing reading with ID $readingIdToModify removed.<br>";

// Calculate total consumed cubic meters
$consumedM3Total = 0;
foreach ($renters as $renterId => $renter) {
    $consumed = floatval(str_replace(',', '', $renter['consumedM3'] ?? 0));
    $consumedM3Total += $consumed;
    echo "Renter ID $renterId consumed m³: $consumed<br>";
}
echo "Total consumed m³ calculated: $consumedM3Total<br>";

// Use today's date for readingDate
$readingDate = date('Y-m-d');
// Period end is 10th of current month
$periodEnd = date('Y-m-10');

echo "Reading Date: $readingDate<br>";
echo "Period End: $periodEnd<br>";
echo "Due Date: $dueDate<br>";
echo "Total Bill: $totalBill<br>";
echo "Status: $status<br>";

// Create new reading node with the same ID
$newReading = $utility->addChild('reading');
$newReading->addAttribute('id', $readingIdToModify);
$newReading->addChild('readingDate', htmlspecialchars($readingDate));
$newReading->addChild('periodEnd', htmlspecialchars($periodEnd));
$newReading->addChild('dueDate', htmlspecialchars($dueDate));
$newReading->addChild('consumedWaterTotal', $consumedM3Total);
$newReading->addChild('totalBill', $totalBill);
$newReading->addChild('status', $status);

$billsNode = $newReading->addChild('bills');

// Determine last bill ID for generating new IDs if needed
$lastBillId = -1;
foreach ($utility->reading as $rd) {
    foreach ($rd->bills->bill as $billNode) {
        $billIdNum = (int)preg_replace('/\D/', '', (string)$billNode['id']);
        if ($billIdNum > $lastBillId) $lastBillId = $billIdNum;
    }
}
$nextBillId = $lastBillId + 1;
echo "Last bill ID found: $lastBillId. Next bill ID starts at: $nextBillId<br>";

$once = true;
foreach ($renters as $renterId => $renter) {
    $bill = $billsNode->addChild('bill');
    $billIdStr = $renter['billId'] ?? null;
    if (!$billIdStr) {
        $billIdStr = "W" . $nextBillId++;
        echo "Generated new bill ID for renter $renterId: $billIdStr<br>";
    } else {
        echo "Using existing bill ID for renter $renterId: $billIdStr<br>";
    }
    $bill->addAttribute('id', $billIdStr);
    $bill->addChild('renterId', htmlspecialchars($renterId));
    $bill->addChild('currentReading', htmlspecialchars($renter['currentReading'] ?? ''));
    $bill->addChild('previousReading', htmlspecialchars($renter['previousReading'] ?? ''));
    $bill->addChild('consumedM3', htmlspecialchars($renter['consumedM3'] ?? ''));
    $bill->addChild('amount', htmlspecialchars(str_replace(',', '', $renter['total'] ?? '')));
    $bill->addChild('overpaid', 0);
    $bill->addChild('debt', 0);
    $bill->addChild('status', $status);

    if ($once) {
        $newReading->addChild('amountPerM3', htmlspecialchars(str_replace(',', '', $renter['amountPerM3'] ?? '')));
        $once = false;
    }
}

echo "All bills added.<br>";

// Save XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML file.');
} else {
    echo "XML file saved successfully.<br>";
}

// Redirect after success
header("Location: ../caretaker-billings.xml?waterbill=modified");
exit();
?>
