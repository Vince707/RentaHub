<?php
    // File path
    $xmlFile = '../apartment.xml';

    // Check if XML file exists
    if (!file_exists($xmlFile)) {
        die("XML file not found.");
    }

    // Load XML file
    $xml = simplexml_load_file($xmlFile);
    if (!$xml) {
        die("Failed to load XML.");
    }

    // Sanitize and validate POST inputs
    $email = isset($_POST['email']) ? trim($_POST['email']) : '';
    $newPassword = isset($_POST['new_password']) ? trim($_POST['new_password']) : '';

    if (empty($email) || empty($newPassword)) {
        die("Missing email or password.");
    }

    // Find user by email and update password
    $userFound = false;
    foreach ($xml->users->user as $user) {
        if ((string)$user->email === $email) {
            $userFound = true;

            // Optionally: hash the password before saving
            // $user->password = password_hash($newPassword, PASSWORD_DEFAULT);

            // Or just escape and store plain text (not recommended for production)
            $user->password = htmlspecialchars($newPassword);
            break;
        }
    }

    if (!$userFound) {
        die("User not found.");
    }

    // Save updated XML
    if ($xml->asXML($xmlFile)) {
        // Redirect to login with success flag
        header("Location: ../login.html?login=changePassSuccess");
        exit();
    } else {
        die("Failed to save changes.");
    }
?>
