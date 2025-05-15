<?php
$xml = new DOMDocument();
$xml->load("test.xml");

$xsl = new DOMDocument();
$xsl->load("test.xsl");

$proc = new XSLTProcessor();
$proc->importStyleSheet($xsl);
    
$output = $proc->transformToXML($xml);

// Save result to a .php file
file_put_contents("generated_output.php", $output);

echo "PHP file generated! Click <a href='generated_output.php'>here</a> to run it.";
?>
