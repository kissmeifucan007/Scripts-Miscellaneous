$CitrixServers = get-adcomputer -Filter {(name -like "luxsrvctx*") -and (enabled -eq $true)}
$script = {
    Get-ChildItem -path "C:\Users" | select @{n="Folder";e={$_.name}},@{n="Server";e={$env:computername}}
}
$workingServers = foreach ($server in $CitrixServers) {
   Test-Connection $server.name -Count 1 -ErrorAction SilentlyContinue 
   }

$credential = get-credential
$profileFolders = foreach ($server in $workingServers) {
    Invoke-Command -ComputerName $server.IPV4Address  -ScriptBlock $script -Credential $credential 
}
$profileFolders | Out-GridView

$disabledUsers = $profileFolders | select @{n="Folder";e={$_.folder -replace ".WORK", ""}} -Unique | select -ExpandProperty Folder| get-aduser -ErrorAction SilentlyContinue | Where-Object {$_.enabled -eq $false} | select -ExpandProperty samaccountname

$profilesToBeDeleted = foreach ($user in $disabledUsers){
   $profileFolders | Where-Object {$_.folder -like $user} | select folder,server,pscomputername 
}

$profilesToBeDeleted | Out-GridView