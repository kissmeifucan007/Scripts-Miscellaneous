get-aduser wojewodam -properties proxyaddresses

get-aduser -SearchBase "OU=Sofia,OU=Bulgaria,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -properties proxyaddresses -filter *| select name,proxyaddresses | Out-GridView

get-aduser -SearchBase "OU=Lublin,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -properties proxyaddresses -filter *| select name,proxyaddresses | Out-GridView

get-aduser -SearchBase "OU=Lublin,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -filter * | select name
$SofiaUserNames = get-aduser -SearchBase "OU=Sofia,OU=Bulgaria,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -Filter * | select -ExpandProperty name

Get-ADObject -Filter {(ObjectClass -eq "Contact")} |where  {$_.Name -in $SofiaUserNames} | select *


