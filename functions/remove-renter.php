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

// === Update <renters> status, leaseEnd, leavingReason and update room status ===
if ($renterId !== null) {
    foreach ($xml->renters->renter as $renter) {
        if ((string)$renter['id'] === $renterId) {
            $renter->status = $status;

            // Set leaseEnd and reason
            $renter->rentalInfo->leaseEnd = htmlspecialchars($leaseEnd);
            $renter->rentalInfo->leavingReason = htmlspecialchars($reason);

            // Get the unitId (room number) for this renter
            $unitId = (string)$renter->rentalInfo->unitId;

            // Update the room status to "Vacant"
            if (isset($xml->rooms)) {
                foreach ($xml->rooms->room as $room) {
                    if ((string)$room->roomNo === $unitId) {
                        $room->status = 'Vacant';
                        break;
                    }
                }
            }

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
