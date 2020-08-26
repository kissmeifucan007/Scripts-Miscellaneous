$OU = "OU=VFS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"
#
#get-aduser -Filter {(enabled -eq $true) } -SearchBase "OU=VFS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -Properties emailaddress,name |? ($_.emailaddress -eq "") |Out-GridView
#
#get-aduser -Filter * -SearchBase "OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -Properties emailaddress,name |? {$_.emailaddress -eq $null} | Out-GridView
#

function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}

# List all enabled users from OU
get-aduser -SearchBase $OU -Filter {enabled -eq $true} |
# find users where Name is created as "GivenName Surname" 
# replace diacritics with latin characters when checking
# this is attempt to filter out al "special" accounts
   Where-Object  {(Remove-StringLatinCharacters $_.name) -ne (Remove-StringLatinCharacters($_.GivenName + " "+$_.surname))} |
      select name,givenName,Surname,samaccountname | 
        Out-GridView