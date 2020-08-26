
$script = {
$start = (get-date).AddMinutes(-15)
$end = (get-date).AddMinutes(0)
Get-WinEvent -ComputerName AMSSRVDC004  -FilterHashTable @{ LogName = "Security"; StartTime = $start; EndTime = $end; ID = 4740 }}
$result = Invoke-Command -ComputerName wawsrvdc003 -ScriptBlock $script 
$result | select -ExpandProperty message

get-adcomputer -Filter {name -like "wawsrvdc*"}
Test-Connection WAWSRVDC001

Get-ADDomain | Select-Object  PDCEmulator
