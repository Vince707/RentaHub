<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML or create a new structure with <notifications>
if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    // Create root with <notifications> if file not found
    $xml = new SimpleXMLElement('<apartmentManagement><notifications></notifications></apartmentManagement>');
}

// Ensure <notifications> exists
if (!isset($xml->notifications)) {
    $xml->addChild('notifications');
}

// Generate new notification ID
$lastNotifId = 0;
foreach ($xml->notifications->notification as $notif) {
    $id = (int)$notif['id'];
    if ($id > $lastNotifId) {
        $lastNotifId = $id;
    }
}
$newNotifId = $lastNotifId + 1;

// Get form data safely
$renterId = $_POST['renter_id'] ?? '';
$message = $_POST['message'] ?? '';
$currentPage = $_POST['current_page'] ?? '';

$isRead = 'false'; // Default unread

// Validate renterId and message (optional)
if (empty($renterId) || empty($message)) {
    exit('Missing renter ID or message.');
}

// Add new notification node
$notification = $xml->notifications->addChild('notification');
$notification->addAttribute('id', $newNotifId);
$notification->addChild('renterId', htmlspecialchars($renterId));
$notification->addChild('message', htmlspecialchars($message));
$notification->addChild('isRead', $isRead);

// // Save updated XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML.');
}

// Redirect or output success message
header("Location: ../caretaker-" . $currentPage . ".xml?notification=added");
exit();
?>