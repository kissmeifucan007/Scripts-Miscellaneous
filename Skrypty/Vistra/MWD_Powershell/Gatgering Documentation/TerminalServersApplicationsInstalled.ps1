$terminalServers = @"
wawsrvts001
WAWSRVTM001
WAWSRVTM002
WAWSRVTM003
WAWSRVTM004
WAWSRVTM005
WAWSRVTM006
WAWSRVTM007
WAWSRVTM008
WAWSRVTM009
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

