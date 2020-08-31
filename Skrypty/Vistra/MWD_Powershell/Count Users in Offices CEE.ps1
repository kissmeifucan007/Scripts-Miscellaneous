$regex = "^\p{Lu}\p{Ll}+\s\p{Lu}\p{Ll}+.+$"

$OUsWork =@(
"OU=Bulgaria,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Czech Republic,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Hungary,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Romania,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Slovakia,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",

"OU=Krakow,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Poznan,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Wroclaw,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Lublin,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Warsaw,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=WarsawDC,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"

"OU=VFS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"

)

$OUTrinity = "OU=WA,OU=PL,OU=TRINITY,DC=trinitycs,DC=com"


$result = 
foreach ($ou in $OUsWork){
   $users = get-aduser -Filter {enabled -eq $true} -server work.local -SearchBase $ou -Properties *| ? {($_.name -match $regex) -and ($_.emailaddress -match ".+")}
   $row =$users.Count | Select-Object -Property @{Name = 'OU'; Expression = {$ou}},@{Name = 'Count'; Expression = {$_}}
   $row
   }

$users = get-aduser -Filter {enabled -eq $true} -server trinitycs -SearchBase $OUTrinity -Properties *| ? {($_.name -match $regex) -and ($_.emailaddress -match ".+")}  
$row = $users.Count | Select-Object -Property @{Name = 'OU'; Expression = {$OUTrinity}},@{Name = 'Count'; Expression = {$_}}
$result
$row 