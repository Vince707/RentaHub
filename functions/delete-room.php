<?php
// File path
$xmlFile = '../apartment.xml';

// Load XML
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$roomId = $_POST['room_id'] ?? null;
$reason = $_POST['delete_reason'] ?? '';

if ($roomId === null) {
    die("Room ID is required.");
}

// === Update <room> status and add delete reason ===
$roomFound = false;
foreach ($xml->rooms->room as $room) {
    if ((string)$room['id'] === $roomId) {
        $roomFound = true;
        $room->status = 'Unavailable';

        // Add or update <deleteReason>
        if (isset($room->deleteReason)) {
            $room->deleteReason = htmlspecialchars($reason);
        } else {
            $room->addChild('deleteReason', htmlspecialchars($reason));
        }

        // Add or update <dateDeleted>
        $dateDeleted = date('Y-m-d');
        if (isset($room->dateDeleted)) {
            $room->dateDeleted = $dateDeleted;
        } else {
            $room->addChild('dateDeleted', $dateDeleted);
        }

        break;
    }
}

if (!$roomFound) {
    die("Room with ID $roomId not found.");
}

// === Save changes ===
if ($xml->asXML($xmlFile) === false) {
    die("Failed to save XML.");
}

// === Redirect or notify success ===
header("Location: ../caretaker-room.xml?room=deleted");
exit();
?>
