<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML
if (!file_exists($xmlFile)) {
    exit('XML file not found.');
}
$xml = simplexml_load_file($xmlFile);

// Get notification ID from POST
$notifId = $_POST['notif_id'] ?? '';
$currentPage = $_POST['current_page'] ?? 'notifications'; // default page if not provided

if (empty($notifId)) {
    exit('Notification ID is required.');
}

// Find the notification by ID and mark as read
$found = false;
if (isset($xml->notifications)) {
    foreach ($xml->notifications->notification as $notification) {
        if ((string)$notification['id'] === (string)$notifId) {
            $notification->isRead = 'true';
            $found = true;
            break;
        }
    }
}

if (!$found) {
    exit('Notification not found.');
}

// Save updated XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML.');
}

// Redirect back to the page, e.g., notifications listing page
header("Location: ../renter-" . htmlspecialchars($currentPage) . ".xml?notification=read");
exit();
