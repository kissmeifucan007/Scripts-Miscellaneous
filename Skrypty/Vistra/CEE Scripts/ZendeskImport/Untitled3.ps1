$users = get-aduser -filter{(passwordneverexpires -eq $true) -and (enabled -eq $true)}
$users  | Out-GridView
$users.Count

get-aduser marcaca -Properties *