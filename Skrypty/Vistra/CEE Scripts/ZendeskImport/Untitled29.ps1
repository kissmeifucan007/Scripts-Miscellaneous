Get-ADGroup -SearchBase 'CN=Builtin,DC=work,DC=local' -Filter * | select name |Out-GridView

$credential = Get-Credential
$computerName = "zrhwrk102"
Enter-PSSession -ComputerName $computerName  -Credential $credential
