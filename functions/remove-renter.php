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
$userId = $_POST['user_id'] ?? null;
$reason = $_POST['reason'] ?? '';
$leaseEnd = $_POST['lease_end'] ?? '';
$status = 'Archived';

// === Update <users> status ===
if ($userId !== null) {
    foreach ($xml->users->user as $user) {
        if ((string)$user['id'] === $userId) {
            $user->status = $status;
            break;
        }
    }
}

// === Update <renters> status, leaseEnd, and leavingReason ===
if ($renterId !== null) {
    foreach ($xml->renters->renter as $renter) {
        if ((string)$renter['id'] === $renterId) {
            $renter->status = $status;

            // Optional logs
            // echo "<script>console.log('Setting renter to Archived')</script>";

            // Set leaseEnd and reason
            $renter->rentalInfo->leaseEnd = htmlspecialchars($leaseEnd);
            $renter->rentalInfo->leavingReason = htmlspecialchars($reason);
            break;
        }
    }
}

// === Save changes ===
$xml->asXML($xmlFile);

// === Redirect or notify success ===
header("Location: ../caretaker-renter.xml?renter=archived");
exit();
?>
