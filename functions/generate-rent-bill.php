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
$amount = $_POST['amount'] ?? null;
$dueDate = $_POST['due_date'] ?? null;

if (!$renterId || !$amount || !$dueDate) {
    die("Missing required data.");
}

// === Ensure <rentBills> exists ===
if (!isset($xml->billing->rentBills)) {
    // Create <billing> and <rentBills> if missing
    if (!isset($xml->billing)) {
        $billing = $xml->addChild('billing');
    } else {
        $billing = $xml->billing;
    }
    $rentBills = $billing->addChild('rentBills');
} else {
    $rentBills = $xml->billing->rentBills;
}

// === Generate new bill ID ===
$lastBillNum = 0;
foreach ($rentBills->bill as $bill) {
    $id = (string)$bill['id'];
    if (preg_match('/R(\d+)/', $id, $matches)) {
        $num = (int)$matches[1];
        if ($num > $lastBillNum) {
            $lastBillNum = $num;
        }
    }
}
$newBillId = 'R' . ($lastBillNum + 1);

// === Add new bill ===
$newBill = $rentBills->addChild('bill');
$newBill->addAttribute('id', $newBillId);
$newBill->addChild('renterId', htmlspecialchars($renterId));
$newBill->addChild('amount', htmlspecialchars($amount));
$newBill->addChild('dueDate', htmlspecialchars($dueDate));
$newBill->addChild('overpaid', '0');
$newBill->addChild('debt', '0');
$newBill->addChild('status', 'Unpaid');

// === Save XML ===
if ($xml->asXML($xmlFile) === false) {
    die("Failed to save XML.");
}

// === Redirect or notify success ===
header("Location: ../caretaker-billings.xml?rentBill=generated");
exit();
?>
