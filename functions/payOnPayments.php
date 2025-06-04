<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

echo "<h2>--- PHP Payment Processing Debug (Server-Side) ---</h2>";

$xmlFile = '../apartment.xml';

if (file_exists($xmlFile)) {
    echo "<p>XML file found.</p>";
    $xml = simplexml_load_file($xmlFile);
} else {
    echo "<p style='color:red;'>Error: XML file not found.</p>";
    exit('XML file not found.');
}

// === Get POST Data ===
$renterId = $_POST['renter_id'] ?? null;
$billType = $_POST['payment_type'] ?? null; // 'Electricity', 'Water', or 'Rent'
$amountPaid = floatval($_POST['payment_amount'] ?? 0);
$paymentDate = $_POST['payment_date'] ?? date('Y-m-d');
$receiptNumber = $_POST['receipt_number'] ?? '';
$paymentMethod = $_POST['payment_method'] ?? '';
$paymentAmountType = $_POST['payment_amount_type'] ?? '';
$paymentRemarks = $_POST['payment_remarks'] ?? '';

echo "<h3>POST Data Received:</h3>";
echo "<pre>" . print_r($_POST, true) . "</pre>";
echo "<p>Parsed Data - renterId: " . htmlspecialchars((string)$renterId) . ", billType: " . htmlspecialchars((string)$billType) . ", amountPaid: " . htmlspecialchars((string)$amountPaid) . "</p>";

// Validate required fields
if (!$renterId || !$billType || $amountPaid <= 0) {
    echo "<p style='color:red;'>Error: Invalid input data. Missing renter ID, bill type, or payment amount is zero/negative.</p>";
    exit("Invalid input data.");
}

$totalPaid = 0;
$paidBills = [];

// Helper: Update a bill (partial/full/over)
function updateBill(&$bill, &$amountRemaining) {
    echo "<p>--- Entering updateBill function for bill ID: <strong>" . htmlspecialchars((string)$bill['id']) . "</strong> ---</p>";
    echo "<ul>";
    echo "<li>Initial Status: " . htmlspecialchars((string)$bill->status) . "</li>";
    echo "<li>Initial Debt: " . htmlspecialchars((string)($bill->debt ?? 0)) . "</li>";
    echo "<li>Amount Remaining for Payer to apply: " . htmlspecialchars((string)$amountRemaining) . "</li>";

    $origAmount = floatval($bill->amount);
    $origDebt = isset($bill->debt) ? floatval($bill->debt) : 0;

    if ((string)$bill->status === 'Paid') {
        echo "<li>Bill already marked 'Paid'. No update.</li>";
        echo "</ul>";
        return 0; // Already paid
    }

    $toPay = $origDebt > 0 ? $origDebt : $origAmount;
    echo "<li>Bill calculated amount to pay: " . htmlspecialchars((string)$toPay) . "</li>";


    if ($amountRemaining <= 0) {
        echo "<li>No amount remaining to apply for this bill.</li>";
        echo "</ul>";
        return 0; // No money left to pay
    }

    if ($amountRemaining < $toPay) {
        // Partial payment
        $bill->debt = $toPay - $amountRemaining;
        $bill->status = 'Partial';
        $bill->amount = $origAmount;
        $bill->overpaid = 0;
        $paid = $amountRemaining;
        $amountRemaining = 0;
        echo "<li>Result: Partial Payment. New debt: " . htmlspecialchars((string)$bill->debt) . ", Status: " . htmlspecialchars((string)$bill->status) . "</li>";
        echo "<li>Amount Applied to Bill: " . htmlspecialchars((string)$paid) . ", Amount Remaining for Payer: " . htmlspecialchars((string)$amountRemaining) . "</li>";
        echo "</ul>";
        return $paid;
    } else {
        // Full payment or overpayment
        $overpaid = $amountRemaining - $toPay;
        $bill->debt = 0;
        $bill->status = 'Paid';
        $bill->amount = $origAmount;
        $bill->overpaid = $overpaid;
        $paid = $toPay;
        $amountRemaining -= $toPay;
        echo "<li>Result: Full Payment or Overpayment. Overpaid: " . htmlspecialchars((string)$overpaid) . ", Status: " . htmlspecialchars((string)$bill->status) . "</li>";
        echo "<li>Amount Applied to Bill: " . htmlspecialchars((string)$paid) . ", Amount Remaining for Payer: " . htmlspecialchars((string)$amountRemaining) . "</li>";
        echo "</ul>";
        return $paid;
    }
}

// Helper: Update reading status based on child bills
function updateReadingStatus($reading) {
    echo "<p>--- Entering updateReadingStatus for reading ID: <strong>" . htmlspecialchars((string)$reading['id']) . "</strong> ---</p>";
    $allPaid = true;
    $anyPartial = false;
    $billStatuses = [];
    if (isset($reading->bills)) {
        foreach ($reading->bills->bill as $bill) {
            $status = (string)$bill->status;
            $billStatuses[] = $status;
            if ($status === 'Partial') $anyPartial = true;
            if ($status !== 'Paid') $allPaid = false;
        }
        echo "<li>Child Bill Statuses: " . htmlspecialchars(implode(', ', $billStatuses)) . "</li>";
        if ($allPaid) {
            $reading->status = 'Paid';
            echo "<li>Reading Status Set: Paid (All bills paid)</li>";
        } elseif ($anyPartial) {
            $reading->status = 'Partial';
            echo "<li>Reading Status Set: Partial (At least one bill partial)</li>";
        } else {
            $reading->status = 'Unpaid';
            echo "<li>Reading Status Set: Unpaid (No paid/partial bills)</li>";
        }
    } else {
        echo "<li>No 'bills' child element found for this reading.</li>";
    }
    echo "</p>";
}

// Find rent bills for renter with unpaid or partial status, sorted by dueDate ascending
function getRentBillsForRenter($xml, $renterId) {
    echo "<p>--- Searching for Rent Bills for Renter ID: <strong>" . htmlspecialchars($renterId) . "</strong> ---</p>";
    $bills = [];
    foreach ($xml->billing->rentBills->bill as $bill) {
        echo "<li>Checking Rent Bill ID: " . htmlspecialchars((string)$bill['id']) . "</li>";
        if ((string)$bill->renterId === (string)$renterId) {
            $status = (string)$bill->status;
            if ($status === 'Unpaid' || $status === 'Partial') {
                $dueDate = $bill->dueDate ? (string)$bill->dueDate : '9999-12-31';
                $bills[] = ['bill' => $bill, 'dueDate' => $dueDate];
                echo "<li>&nbsp;&nbsp;Match found! Bill ID: " . htmlspecialchars((string)$bill['id']) . ", Status: " . htmlspecialchars($status) . ", DueDate: " . htmlspecialchars($dueDate) . "</li>";
            } else {
                echo "<li>&nbsp;&nbsp;Skipping rent bill " . htmlspecialchars((string)$bill['id']) . " (Status: " . htmlspecialchars($status) . ").</li>";
            }
        }
    }
    usort($bills, fn($a, $b) => strcmp($a['dueDate'], $b['dueDate']));
    echo "<p>Sorted Rent Bills for Renter ID " . htmlspecialchars($renterId) . ":</p>";
    echo "<ul>";
    foreach($bills as $entry) {
        echo "<li>Bill ID: " . htmlspecialchars((string)$entry['bill']['id']) . ", DueDate: " . htmlspecialchars($entry['dueDate']) . "</li>";
    }
    echo "</ul>";
    return $bills;
}

// Find utility bills for renter with unpaid or partial status, sorted by reading dueDate ascending
// Returns array of ['bill' => billNode, 'reading' => readingNode, 'dueDate' => readingDueDate]
function getUtilityBillsForRenter($utility, $renterId) {
    echo "<p>--- Searching for Utility Bills (" . htmlspecialchars((string)$utility['type']) . ") for Renter ID: <strong>" . htmlspecialchars($renterId) . "</strong> ---</p>";
    $results = [];
    foreach ($utility->reading as $reading) {
        $readingDueDate = $reading->dueDate ? (string)$reading->dueDate : '9999-12-31';
        echo "<li>Checking utility reading ID: " . htmlspecialchars((string)$reading['id']) . ", DueDate: " . htmlspecialchars($readingDueDate) . "</li>";
        if (!isset($reading->bills)) {
            echo "<li>&nbsp;&nbsp;No bills found in reading " . htmlspecialchars((string)$reading['id']) . ".</li>";
            continue;
        }
        foreach ($reading->bills->bill as $bill) {
            echo "<li>&nbsp;&nbsp;Checking bill ID: " . htmlspecialchars((string)$bill['id']) . ", Renter ID: " . htmlspecialchars((string)$bill->renterId) . "</li>";
            if ((string)$bill->renterId === (string)$renterId) {
                $status = (string)$bill->status;
                if ($status === 'Unpaid' || $status === 'Partial') {
                    $results[] = ['bill' => $bill, 'reading' => $reading, 'dueDate' => $readingDueDate];
                    echo "<li>&nbsp;&nbsp;Match found! Bill ID: " . htmlspecialchars((string)$bill['id']) . ", Status: " . htmlspecialchars($status) . ", Reading ID: " . htmlspecialchars((string)$reading['id']) . ", Reading DueDate: " . htmlspecialchars($readingDueDate) . "</li>";
                } else {
                    echo "<li>&nbsp;&nbsp;Skipping utility bill " . htmlspecialchars((string)$bill['id']) . " (Status: " . htmlspecialchars($status) . ").</li>";
                }
            }
        }
    }
    usort($results, fn($a, $b) => strcmp($a['dueDate'], $b['dueDate']));
    echo "<p>Sorted Utility Bills for Renter ID " . htmlspecialchars($renterId) . ":</p>";
    echo "<ul>";
    foreach($results as $entry) {
        echo "<li>Bill ID: " . htmlspecialchars((string)$entry['bill']['id']) . ", Reading ID: " . htmlspecialchars((string)$entry['reading']['id']) . ", DueDate: " . htmlspecialchars($entry['dueDate']) . "</li>";
    }
    echo "</ul>";
    return $results;
}

echo "<h3>--- Main Payment Processing Logic ---</h3>";
$amountRemaining = $amountPaid;
echo "<p>Starting payment processing. Initial amountRemaining: $" . htmlspecialchars(number_format($amountRemaining, 2)) . ", Bill Type: <strong>" . htmlspecialchars((string)$billType) . "</strong></p>";


if ($billType === 'Rent') {
    $rentBills = getRentBillsForRenter($xml, $renterId);
    foreach ($rentBills as $entry) {
        if ($amountRemaining <= 0) {
            echo "<p>Amount remaining is zero or less. Stopping rent bill processing.</p>";
            break;
        }
        echo "<p>Attempting to apply payment to Rent Bill ID: <strong>" . htmlspecialchars((string)$entry['bill']['id']) . "</strong></p>";
        $paid = updateBill($entry['bill'], $amountRemaining);
        if ($paid > 0) {
            $totalPaid += $paid;
            $paidBills[] = (string)$entry['bill']['id'];
            echo "<p style='background-color:#e0ffe0;'>Applied $" . htmlspecialchars(number_format($paid, 2)) . " to rent bill " . htmlspecialchars((string)$entry['bill']['id']) . ". Total Paid: $" . htmlspecialchars(number_format($totalPaid, 2)) . ", Amount Remaining for Payer: $" . htmlspecialchars(number_format($amountRemaining, 2)) . "</p>";
        } else {
            echo "<p style='background-color:#fffbe0;'>No amount applied to rent bill " . htmlspecialchars((string)$entry['bill']['id']) . " (already paid or no remaining amount).</p>";
        }
    }
} elseif ($billType === 'Electricity' || $billType === 'Water') {
    // Find the utility node
    $utility = null;
    foreach ($xml->billing->utilityBills->utility as $util) {
        if ((string)$util['type'] === $billType) {
            $utility = $util;
            echo "<p>Found utility node for type: <strong>" . htmlspecialchars($billType) . "</strong></p>";
            break;
        }
    }
    if ($utility === null) {
        echo "<p style='color:red;'>Error: Utility type " . htmlspecialchars($billType) . " not found in XML.</p>";
        exit("Utility type not found.");
    }

    $utilityBills = getUtilityBillsForRenter($utility, $renterId);
    foreach ($utilityBills as $entry) {
        if ($amountRemaining <= 0) {
            echo "<p>Amount remaining is zero or less. Stopping utility bill processing.</p>";
            break;
        }
        echo "<p>Attempting to apply payment to " . htmlspecialchars($billType) . " Bill ID: <strong>" . htmlspecialchars((string)$entry['bill']['id']) . "</strong> (Reading ID: " . htmlspecialchars((string)$entry['reading']['id']) . ")</p>";
        $paid = updateBill($entry['bill'], $amountRemaining);
        if ($paid > 0) {
            $totalPaid += $paid;
            $paidBills[] = (string)$entry['bill']['id'];
            updateReadingStatus($entry['reading']);
            echo "<p style='background-color:#e0ffe0;'>Applied $" . htmlspecialchars(number_format($paid, 2)) . " to " . htmlspecialchars($billType) . " bill " . htmlspecialchars((string)$entry['bill']['id']) . ". Total Paid: $" . htmlspecialchars(number_format($totalPaid, 2)) . ", Amount Remaining for Payer: $" . htmlspecialchars(number_format($amountRemaining, 2)) . "</p>";
        } else {
            echo "<p style='background-color:#fffbe0;'>No amount applied to " . htmlspecialchars($billType) . " bill " . htmlspecialchars((string)$entry['bill']['id']) . " (already paid or no remaining amount).</p>";
        }
    }
} else {
    echo "<p style='color:red;'>Error: Invalid bill type ' " . htmlspecialchars((string)$billType) . "'.</p>";
    exit("Invalid bill type.");
}

if ($totalPaid <= 0) {
    echo "<p style='color:orange;'>Warning: No unpaid bills found for Renter ID " . htmlspecialchars((string)$renterId) . " of type " . htmlspecialchars((string)$billType) . ", or payment amount applied was zero. Total Paid: $" . htmlspecialchars(number_format($totalPaid, 2)) . "</p>";
    exit("No unpaid bills found or payment amount is zero.");
}

echo "<h3>--- Simulating Payment Record ---</h3>";
echo "<p>Payment record *would be* added to XML:</p>";
echo "<ul>";
echo "<li>Receipt Number: " . htmlspecialchars($receiptNumber) . "</li>";
echo "<li>Renter ID: " . htmlspecialchars((string)$renterId) . "</li>";
echo "<li>Payment Type: " . htmlspecialchars((string)$billType) . "</li>";
echo "<li>Payment Amount Type: " . htmlspecialchars((string)$paymentAmountType) . "</li>";
echo "<li>Payment Date: " . htmlspecialchars((string)$paymentDate) . "</li>";
echo "<li>Original Amount Paid: $" . htmlspecialchars(number_format($amountPaid, 2)) . "</li>";
echo "<li>Payment Method: " . htmlspecialchars((string)$paymentMethod) . "</li>";
echo "<li>Remarks: " . htmlspecialchars((string)$paymentRemarks) . "</li>";
echo "<li>Bill IDs Affected: " . htmlspecialchars(implode(', ', $paidBills)) . "</li>";
echo "</ul>";

echo "<h2>--- Payment Simulation Results: ---</h2>";
echo "<p><strong>Total Amount that would be paid:</strong> $" . htmlspecialchars(number_format($totalPaid, 2)) . "</p>";
echo "<p><strong>Bill IDs that would be affected:</strong> " . (empty($paidBills) ? "None" : htmlspecialchars(implode(', ', $paidBills))) . "</p>";
echo "<p style='color: red; font-weight: bold;'>Note: XML file has NOT been modified or saved in this debug mode.</p>";

// Removed XML saving and redirection
// $xml->asXML($xmlFile);
// header("Location: ../caretaker-billings.xml?pay=recorded");
// exit();
?>