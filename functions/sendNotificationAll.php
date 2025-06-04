<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML or create a new structure with <notifications>
if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    // Create root with <notifications> if file not found
    $xml = new SimpleXMLElement('<apartmentManagement><notifications></notifications><renters></renters></apartmentManagement>');
}

// Ensure <notifications> exists
if (!isset($xml->notifications)) {
    $xml->addChild('notifications');
}

// Ensure <renters> exists
if (!isset($xml->renters)) {
    exit('No renters found in XML.');
}

// Get form data safely from GET
$message = $_GET['message'] ?? '';
$currentPage = $_GET['current_page'] ?? '';

if (empty($message)) {
    exit('Missing message.');
}

// Find the last notification ID to increment from
$lastNotifId = 0;
foreach ($xml->notifications->notification as $notif) {
    $id = (int)$notif['id'];
    if ($id > $lastNotifId) {
        $lastNotifId = $id;
    }
}

$isRead = 'false'; // Default unread

// Loop through all renters and add notification for each
foreach ($xml->renters->renter as $renter) {
    $renterId = (string)$renter['id'] ?? '';
    if (empty($renterId)) {
        // Skip renters without ID
        continue;
    }

    $lastNotifId++;
    $notification = $xml->notifications->addChild('notification');
    $notification->addAttribute('id', $lastNotifId);
    $notification->addChild('renterId', htmlspecialchars($renterId));
    $notification->addChild('message', htmlspecialchars($message));
    $notification->addChild('isRead', $isRead);
}

// Save updated XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML.');
}

// Redirect or output success message
header("Location: ../caretaker-" . htmlspecialchars($currentPage) . ".xml?notification=added");
exit();
?>
