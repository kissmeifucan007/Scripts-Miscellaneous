$nameBase = read-host "Podaj początek nazwy komputera w domenie Work.local"
$nameBase +="*"
get-adcomputer -Server work.local -filter {name -like $nameBase} | select name