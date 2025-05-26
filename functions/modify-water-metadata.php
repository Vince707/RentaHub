<?php
// File path
$xmlFile = '../apartment.xml';

// Load XML
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// Get POST Data
$accountName = $_POST['accountName'] ?? '';
$accountNumber = $_POST['accountNumber'] ?? '';
$meterNumber = $_POST['meterNumber'] ?? '';
$address = $_POST['address'] ?? '';

// Find the Water utility node
$utility = $xml->billing->utilityBills->xpath("utility[@type='Water']")[0];
if (!$utility) {
    die("Water utility not found.");
}

// Update accountInfo
$utility->accountInfo->accountName = $accountName;
$utility->accountInfo->accountNumber = $accountNumber;
$utility->accountInfo->meterNumber = $meterNumber;
$utility->accountInfo->address = $address;

// Save changes
$xml->asXML($xmlFile);

// Redirect or notify success
header("Location: ../caretaker-billings.xml?watermetadata=modified");
exit();
?>
