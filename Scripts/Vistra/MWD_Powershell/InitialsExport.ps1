get-aduser -properties initials,office,title -SearchBase "OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -Filter {office -eq "Warsaw"}| Where-Object {$_.title -like "*supervisor*"}| select name, initials,office | Out-GridView
get-aduser -Server trinitycs -filter * -properties title|where {$_.samaccountname.length -eq 3}| select samaccountname,name,title | export-csv -Encoding UTF8 -NoTypeInformation -Delimiter ";" -Path "I:\IT_Scripts\MWD_Powershell\csv\trinityInitials.csv"

