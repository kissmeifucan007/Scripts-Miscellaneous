$OUs = @("OU=WarsawDC,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local", "OU=Warsaw,OU=Vistra,DC=work,DC=local", "OU=Warsaw,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local")
$users = @()
foreach ($ou in $ous){
$users += get-aduser -filter * -SearchBase $ou -Properties *
}
$path = 'C:\CEE scripts\WarsawUsers.csv'
$users | export-csv -path $path -Delimiter ";" -NoTypeInformation -Encoding UTF8 -Force
start $path



