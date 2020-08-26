$ComputerName = Read-Host "Computer name (empty to read just number)"
if ($ComputerName -eq ""){
   $computerNumber = Read-Host "Computer Number"
   $ComputerName = "PL-D"+$computerNumber
   $ComputerName2 = "WAWWRK"+$computerNumber
}else{
   $ComputerName2 = $computerName
}


Set-Location '\\plwafs01\logs$\computers'
$ComputerName +=".csv"
$ComputerName2 +=".csv"
$users = Import-Csv -Delimiter ';' $ComputerName 
$users2 = Import-Csv -Delimiter ';' $ComputerName2 
$users |select username -Unique
$users2 |select username -Unique
Read-Host 
Read-Host 

#or

$computer2 = 'Wawwrkb659'
Get-ChildItem "\\$computer2\c$\Users" | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime -first 1

#or

$computers = @(
"Wawwrkb659",
"Wawwrkb398",
"Wawwrkb335",
"Wawwrkb367",
"Wawwrkb380"
)
foreach ($computer in $computers){
(Get-WmiObject -Class win32_process -ComputerName $computer | Where-Object name -Match explorer).getowner().user
}