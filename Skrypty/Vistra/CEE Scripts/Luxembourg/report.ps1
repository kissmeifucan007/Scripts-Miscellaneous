$OU = "OU=Luxembourg,OU=Vistra,DC=work,DC=local"
$groups = Get-ADGroup -SearchBase $OU -Filter  {GroupCategory -eq "Security"}
$groups.count
$users = Get-ADUser -SearchBase $ou -Filter {enabled -eq $true}
$users.count

$result = $groups | ForEach-Object -Parallel{
   $group = $_
   Get-ADGroupMember $group | Select-Object @{n="Group";e={$group}},name,samaccountname,distinguishedName
}
 $result | Export-Csv -Path "C:\CEE scripts\luxReport.csv" -Encoding UTF8 -NoTypeInformation
 $enabledStatus = $result | select samaccountname -unique | foreach-object {get-aduser $_ | select samaccountame,enabled}

