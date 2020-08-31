#get-aduser mwd -Properties City, co| Export-Csv @exportCSVSplat

$TrinityUsersSplat = @{
   searchBase = "OU=PL,OU=TRINITY,DC=trinitycs,DC=com" 
   Filter= {(mail -eq "") -or (manager -eq "")}
   Server = "trinitycs"
   Properties = @("City","CN","co","Created","Department","Description","DisplayName","EmailAddress","facsimileTelephoneNumber","Fax","HomeDirectory","HomeDrive","Initials","LockedOut","logonCount","mail","Manager","Modified","msTSManagingLS","Name","Office","OfficePhone","PasswordNeverExpires","PostalCode","ProfilePath","SamAccountName","ScriptPath","sn","st","State","StreetAddress","Surname","telephoneNumber","Title","UserPrincipalName","whenChanged","whenCreated")
}

$TrinityComputersSplat = @{ 
   Filter= "*"
   Server = "trinitycs"
}

<#
$TrinityServersSplat = $TrinityComputersSplat.Clone()
$ScriptBlock = {description -like "Server*"}
$TrinityServersSplat['Filter'] = $ScriptBlock
$TrinityServersSplat.Add('Properties',"Description")
#>

$TrinityServersSplat = @{ 
   Filter= {OperatingSystem -like "*Server*"}
   Server = "trinitycs"
   Properties = @("OperatingSystem", "Description")
}



$WorkUsersSplat = @{
   searchBase = "OU=CEE,OU=Vistra,DC=work,DC=local" 
   Filter= "*"
   Server = "work.local"
   Properties = @("City","CN","co","Created","Department","Description","DisplayName","EmailAddress","facsimileTelephoneNumber","Fax","HomeDirectory","HomeDrive","Initials","LockedOut","logonCount","mail","Manager","Modified","msTSManagingLS","Name","Office","OfficePhone","PasswordNeverExpires","PostalCode","ProfilePath","SamAccountName","ScriptPath","sn","st","State","StreetAddress","Surname","telephoneNumber","Title","UserPrincipalName","whenChanged","whenCreated")
}


$WorkComputersSplat = @{
   searchBase = "OU=CEE,OU=Vistra,DC=work,DC=local" 
   Filter= "*"
   Server = "work.local"
   #Properties = @("City","CN","co","Created","Department","Description","DisplayName","EmailAddress","facsimileTelephoneNumber","Fax","HomeDirectory","HomeDrive","Initials","LockedOut","logonCount","mail","Manager","Modified","msTSManagingLS","Name","Office","OfficePhone","PasswordNeverExpires","PostalCode","ProfilePath","SamAccountName","ScriptPath","sn","st","State","StreetAddress","Surname","telephoneNumber","Title","UserPrincipalName","whenChanged","whenCreated")
}

$WorkServersSplat = $WorkComputersSplat.Clone()
$ScriptBlock = {name -like "*SRV*"}
$WorkServersSplat['Filter'] = $ScriptBlock

$exportCSVSplat = @{
   Delimiter = ';'
   Encoding = "UTF8"
   NotypeInformation = $true
   Path = "c:\dell\workUserProperties.csv"
}

$exportCSVNoPathSplat = @{
   Delimiter = ';'
   Encoding = "UTF8"
   NotypeInformation = $true
}


# get-aduser @getAduserSplat | Export-Csv @exportCSVSplat

get-aduser @TrinityUsersSplat | Group-Object -Property Office | Select Office,Count

$officeSummary = get-aduser @WorkUsersSplat | Group-Object -Property Office |Select-Object @{name="Office";expression={$_.Name}},Count

$officeSummary
$officeSummary | measure -Sum -Property count | select Sum

get-aduser @WorkSplat | Out-GridView

Get-ADComputer @WorkServersSplat | select name | measure | % { $_.Count }

Get-ADComputer @TrinityComputersSplat | select name | measure | % { $_.Count }

Get-ADComputer @TrinityServersSplat | select name,operatingSystem | measure | % { $_.Count }

Get-ADComputer @TrinityServersSplat | Group-Object -Property OperatingSystem | select @{name="OS";expression={$_.Name}},count |export-csv 
<#
$test = @{
   Filter = {samaccountname -eq "mwd"}
}

$ScriptBlock = {samaccountname -eq "adm.mwd"}
$ScriptBlock.GetType()
$test1 = $test.Clone()


$test1['Filter'] = 'samaccountname -eq "mwd"'

$test1['Filter'] = $ScriptBlock
$test1['Filter'].GetType()

Get-ADUser @test
Get-ADUser @test1
#>
