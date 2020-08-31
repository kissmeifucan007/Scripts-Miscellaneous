#connect to Office admin portal using Admin acc mail (ex. login!.admin@vistra.com)
Connect-MsolService
Get-AzureADSubscribedSku | Select SkuPartNumber

### Dla VCS ###
$list1 = @"
OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Users,OU=Warsaw,OU=Vistra,DC=work,DC=local
OU=Users,OU=Wroclaw,OU=Vistra,DC=work,DC=local
"@
$emailsVCS = $list1.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$emailsVCS1 = foreach ($ou in $emailsVCS){
Get-ADUser -SearchBase $ou -Filter {enabled -eq $true} | select -expandproperty UserPrincipalName
}

#$emailsVCS1 |Out-GridView

$licensesVCS = foreach ($email in $emailsVCS1){
Get-MsolUser -UserPrincipalName $email | select DisplayName,UserPrincipalName,@{n="Licenses Type";e={$_.Licenses.AccountSKUid}}
}

#$licensesVCS | Out-GridView

### Dla VFS ###
$list2 = @"
OU=VFS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local
"@
$emailsVFS = $list2.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$emailsVFS1 = foreach ($ou in $emailsVFS){
Get-ADUser -SearchBase $ou -filter {enabled -eq $true} | select -expandproperty UserPrincipalName
}

$licensesVFS = foreach ($email in $emailsVFS1){
Get-MsolUser -UserPrincipalName $email | select DisplayName,UserPrincipalName,@{n="Licenses Type";e={$_.Licenses.AccountSKUid}}
}


#$licensesVFS | Out-GridView
#export

$exportCSVSplat = @{
   Delimiter = ';'
   Encoding = "UTF8"
   NotypeInformation = $true
   Path = "\\10.10.1.3\inst$\DRIVERS_Servers\It\it\IT_Scripts\MWD_Powershell\O365licenses\licensesCEE.csv"
   Force = $true
}
$licensesVCS | Export-Csv @exportCSVSplat
#start $exportCSVSplat.Path


$exportCSVSplat2 = @{
   Delimiter = ';'
   Encoding = "UTF8"
   NotypeInformation = $true
   Path = "\\10.10.1.3\inst$\DRIVERS_Servers\It\it\IT_Scripts\MWD_Powershell\O365licenses\licensesVFS.csv"
   Force = $true
}
$licensesVFS | Export-Csv @exportCSVSplat2
#start $exportCSVSplat2.Path