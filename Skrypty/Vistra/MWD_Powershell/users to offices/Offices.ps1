$users = get-aduser -filter * -SearchBase  "OU=CEE,OU=Vistra,DC=work,DC=local" -Properties *
$users | Select department
$users | select office, streetAddress | group office, streetAddress -NoElement| select -ExpandProperty name | select @{Name = "Office"; Expression = {$_.split(',')[0]}}, @{Name = "StreetAddress"; Expression = {$_.split(',')[1]}}

Get-Object -Class Microsoft.ActiveDirectory.Management.ADUser -Property *

Get-WmiObject -Class win32_computersystem -Property *

[Microsoft.ActiveDirectory.Management.ADUser].GetProperties()

$users[0]

$user = get-aduser wojewodam -Properties *
$user.PropertyNames

$properties = $user.PropertyNames.split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
$userProperties = @()
foreach ($property in $properties){
  $user |select -ExpandProperty $property | select  @{name = "Property Name";expression={$property}}, @{name = "Property Value";expression={$_}} | where {"Property Value" -notin @("0","")}
}

$user | select $user.PropertyNames


$user | select $properties[10]