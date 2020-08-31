#zainstalowanie modułu exchange online management

Install-Module PowershellGet -Force
Set-ExecutionPolicy RemoteSigned
Install-Module -Name ExchangeOnlineManagement
Update-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement; Get-Module ExchangeOnlineManagement

#połączenie się do exchange management
Connect-ExchangeOnline -ShowProgress $true

#sprawdzenie, który user ma włączoną funckję outlook on web
$prelist= @"
OU=Warsaw,OU=Vistra,DC=work,DC=local
OU=Wroclaw,OU=Vistra,DC=work,DC=local
OU=Poznan,OU=Vistra,DC=work,DC=local
OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local
"@
$OUs = $prelist.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
$mails =@()
foreach ($OU in $OUs){
$oumails = Get-ADUser -searchbase $OU -Filter {enabled -eq $true} | select -expandproperty userprincipalname
$mails += $oumails
}

$result = foreach ($mail in $mails){
Get-EXOCASMailbox $mail | select PrimarySmtpAddress, OWAEnabled
}

$result | Out-GridView


#wybranie z listy tylko wybranych użytkowników. W tym przypadku filter po OWA enabled = false
$owadisabled = $result | Out-GridView -PassThru
$owadisabled | Out-GridView

#włączenie użykownikom funkcji outlook on web
foreach ($email in $owadisabled){
$a = $email.PrimarySmtpAddress
Set-CASMailbox -Identity $a -OWAEnabled $true
}


#podłączenie się do modułu Azure Active directory
Import-Module AzureAD
Connect-AzureAD

#dodanie użytkowników do grupy "Security - AD Azure - Global O365 Webmail Users - In Cloud Users" w celu włączenia działania OWA (outlook web app)
$azureusers = foreach($mail in $mails){
Get-AzureADUser -ObjectId $mail | select UserPrincipalName, ObjectId
}

$Groupid = Get-AzureADGroup -SearchString "Security - AD Azure - Global O365 Webmail Users - In Cloud Users" | select -ExpandProperty ObjectId
foreach($user in $azureusers){
$userid = $user.ObjectId
Add-AzureADGroupMember -ObjectId $Groupid -RefObjectId $userid
}


#sprawdzenie członków grupy po dodaniu
$targetGroup = Get-AzureADGroup -Filter "DisplayName eq 'Security - AD Azure - Global O365 Webmail Users - In Cloud Users'"
$groupMembers = Get-AzureADGroupMember -ObjectId $targetGroup.ObjectId -All $true

$groupMembers | Out-GridView

#połączenie się do Exchange w celu zresetowania przypisanych numerów do Outlook Multi factor aythentication
Connect-MsolService
foreach($user in $azureusers){
$usermail = $user.userprincipalname
Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $usermail
}

#gotowe