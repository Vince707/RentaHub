<?php
// File path
$xmlFile = '../apartment.xml';

// Load XML
if (!file_exists($xmlFile)) {
    die("XML file not found.");
}
$xml = simplexml_load_file($xmlFile);

// === Get POST Data ===
$taskId = $_POST['task_id'] ?? null;
$title = $_POST['title'] ?? '';
$type = $_POST['type'] ?? '';
$dueDate = $_POST['due_date'] ?? '';
$concernedWith = $_POST['concerned_with'] ?? '';
$status = $_POST['status'] ?? 'Pending'; // Optional: allow status update, default to Pending

if ($taskId === null) {
    die("Task ID is required.");
}

// === Find and Update <task> ===
$taskFound = false;
foreach ($xml->tasks->task as $task) {
    if ((string)$task['id'] === $taskId) {
        $taskFound = true;

        $task->title = htmlspecialchars($title);
        $task->type = htmlspecialchars($type);
        $task->dueDate = htmlspecialchars($dueDate);
        $task->concernedWith = htmlspecialchars($concernedWith);
        $task->status = htmlspecialchars($status);

        // Optionally update dateModified
        $task->dateModified = date('Y-m-d');
        break;
    }
}

if (!$taskFound) {
    die("Task with ID $taskId not found.");
}

// === Save changes ===
$xml->asXML($xmlFile);

// === Redirect or notify success ===
header("Location: ../caretaker-tasks.xml?task=modified");
exit();
?>
