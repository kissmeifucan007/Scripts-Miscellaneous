$mails = Get-ADuser -searchbase "OU=Warsaw,OU=Vistra,DC=work,DC=local" -Filter {enabled -eq $true} -Properties office | select name, office
$mails += Get-ADuser -searchbase "OU=Wroclaw,OU=Vistra,DC=work,DC=local" -Filter {enabled -eq $true} -Properties office | select name, office
$mails += Get-ADuser -searchbase "OU=poznan,OU=Vistra,DC=work,DC=local" -Filter {enabled -eq $true} -Properties office | select name, office
$mails += Get-ADuser -searchbase "OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" -Filter {enabled -eq $true} -Properties office | select name, office

$exportCSVSplat = @{
   Delimiter = ';'
   Encoding = "UTF8"
   NotypeInformation = $true
   Path = "\\10.10.1.3\it$\IT_Scripts\MWD_Powershell\users to offices\userstooffice.csv"
   Force = $true
}
$mails | Export-Csv @exportCSVSplat
start $exportCSVSplat.Path