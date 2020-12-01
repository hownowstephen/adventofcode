<?php

$instructions = array();

$handle = fopen($argv[1], "r");
if (!$handle) {
    echo "error opening file. please specify a file with instructions";
    exit;
}


while (($line = fgets($handle)) !== false) {
    // process the line read.
    array_push($instructions, intval($line));
}
fclose($handle);

// $instructions = [0, 3, 0, 1, -3];

$instructions2 = $instructions;

$counter = 0;
$i = 0;
while($i<sizeof($instructions) && $i >= 0){

    $incr = $instructions[$i];
    $instructions[$i]++;
    $i += $incr;
    $counter++;
}

echo "part1: " . $counter . "\n";

$counter = 0;
$i = 0;
while($i<sizeof($instructions2) && $i >= 0){

    $incr = $instructions2[$i];
    if($incr >= 3){
        $instructions2[$i]--;
    }else{
        $instructions2[$i]++;
    }
    $i += $incr;
    $counter++;
}

echo "part2: " . $counter . "\n";

?>