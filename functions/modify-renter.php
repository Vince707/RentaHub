<?php
// File path
$xmlFile = '../apartment.xml';

// Load XML
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$renterId = $_POST['renter_id'] ?? null;
$userId = $_POST['user_id'] ?? null;

$firstName = $_POST['first_name'] ?? '';
$middleName = $_POST['middle_name'] ?? '';
$surname = $_POST['surname'] ?? '';
$extName = $_POST['ext_name'] ?? '';
$contact = $_POST['contact_number'] ?? '';
$birthdate = $_POST['birthdate'] ?? '';
$idType = $_POST['valid_id_type'] ?? '';
$idNumber = $_POST['valid_id_number'] ?? '';
$room = $_POST['room_number'] ?? '';
$contractTerm = $_POST['contract_term'] ?? '';
$leaseStart = $_POST['lease_start'] ?? '';
$status = 'Active';
$leaseEnd = date('Y-m-d', strtotime("{$leaseStart} +{$contractTerm} months"));

// === Update <users> ===
foreach ($xml->users->user as $user) {
    if ((string)$user['id'] === $userId) {
        $user->status = $status;
        // If needed, update other user fields like email/password
        break;
    }
}

// === Update <renters> ===
foreach ($xml->renters->renter as $renter) {
    echo "<script>console.log('UPDATE ENTER')</script>";
    if ((string)$renter['id'] === $renterId) {
        echo "<script>console.log('UPDATE ENTER IF')</script>";
        $renter->status = $status;

        // Update personalInfo
        $renter->personalInfo->name->firstName = htmlspecialchars($firstName);
        $renter->personalInfo->name->middleName = htmlspecialchars($middleName);
        $renter->personalInfo->name->surname = htmlspecialchars($surname);
        $renter->personalInfo->name->extension = htmlspecialchars($extName);

        $renter->personalInfo->contact = htmlspecialchars($contact);
        $renter->personalInfo->birthDate = htmlspecialchars($birthdate);
        $renter->personalInfo->validId->validIdType = htmlspecialchars($idType);
        $renter->personalInfo->validId->validIdNumber = htmlspecialchars($idNumber);

        // Update rentalInfo
        $renter->rentalInfo->unitId = htmlspecialchars($room);
        $renter->rentalInfo->leaseStart = htmlspecialchars($leaseStart);
        $renter->rentalInfo->leaseEnd = htmlspecialchars($leaseEnd);
        $renter->rentalInfo->contractTermInMonths = htmlspecialchars($contractTerm);
        break;
    }
}

// === Save changes ===
$xml->asXML($xmlFile);

// === Redirect or notify success ===
header("Location: ../caretaker-renter.xml?renter=modified");
exit();
?>
