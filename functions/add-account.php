<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML or create a new structure with only <users>
if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    // Create root with <users> if file not found
    $xml = new SimpleXMLElement('<apartmentManagement><users></users></apartmentManagement>');
}

// Ensure <users> exists
if (!isset($xml->users)) {
    $xml->addChild('users');
}

// Generate new user ID (max existing id + 1)
$lastUserId = 0;
foreach ($xml->users->user as $user) {
    $id = (int)$user['id'];
    if ($id > $lastUserId) {
        $lastUserId = $id;
    }
}
$newUserId = $lastUserId + 1;

// Get form data safely
$email       = $_POST['email']        ?? '';
$password    = $_POST['password']     ?? '';
$accountRole = $_POST['account_role'] ?? '';
$dateCreated = date('Y-m-d');

// Basic validation
if (empty($email) || empty($password) || empty($accountRole)) {
    exit('Missing required account data.');
}


// Add new <user> node
$user = $xml->users->addChild('user');
$user->addAttribute('id', $newUserId);
$user->addChild('email', htmlspecialchars($email));
$user->addChild('password', htmlspecialchars($password));
$user->addChild('dateGenerated', $dateCreated);
$user->addChild('userRole', htmlspecialchars($accountRole));
$user->addChild('status', 'Active');      // Default status
$user->addChild('lastLogin', '');         // Empty on creation

// Save updated XML
if ($xml->asXML($xmlFile) === false) {
    exit('Failed to save XML.');
}

// Redirect or output success message
header("Location: ../admin-accounts.xml?account=added");
exit();
?>
