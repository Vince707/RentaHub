<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$xmlFile = '../apartment.xml';

if (!file_exists($xmlFile)) {
    exit('XML file not found.');
}

$xml = simplexml_load_file($xmlFile);
if ($xml === false) {
    exit('Failed to load XML file.');
}

// Check if tasks node exists
if (!isset($xml->tasks)) {
    exit('No tasks node found in XML.');
}

$taskId = $_POST['task_id'] ?? null;
if (!$taskId) {
    exit('Task ID not specified.');
}

$task = null;
foreach ($xml->tasks->task as $t) {
    if ((string)$t['id'] === $taskId) {
        $task = $t;
        break;
    }
}

if (!$task) {
    exit("Task with ID $taskId not found.");
}

// Update task status and completion date
$task->status = 'Completed';

// Optional: Add remarks if provided
if (!empty($_POST['remarks'])) {
    $task->remarks = htmlspecialchars($_POST['remarks']);
}

// Save XML
if ($xml->asXML($xmlFile)) {
    header("Location: ../caretaker-tasks.xml?complete=success");
    exit();
} else {
    exit('Failed to save XML file.');
}
?>
