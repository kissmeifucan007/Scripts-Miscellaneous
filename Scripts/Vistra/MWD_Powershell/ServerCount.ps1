$OUs = @(
   "OU=CEE,OU=Vistra,DC=work,DC=local",
   "OU=Servers,OU=Amsterdam,OU=Vistra,DC=work,DC=local",
   "OU=Luxembourg,OU=Vistra,DC=work,DC=local"

)
$count =0
foreach ($ou in $OUs){
  $count +=(Get-ADComputer -server work.local -SearchBase $ou -Filter {operatingSystem -like "*server*"} -properties * | select name,operatingSystem | measure).Count
}
$count

# Get-ADComputer -server work.local luxsrvadmin01
