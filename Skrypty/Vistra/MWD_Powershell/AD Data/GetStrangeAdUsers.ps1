$regex = "^([A-Z][a-z]+) ([A-Z][a-z]+)(-([A-Z][a-z]+))?$"
#$name = "JAan Kowalski-Nowak"
#$name -match $regex

function Remove-StringLatinCharacters {
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}



$DiacriticsUsers = Get-ADUser -SearchBase "OU=CEE,OU=Vistra,DC=work,DC=local" -Filter { enabled -eq $true } | Where-Object { $_.name -ne (Remove-StringLatinCharacters $_.name) } | Select-Object -ExpandProperty name
$SpecialUsers = Get-ADUser -SearchBase "OU=CEE,OU=Vistra,DC=work,DC=local" -Filter { enabled -eq $true } | Where-Object { ($_.name -notmatch $regex) -and ($_.name -notin $DiacriticsUsers) } | Select-Object name
$DiacriticsUsersWarsaw = Get-ADUser -SearchBase "OU=Warsaw,OU=Vistra,DC=work,DC=local" -Filter { enabled -eq $true } | Where-Object { $_.name -ne (Remove-StringLatinCharacters $_.name) } | Select-Object -ExpandProperty name
$SpecialUsersWarsaw = Get-ADUser -SearchBase "OU=Warsaw,OU=Vistra,DC=work,DC=local" -Filter { enabled -eq $true } | Where-Object { ($_.name -notmatch $regex) -and ($_.name -notin $DiacriticsUsers) } | Select-Object name
$ADGroups = Get-ADGroup -SearchBase "OU=CEE,OU=Vistra,DC=work,DC=local" -Properties description -Filter * | Select-Object name, distinguishedName | Out-GridView