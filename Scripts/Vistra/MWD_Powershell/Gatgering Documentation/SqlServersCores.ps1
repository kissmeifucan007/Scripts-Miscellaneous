Get-ADComputer wawsrvsql001 -Server work.local -Properties *

Get-WmiObject –class Win32_processor | select NumberOfCores


$GetAdComputerCsvSplatt = @{
   Server = "work.local"
   Properties = @{}
}

$SQLServers = @"
WAWSRVSQL001
WAWSRVSQL002
WAWSRVSQL006
WAWSRVSQL007
WAWSRVSQL008
WAWSRVSQL009
"@

$serverList = $terminalServers.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)


$credential = get-credential


$scriptBlock = {
    Get-WmiObject -Class Win32_Product | select @{name="Server";expression={hostname}},name,vendor,version 
}

$programs = foreach ($server in $serverList){
   $pssession = new-PSSession -ComputerName $server -Credential $credential
   Invoke-Command -Session $pssession -ScriptBlock $scriptBlock 
}

$programs

$csvExportPath = "I:\IT_Scripts\MWD_Powershell\CSV\TerminalServerApps.csv"

$ExportCsvSplatt = @{
   Path = $csvExportPath
   Encoding = "UTF8"
   Delimiter = ';'
   NoTypeInformation = $true}

$programs | Export-Csv @ExportCsvSplatt -Force 

start $csvExportPath 

