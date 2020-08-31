$UserOUs =@(
"OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Warsaw,OU=Vistra,DC=work,DC=local",
"OU=Wroclaw,OU=Vistra,DC=work,DC=local"
)

$When = (Get-Date).AddMonths(-2).Date

$users = foreach ($ou in $UserOUs){
   get-aduser -Filter {(Enabled -eq $true)-and (Created -ge $When)} -SearchBase $ou
}

$memberships = foreach ($user in $users){
   Get-ADPrincipalGroupMembership $user
}


$GroupName = "Email - All Staff Trinity MGW - Migrated to 365"
$GroupName = "Email - Global - International Expansion Staff"

$group1 = Get-ADGroupMember "Email - All Staff Trinity MGW - Migrated to 365"
$group2 = Get-ADGroupMember "Email - Global - International Expansion Staff"