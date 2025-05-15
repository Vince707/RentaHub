<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML or create a new one if it doesn't exist
if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    $xml = new SimpleXMLElement('<apartmentManagement><renters></renters></apartmentManagement>');
}

// Get the next ID
$lastId = 0;
foreach ($xml->renters->renter as $r) {
    $id = (int)$r['id'];
    if ($id > $lastId) {
        $lastId = $id;
    }
}
$newId = $lastId + 1;

// Sanitize and collect form data
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

// Add new renter
$renter = $xml->renters->addChild('renter');
$renter->addAttribute('id', $newId);
$renter->addChild('userId', $email);
$renter->addChild('status', 'active');

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

// Simple leaseEnd calculation: add contract months
$leaseEnd = date('Y-m-d', strtotime("{$leaseStart} +{$contractTerm} months"));
$rentalInfo->addChild('leaseEnd', $leaseEnd);

$rentalInfo->addChild('contractTermInMonths', htmlspecialchars($contractTerm));
$rentalInfo->addChild('leavingReason', '');

// Save XML
$xml->asXML($xmlFile);

header("Location: ../caretaker-renter.html"); 
exit();
?>
