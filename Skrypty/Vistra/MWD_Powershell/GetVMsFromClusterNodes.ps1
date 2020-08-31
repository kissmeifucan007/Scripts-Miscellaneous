$servers = @"
PLWAHV01
PLWAHV02
PLWAHV03
"@

# Remove new line characters and split server list into an array
$serverList = $servers.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$credential = Get-Credential

$i = 0
$VMs = foreach ($server in $serverList){
   Write-Progress -Activity "Getting VM info from server" -Status "Server # $i" -Id 1 -PercentComplete ([int](100*$i/$serverList.count)) -CurrentOperation "Current server: $server"
   $pssession = New-PSSession -ComputerName $server -Credential $credential
   Invoke-Command -Session $pssession -ScriptBlock {get-vm} | select *
}
 

