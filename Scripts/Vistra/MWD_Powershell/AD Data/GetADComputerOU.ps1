function Get-AdComputerOU {
param(
[Parameter(Mandatory,Position=0)]
[String]$adComputerName
)
   $OU = get-adcomputer $adComputerName | Select-Object -ExpandProperty distinguishedname
   Get-LowerOuFronString $OU
}


function Get-LowerOuFronString (){
param(
[Parameter(Mandatory,Position=0)]
[String]$OU
)
  $OU -creplace '^[^,]*,',''
}

Get-ADComputer wawsrvadmin001 -Properties *

$ou = Get-AdComputerOU "wawsrvadmin001" 
$ou = Get-LowerOuFronString $ou

Get-ADComputer -Filter {name -like "wawsrv*"} | Select-Object name | Measure-Object | Select-Object count


$ExportCsvSplatt = @{
   Path = "I:\IT_Scripts\MWD_Powershell\CSV\TrinityServers.csv"
   Encoding = "UTF8"
   Delimiter = ';'
   NoTypeInformation = $true
}

Get-ADComputer -Server trinitycs -Properties OperatingSystem,description,ipv4address -filter *| Where-Object {$_.operatingSystem -like "Windows Server*"}  | Select-Object name,operatingSystem,distinguishedName,ipv4address | export-csv @ExportCsvSplatt