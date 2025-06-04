<?php
// File path
$xmlFile = '../apartment.xml';

// Load XML
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$accountId   = $_POST['account_id']   ?? null;
$email       = $_POST['email']        ?? '';
$password    = $_POST['password']     ?? '';
$accountRole = $_POST['account_role'] ?? '';
$status      = $_POST['status']       ?? 'Active'; // Default to Active if not provided

if ($accountId === null) {
    die("Account ID is required.");
}

// === Find and Update <user> ===
$userFound = false;
foreach ($xml->users->user as $user) {
    if ((string)$user['id'] === $accountId) {
        $userFound = true;

        $user->email = htmlspecialchars($email);

        // Optional: encrypt/hash password before saving
        // Here we use base64 encode for demonstration (not secure)
        if (!empty($password)) {
            $user->password = htmlspecialchars(base64_encode($password));
        }

        $user->userRole = htmlspecialchars($accountRole);
        $user->status = htmlspecialchars(ucfirst(strtolower($status)));

        // Optionally update dateModified or lastModified
        $user->dateModified = date('Y-m-d');
        break;
    }
}

if (!$userFound) {
    die("User with ID $accountId not found.");
}

// === Save changes ===
if ($xml->asXML($xmlFile) === false) {
    die("Failed to save XML.");
}

// === Redirect or notify success ===
header("Location: ../admin-accounts.xml?account=modified");
exit();
?>
