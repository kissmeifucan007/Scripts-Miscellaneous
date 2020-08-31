

$properties = @"
OfficePhone
telephoneNumber
facsimileTelephoneNumber
Fax
PostalCode
Manager
StreetAddress
Description
Title
State
GivenName
Name
EmailAddress
UserPrincipalName
Initials
co
Enabled
Company
Department
City
Office
Surname
SamAccountName
HomePage
wWWHomePage
"@

$properties = $properties.split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
$users =@()
$users +=get-aduser -SearchBase "OU=VFS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -Properties $properties -Filter {enabled -eq $true}
$users +=get-aduser -SearchBase "OU=Users,OU=Warsaw,OU=Vistra,DC=work,DC=local" -Properties $properties -Filter {enabled -eq $true}
$users | Out-GridView
