<?php
// File path
$xmlFile = '../apartment.xml';

// Load XML
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$accountId = $_POST['account_id'] ?? null;
$reason = $_POST['delete_reason'] ?? ''; // Optional if you want to pass a reason

if ($accountId === null) {
    die("Account ID is required.");
}

// === Update <user> status and add delete reason ===
$userFound = false;
foreach ($xml->users->user as $user) {
    if ((string)$user['id'] === $accountId) {
        $userFound = true;
        $user->status = 'Archived';

        // Add or update <deleteReason>
        if (isset($user->deleteReason)) {
            $user->deleteReason = htmlspecialchars($reason);
        } else {
            $user->addChild('deleteReason', htmlspecialchars($reason));
        }

        // Add or update <dateDeleted>
        $dateDeleted = date('Y-m-d');
        if (isset($user->dateDeleted)) {
            $user->dateDeleted = $dateDeleted;
        } else {
            $user->addChild('dateDeleted', $dateDeleted);
        }

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
header("Location: ../admin-accounts.xml?account=deleted");
exit();
?>
