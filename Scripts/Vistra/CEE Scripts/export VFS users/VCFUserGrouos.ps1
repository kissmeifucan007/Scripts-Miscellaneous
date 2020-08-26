$exclude =@"
Administrator lokalny
Administratorzy
Administratorzy domeny
Administratorzy przedsiębiorstwa
Administratorzy schematu
Apps-EFR-rw
Apps-K-LEX-global-rw
Drukarki modyfikacja
EFRImport-g-rw
EFRLOG-global-rw
HELP-g-rw
Publiczny-global-rw
SQLServer2005DTSUser`$SERWER
SQLServer2005MSFTEUser`$SERWER`$AVS
SQLServer2005MSSQLServerADHelperUser`$SERWER
SQLServer2005MSSQLUser`$SERWER`$AVS
SQLServer2005NotificationServicesUser`$SERWER
SQLServer2005SQLAgentUser`$SERWER`$AVS
SQLServer2005SQLBrowserUser`$SERWER
SUZI-global-rw
szkolenia-g-ro
szkolenia-g-rw
Użytkownicy pulpitu zdalnego
all
Security - Intranet CEE Funds All Staff - Trusted Domain
Security - Policyhub Ofiz
AllAccess
Security – Policyhub Ofiz
SkillportUsers
SkillportLeadership
"@

$exclude = $exclude.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$ou = "OU=VFS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"
$fundUsers = get-aduser -SearchBase $ou -Filter *
$userGroups = @() 
foreach ($user in $fundUsers){
   $userGroups += Get-ADPrincipalGroupMembership $user.samaccountname | select @{n='Group Name';e={$_.name}}, @{n='User Name';e={$user.name}}
} 
$path = "C:\CEE scripts\export VFS users\VcfUserGrouops.csv"
$userGroups | Where-Object {$_.'group name' -notin $exclude} | export-csv -Path $path -Delimiter ";" -Encoding UTF8 -NoTypeInformation
