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
BUILTIN\Administrators
CREATOR OWNER
NT AUTHORITY\SYSTEM
BIUROOFIZ1\Administratorzy domeny
"@

$exclude = $exclude.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)


Import-Module -Name NTFSSecurity
$path = "\\wawsrvfs002\groups$"
$folderlist = Get-ChildItem -Path $path -Directory| select -ExpandProperty fullname 
$table = @()
foreach ($folder in $folderlist){
   $accesss = Get-NTFSAccess -Path $folder | Where-Object {($_.IsInherited -ne $true) -and ($_.Account -notin $exclude)} 
   $table += $access
   foreach ($a in $accesss){
      $table += $a | select account,name, fullname, accesscontroltype,accessrights
   }

}
$path = "C:\CEE scripts\export VFS users\FolderAccessGroups.csv"
$table | select -Skip 1 | export-csv -Path $path -Delimiter ";" -Encoding UTF8 -NoTypeInformation 
