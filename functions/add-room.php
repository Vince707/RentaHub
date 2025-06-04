<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML or create a new structure with <rooms>
if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    // Create root with <rooms> if file not found
    $xml = new SimpleXMLElement('<apartmentManagement><rooms></rooms></apartmentManagement>');
}

// Ensure <rooms> exists
if (!isset($xml->rooms)) {
    $xml->addChild('rooms');
}

// Generate new room ID (max existing id + 1)
$lastRoomId = 0;
foreach ($xml->rooms->room as $room) {
    $id = (int)$room['id'];
    if ($id > $lastRoomId) {
        $lastRoomId = $id;
    }
}
$newRoomId = $lastRoomId + 1;

// Get form data safely
$roomNo    = $_POST['room_number']  ?? '';
$floorNo   = $_POST['floor_number'] ?? '';
$roomType  = $_POST['room_type']    ?? '';
$sizeSQM   = $_POST['size']         ?? '';
$rentPrice = $_POST['rent_price']   ?? '';

if (empty($roomNo) || empty($floorNo) || empty($roomType) || empty($sizeSQM) || empty($rentPrice)) {
    exit('Missing required room data.');
}

// Add new <room> node
$room = $xml->rooms->addChild('room');
$room->addAttribute('id', $newRoomId);
$room->addChild('roomNo', htmlspecialchars($roomNo));
$room->addChild('floorNo', htmlspecialchars($floorNo));
$room->addChild('roomType', htmlspecialchars($roomType));
$room->addChild('sizeSQM', htmlspecialchars($sizeSQM));
$room->addChild('rentPrice', htmlspecialchars($rentPrice));
$room->addChild('status', 'Available');  // Default status when adding a room
$room->addChild('deleteReason', '');     // Empty by default

// Save updated XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML.');
}

// Redirect or output success message
header("Location: ../caretaker-room.xml?room=added");
exit();
?>
