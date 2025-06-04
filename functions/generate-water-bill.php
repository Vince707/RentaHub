<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$xmlFile = '../apartment.xml';

if (file_exists($xmlFile)) {
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

// Determine new reading ID
$newReadingId = 0;
if (isset($utility->reading)) {
    foreach ($utility->reading as $readingNode) {
        $currentId = (int)$readingNode['id'];
        if ($currentId >= $newReadingId) {
            $newReadingId = $currentId + 1;
        }
    }
}

// Set readingDate to today
$readingDate = date('Y-m-d');

// Set periodEnd to 10th of current month or from POST
$periodEnd = $_POST['periodEnd'] ?? date('Y-m-10');

// Use posted due date or default to today
$dueDate = $_POST['monthDue'] ?? date('Y-m-d');

$status = 'Unpaid';

// Renters data from POST
$renters = $_POST['renters'] ?? [];

// Initialize totals
$consumedWaterTotal = 0;
$totalBill = 0;

// Create new reading node
$reading = $utility->addChild('reading');
$reading->addAttribute('id', $newReadingId);
$reading->addChild('readingDate', htmlspecialchars($readingDate));
$reading->addChild('periodEnd', htmlspecialchars($periodEnd));
$reading->addChild('dueDate', htmlspecialchars($dueDate));
$reading->addChild('amountPerCubicM', ''); // Will set from first renter below
$reading->addChild('consumedCubicMTotal', 0); // Will update after processing renters
$reading->addChild('totalBill', 0); // Will update after processing renters
$reading->addChild('status', $status);

$billsNode = $reading->addChild('bills');

$firstBill = true;

foreach ($renters as $renterId => $renterData) {
    $bill = $billsNode->addChild('bill');
    // Generate bill ID with prefix 'W' and unique number (e.g., newReadingId * 100 + renterId)
    $billId = 'W' . ($newReadingId * 100 + intval($renterId));
    $bill->addAttribute('id', $billId);

    $bill->addChild('renterId', htmlspecialchars($renterId));
    $bill->addChild('currentReading', htmlspecialchars($renterData['currentReading'] ?? ''));
    $bill->addChild('previousReading', htmlspecialchars($renterData['previousReading'] ?? ''));
    $bill->addChild('consumedCubic', htmlspecialchars(str_replace(',', '', $renterData['consumedM3'] ?? '')));
    $bill->addChild('amountPerCubicM', htmlspecialchars(str_replace(',', '', $renterData['amountPerM3'] ?? '')));
    $bill->addChild('amount', htmlspecialchars(str_replace(',', '', $renterData['total'] ?? '')));
    $bill->addChild('overpaid', '0');
    $bill->addChild('debt', '0');
    $bill->addChild('status', $status);

    // For the first bill, set reading's amountPerCubicM
    if ($firstBill) {
        $reading->amountPerCubicM = htmlspecialchars(str_replace(',', '', $renterData['amountPerM3'] ?? ''));
        $firstBill = false;
    }

    // Accumulate totals
    $consumedWaterTotal += floatval(str_replace(',', '', $renterData['consumedM3'] ?? 0));
    $totalBill += floatval(str_replace(',', '', $renterData['total'] ?? 0));
}

// Update totals in reading node
$reading->consumedCubicMTotal = $consumedWaterTotal;
$reading->totalBill = $totalBill;

// Save XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML file.');
}

// Redirect after processing
header("Location: ../caretaker-billings.xml?waterbill=added");
exit();
?>
