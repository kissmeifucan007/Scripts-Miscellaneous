function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}

$TrinityUsersSplat = @{
   searchBase = "OU=PL,OU=TRINITY,DC=trinitycs,DC=com" 
   Filter= {(mail -eq "") -or (manager -eq "")}
   Server = "trinitycs"
   Properties = @("City","CN","co","Created","Department","Description","DisplayName","EmailAddress","facsimileTelephoneNumber","Fax","HomeDirectory","HomeDrive","Initials","LockedOut","logonCount","mail","Manager","Modified","msTSManagingLS","Name","Office","OfficePhone","PasswordNeverExpires","PostalCode","ProfilePath","SamAccountName","ScriptPath","sn","st","State","StreetAddress","Surname","telephoneNumber","Title","UserPrincipalName","whenChanged","whenCreated")
}



<#
$TrinityServersSplat = $TrinityComputersSplat.Clone()
$ScriptBlock = {description -like "Server*"}
$TrinityServersSplat['Filter'] = $ScriptBlock
$TrinityServersSplat.Add('Properties',"Description")
#>


$WorkUsersSplat = @{
   searchBase = "OU=CEE,OU=Vistra,DC=work,DC=local" 
   Filter= "*"
   Server = "work.local"
   Properties = @("City","CN","co","Created","Department","Description","DisplayName","EmailAddress","facsimileTelephoneNumber","Fax","HomeDirectory","HomeDrive","Initials","LockedOut","logonCount","mail","Manager","Modified","msTSManagingLS","Name","Office","OfficePhone","PasswordNeverExpires","PostalCode","ProfilePath","SamAccountName","ScriptPath","sn","st","State","StreetAddress","Surname","telephoneNumber","Title","UserPrincipalName","whenChanged","whenCreated")
}

$name = "Michał Wojewoda"


Get-ADPrincipalGroupMembership $workadmin | select name

$admins = Get-Content I:\IT_Scripts\MWD_Powershell\AmdminList.txt

foreach ($name  in $admins){
   $name = Remove-StringLatinCharacters -String $name
   $trinityUser  = get-aduser -filter {name -like $name}
   $trinityAdmin = get-aduser ("adm."+$trinityUser.samaccountName)
   $workUser  = get-aduser -filter {name -like $name} -Server work.local
   $workAdmin = get-aduser ($workUser.samaccountName+"!") -Server work.local

}

