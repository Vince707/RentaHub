<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML or create a new structure
if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    $xml = new SimpleXMLElement('<apartmentManagement><users></users><renters></renters></apartmentManagement>');
}

// === Generate new user ID ===
$lastUserId = 0;
foreach ($xml->users->user as $user) {
    $id = (int)$user['id'];
    if ($id > $lastUserId) {
        $lastUserId = $id;
    }
}
$newUserId = $lastUserId + 1;

// === Generate new renter ID ===
$lastRenterId = 0;
foreach ($xml->renters->renter as $renterNode) {
    $id = (int)$renterNode['id'];
    if ($id > $lastRenterId) {
        $lastRenterId = $id;
    }
}
$newRenterId = $lastRenterId + 1;

// === Get Form Data ===
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
$email = $_POST['email'] ?? '';
$password = $_POST['password']; // Default password, hash this in real apps
$userRole = 'Renter';
$status = 'Active';
$dateGenerated = date('Y-m-d');

// === Add to <users> ===
$user = $xml->users->addChild('user');
$user->addAttribute('id', $newUserId);
$user->addChild('email', htmlspecialchars($email));
$user->addChild('password', htmlspecialchars($password));
$user->addChild('dateGenerated', $dateGenerated);
$user->addChild('userRole', $userRole);
$user->addChild('status', $status);
$user->addChild('lastLogin', $dateGenerated);

// === Add to <renters> ===
$renter = $xml->renters->addChild('renter');
$renter->addAttribute('id', $newRenterId);
$renter->addChild('userId', $newUserId); // Link to user
$renter->addChild('status', $status);

$personalInfo = $renter->addChild('personalInfo');
$name = $personalInfo->addChild('name');
$name->addChild('surname', htmlspecialchars($surname));
$name->addChild('firstName', htmlspecialchars($firstName));
$name->addChild('middleName', htmlspecialchars($middleName));
$name->addChild('extension', htmlspecialchars($extName));

$personalInfo->addChild('contact', htmlspecialchars($contact));
$personalInfo->addChild('birthDate', htmlspecialchars($birthdate));

$validId = $personalInfo->addChild('validId');
$validId->addChild('validIdType', htmlspecialchars($idType));
$validId->addChild('validIdNumber', htmlspecialchars($idNumber));

$rentalInfo = $renter->addChild('rentalInfo');
$rentalInfo->addChild('unitId', htmlspecialchars($room));
$rentalInfo->addChild('leaseStart', htmlspecialchars($leaseStart));
$leaseEnd = date('Y-m-d', strtotime("{$leaseStart} +{$contractTerm} months"));
$rentalInfo->addChild('leaseEnd', $leaseEnd);
$rentalInfo->addChild('contractTermInMonths', htmlspecialchars($contractTerm));
$rentalInfo->addChild('leavingReason', '');

// Save updated XML
$xml->asXML($xmlFile);

// Redirect or notify success
header("Location: ../caretaker-renter.xml?renter=added");
exit();
?>
