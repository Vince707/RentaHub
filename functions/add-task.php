<?php
// File path
$xmlFile = '../apartment.xml';

// Load existing XML or create a new structure
if (file_exists($xmlFile)) {
    $xml = simplexml_load_file($xmlFile);
} else {
    // Add <tasks> root if not present
    $xml = new SimpleXMLElement('<apartmentManagement><users></users><renters></renters><tasks></tasks></apartmentManagement>');
    // If your XML might not have <tasks>, you may need to add it later (see below)
}

// === Ensure <tasks> exists ===
if (!isset($xml->tasks)) {
    $xml->addChild('tasks');
}

// === Generate new task ID ===
$lastTaskId = 0;
foreach ($xml->tasks->task as $task) {
    $id = (int)$task['id'];
    if ($id > $lastTaskId) {
        $lastTaskId = $id;
    }
}
$newTaskId = $lastTaskId + 1;

// === Get Form Data ===
$title         = $_POST['title']         ?? '';
$type          = $_POST['type']          ?? '';
$dueDate       = $_POST['due_date']      ?? '';
$concernedWith = $_POST['concerned_with']?? '';
$createdBy     = $_POST['created_by']    ?? ''; // e.g., user id or email
$dateCreated   = date('Y-m-d');

// === Add to <tasks> ===
$task = $xml->tasks->addChild('task');
$task->addAttribute('id', $newTaskId);
$task->addChild('title', htmlspecialchars($title));
$task->addChild('type', htmlspecialchars($type));
$task->addChild('dueDate', htmlspecialchars($dueDate));
$task->addChild('concernedWith', htmlspecialchars($concernedWith));
$task->addChild('createdBy', htmlspecialchars($createdBy));
$task->addChild('dateCreated', $dateCreated);
$task->addChild('status', 'Pending'); // Default status

// Save updated XML
$xml->asXML($xmlFile);

// Redirect or notify success
header("Location: ../caretaker-tasks.xml?task=added");
exit();
?>
