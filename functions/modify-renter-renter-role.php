<?php
// File path to your XML data
$xmlFile = '../apartment.xml';

// Load XML file
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}

libxml_use_internal_errors(true);
$xml = simplexml_load_file($xmlFile);
if ($xml === false) {
    // You might want to log these errors to a file in a production environment
    // instead of echoing them, as they could expose sensitive information.
    die("Failed to load XML file.");
}

// === Get POST Data ===
// Hidden IDs
$renterId = $_POST['renterId'] ?? null;
$userId = $_POST['userId'] ?? null;

// Personal Info
$firstName = $_POST['firstName'] ?? '';
$middleName = $_POST['middleName'] ?? '';
$surname = $_POST['surname'] ?? '';
$extName = $_POST['extName'] ?? '';
$contact = $_POST['contact'] ?? '';
$birthdate = $_POST['birthdate'] ?? '';
$idType = $_POST['idType'] ?? '';
$idNumber = $_POST['idNumber'] ?? '';

// User/Login Info
$email = $_POST['username'] ?? '';
$password = $_POST['password'] ?? ''; // IMPORTANT: Hash passwords before saving in production!

// Rental Info (assuming these come from other form fields)
$room = $_POST['roomNumber'] ?? '';
$contractTerm = $_POST['contractTerm'] ?? '';
$leaseStart = $_POST['leaseStart'] ?? '';

$status = 'Active';

// Calculate leaseEnd date based on leaseStart and contractTerm (months)
$leaseEnd = '';
if ($leaseStart && is_numeric($contractTerm) && $contractTerm > 0) {
    $leaseEnd = date('Y-m-d', strtotime("$leaseStart +$contractTerm months"));
}

// === Update <users> node ===
if ($userId) {
    foreach ($xml->users->user as $user) {
        if ((string)$user['id'] === $userId) {
            $user->status = $status;

            // Update email if provided and not empty
            if (isset($_POST['username']) && $_POST['username'] !== '') {
                $user->email = htmlspecialchars($email);
            }

            // Update password if provided and not empty
            if (isset($_POST['password']) && $_POST['password'] !== '') {
                // IMPORTANT: Consider hashing the password before saving for security
                $user->password = htmlspecialchars($password);
            }
            break;
        }
    }
}

// === Update <renters> node ===
if ($renterId) {
    foreach ($xml->renters->renter as $renter) {
        if ((string)$renter['id'] === $renterId) {
            $renter->status = $status;

            // Update personalInfo fields only if they are provided and not empty
            if (isset($_POST['firstName']) && $_POST['firstName'] !== '') {
                $renter->personalInfo->name->firstName = htmlspecialchars($firstName);
            }
            if (isset($_POST['middleName']) && $_POST['middleName'] !== '') {
                $renter->personalInfo->name->middleName = htmlspecialchars($middleName);
            }
            if (isset($_POST['surname']) && $_POST['surname'] !== '') {
                $renter->personalInfo->name->surname = htmlspecialchars($surname);
            }
            if (isset($_POST['extName']) && $_POST['extName'] !== '') {
                $renter->personalInfo->name->extension = htmlspecialchars($extName);
            }

            if (isset($_POST['contact']) && $_POST['contact'] !== '') {
                $renter->personalInfo->contact = htmlspecialchars($contact);
            }
            if (isset($_POST['birthdate']) && $_POST['birthdate'] !== '') {
                $renter->personalInfo->birthDate = htmlspecialchars($birthdate);
            }
            if (isset($_POST['idType']) && $_POST['idType'] !== '') {
                $renter->personalInfo->validId->validIdType = htmlspecialchars($idType);
            }
            if (isset($_POST['idNumber']) && $_POST['idNumber'] !== '') {
                $renter->personalInfo->validId->validIdNumber = htmlspecialchars($idNumber);
            }

            // Update rentalInfo fields only if they are provided and not empty
            if (isset($_POST['roomNumber']) && $_POST['roomNumber'] !== '') {
                $renter->rentalInfo->unitId = htmlspecialchars($room);
            }
            if (isset($_POST['leaseStart']) && $_POST['leaseStart'] !== '') {
                $renter->rentalInfo->leaseStart = htmlspecialchars($leaseStart);
            }

            // leaseEnd is calculated, so it should always be updated if leaseStart and contractTerm are valid
            if ($leaseStart && is_numeric($contractTerm) && $contractTerm > 0) {
                $renter->rentalInfo->leaseEnd = htmlspecialchars($leaseEnd);
            } else {
                 $renter->rentalInfo->leaseEnd = '';
            }

            if (isset($_POST['contractTerm']) && $_POST['contractTerm'] !== '') {
                $renter->rentalInfo->contractTermInMonths = htmlspecialchars($contractTerm);
            }

            // Ensure 'leavingReason' is always present, even if empty,
            // or if a corresponding input for it exists.
            $leavingReason = $_POST['leavingReason'] ?? ''; // Assuming you might have a form field for it
            $renter->rentalInfo->leavingReason = htmlspecialchars($leavingReason);

            break;
        }
    }
}

// === Save changes back to XML file ===
if ($xml->asXML($xmlFile) === false) {
    die("Failed to save XML file.");
}

// === Redirect or send success response ===
header("Location: ../renter-information.xml?renter=modified");
exit();
?>