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
$reason = $_POST['delete_reason'] ?? '';
$status = 'Deleted'; // New status to mark as deleted

if ($taskId === null) {
    die("Task ID is required.");
}

// === Update <task> status and add delete reason ===
$taskFound = false;
foreach ($xml->tasks->task as $task) {
    if ((string)$task['id'] === $taskId) {
        $taskFound = true;
        $task->status = $status;

        // Optionally add or update a <deleteReason> element
        if (isset($task->deleteReason)) {
            $task->deleteReason = htmlspecialchars($reason);
        } else {
            $task->addChild('deleteReason', htmlspecialchars($reason));
        }

        // Optionally add a dateDeleted element
        $dateDeleted = date('Y-m-d');
        if (isset($task->dateDeleted)) {
            $task->dateDeleted = $dateDeleted;
        } else {
            $task->addChild('dateDeleted', $dateDeleted);
        }

        break;
    }
}

if (!$taskFound) {
    die("Task with ID $taskId not found.");
}

// === Save changes ===
$xml->asXML($xmlFile);

// === Redirect or notify success ===
header("Location: ../caretaker-tasks.xml?task=deleted");
exit();
?>
