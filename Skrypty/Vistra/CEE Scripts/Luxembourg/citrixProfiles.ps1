$CitrixServers = get-adcomputer -Filter {name -like "luxsrvctx*"}
$CitrixServers | Out-GridView
$script = {
    Get-ChildItem -path "C:\Users" -directory
}
foreach ($server in $CitrixServers) {
    Invoke-Command -ComputerName $CitrixServers.name  -ScriptBlock $script  
}


