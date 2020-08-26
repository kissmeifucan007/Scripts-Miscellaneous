$users = get-aduser -filter * -SearchBase "OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" | where {$_.enabled -eq "true"} | select DistinguishedName

foreach ($user in $users){
Unlock-ADAccount -Identity $user
}