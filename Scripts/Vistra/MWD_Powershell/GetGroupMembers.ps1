$groups = get-adgroup -SearchBase "OU=Warsaw,OU=Vistra,DC=work,DC=local" -filter {groupcategory -eq "Security"}
$csvPath = "I:\IT_Scripts\MWD_Powershell\CSV\groupMembers.csv"
$memberships 
foreach ($group in $groups){
   $memberships += Get-ADGroupMember $group | select @{Name='Group'; Expression={$group.Name}}, name, SamAccountName | export-csv -Encoding UTF8 -Delimiter ";" -NoTypeInformation -Append
}
