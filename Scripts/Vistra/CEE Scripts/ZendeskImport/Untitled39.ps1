﻿ 
 $credential = get-credential 
$servers = @"
WAWSRVDC003
WAWSRVDC002
"@

# Remove new line characters and split server list into an array
$serverList = $servers.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$i = 0
$VMs += foreach ($server in $serverList){
   Write-Progress -Activity "Getting VM info from server" -Status "Server # $i" -Id 1 -PercentComplete ([int](100*$i/$serverList.count)) -CurrentOperation "Current server: $server"
   $pssession = New-PSSession -ComputerName $server -Credential $credential
   Invoke-Command -Session $pssession -ScriptBlock {get-vm} | select *

}

$vmEssentials = $VMs | select VMName,Name,computername,Path,Notes,Status,State,Generation,ProcessorCount,CreationTime,SizeOfSystemFiles,MemoryAssigned,MemoryMaximum,AutomaticStopAction,utomaticStartAction,SmartPagingFileInUse,IsClustered,DynamicMemoryEnabled

$vmEssentials | export-csv workVMs.csv -delimiter ";" -encoding utf8 -NoTypeInformation -Force
start workVMs.csv 