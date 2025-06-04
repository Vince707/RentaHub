<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML
if (!file_exists($xmlFile)) {
    exit('XML file not found.');
}

$xml = simplexml_load_file($xmlFile);

// Ensure <rooms> exists
if (!isset($xml->rooms)) {
    exit('No rooms found in XML.');
}

// Get form data safely
$roomId = $_POST['room_id'] ?? '';
$roomNumber = $_POST['room_number'] ?? '';
$floorNumber = $_POST['floor_number'] ?? '';
$roomType = $_POST['room_type'] ?? '';
$size = $_POST['size'] ?? '';
$rentPrice = $_POST['rent_price'] ?? '';

if (empty($roomId) || empty($roomNumber) || empty($floorNumber) || empty($roomType) || empty($size) || empty($rentPrice)) {
    exit('Missing required room data.');
}

// Find the room to modify by matching id attribute
$roomToModify = null;
foreach ($xml->rooms->room as $room) {
    if ((string)$room['id'] === $roomId) {
        $roomToModify = $room;
        break;
    }
}

if ($roomToModify === null) {
    exit('Room not found.');
}

// Update room details
$roomToModify->roomNo = htmlspecialchars($roomNumber);
$roomToModify->floorNo = htmlspecialchars($floorNumber);
$roomToModify->roomType = htmlspecialchars($roomType);
$roomToModify->sizeSQM = htmlspecialchars($size);
$roomToModify->rentPrice = htmlspecialchars($rentPrice);

// Save updated XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML.');
}

// Redirect or output success message
header("Location: ../caretaker-room.xml?room=modified");
exit();
?>
