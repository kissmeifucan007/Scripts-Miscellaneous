import-module msonline
Connect-MsolService

$users = @"
Ewa Piętka

Tomasz Lelewicz

Katarzyna Skrok

Agnieszka Kaźmierczak

Aneta Palacz

Anna Dawidziuk

Katarzyna Tarmas

Monika Naparty

Anna Mucko

Agnieszka Zwierz

Ivan Bondarchuk

Anna Warda

Beata Zajdowska

Marlena Adamczuk

Izabela Żórawska

Arleta Falasa

Piotr Żołądek

Katarzyna Maciak

Anna Gruca

Agnieszka Krasa
"@
$users = $users.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
$users.Count

$emails = foreach ($user in $users){
   get-aduser -Filter {name -like $user} -Properties emailaddress | select -ExpandProperty emailaddress
}

# "ofiz:ENTERPRISEPACK" is and E3 license

foreach ($email in $emails){
   get-MsolUser -UserPrincipalName $email | 
      select DisplayName,UserPrincipalName,@{n="Licenses Type";e={$_.Licenses.AccountSKUid}}
}

foreach ($email in $emails){
   Set-MsolUserLicense -UserPrincipalName $email -AddLicenses "ofiz:ENTERPRISEPACK"
}




#$licensesVCS = foreach ($email in $emailsVCS1){
#Get-MsolUser -UserPrincipalName $email | select DisplayName,UserPrincipalName,@{n="Licenses Type";e={$_.Licenses.AccountSKUid}}
#}
#
#$licensesVFS = foreach ($email in $emailsVFS1){
#Get-MsolUser -UserPrincipalName $email | select DisplayName,UserPrincipalName,@{n="Licenses Type";e={$_.Licenses.AccountSKUid}}
#}

