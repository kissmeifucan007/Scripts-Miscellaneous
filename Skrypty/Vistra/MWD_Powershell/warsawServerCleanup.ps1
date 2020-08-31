$ip = "10.20.1.11"

[System.Net.Dns]::GetHostbyAddress($ip)

$servers = Get-ADComputer -Server work.local -Properties ipv4address,operatingsystem,description -Filter * | where {$_.ipv4address -like "10.10.10.*"} | select  name,ipv4address,operatingsystem,description 

($servers | measure).count
$servers | Out-GridView

$servers | Export-Csv -Delimiter ";" -Path "I:\IT_Scripts\MWD_Powershell\CSV\datacenterServers.csv" -NoTypeInformation -Encoding UTF8


Get-ADComputer wawsrvwsus001 -Properties * | Out-GridView


$wawservers =  get-adcomputer -Filter {name -like "wawsrv*"} -Server work.local -Properties ipv4address,operatingsystem,description

$servers | Export-Csv -Delimiter ";" -Path "I:\IT_Scripts\MWD_Powershell\CSV\WAWServers.csv" -NoTypeInformation -Encoding UTF8

foreach ($server in $wawservers){
   Test-Connection $server.ipv4address -Count 1 -ErrorAction SilentlyContinue| select @{name="Name";expression={$server.name}},ipv4address
}