$CitrixServers = get-adcomputer -Filter {(name -like "luxsrvctx*") -and (enabled -eq $true)}

$script = {
    Get-PSDrive -PSProvider FileSystem | Where-Object {($_.DisplayRoot -notlike '\\*') -and ($_.Root -notlike 'A*')} |
       select Root,@{n="Server";e={$env:computername}},@{n="Used (GB)";e={"{0:n2}" -f ($_.used / 1GB)}},@{n="Free (GB)";e={"{0:n2}" -f ($_.free / 1GB)}}, @{n="% Free";e={"{0:n2}" -f ($_.free/($_.free+$_.used)*100)}}
}

$workingServers = foreach ($server in $CitrixServers) {
   Test-Connection $server.name -Count 1 -ErrorAction SilentlyContinue 
}

$credential = get-credential
$diskSpaceUsed = foreach ($server in $workingServers) {
    Invoke-Command -ComputerName $server.IPV4Address  -ScriptBlock $script -Credential $credential 
}

$diskSpaceUsed | Out-GridView

