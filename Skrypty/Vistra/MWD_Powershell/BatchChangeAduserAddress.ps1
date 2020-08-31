$streetAddress = "6-8 Corneliu Coposu Boulevard, 8th floor"
$postalCode = "030606"
$credential = Get-Credential -UserName "work.local\" -Message "work.local user credentials for account changes:"

get-aduser -server work.local -SearchBase "OU=Bucharest,OU=Romania,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -Filter * | set-aduser -Server work.local -Credential $credential -StreetAddress $streetAddress -PostalCode $postalCode

