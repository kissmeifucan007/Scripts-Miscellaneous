$example = "1 2 3 4 5 6 7 8 9 0".split(" ")

$example | select -first 3 -skip 3
$example | select -skiplast 3 | select -last 4