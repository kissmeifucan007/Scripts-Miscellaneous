$unshared = get-content "C:\Users\mwojewoda\OneDrive - Sii Sp. z o.o\Documents\Vistra\unshared.txt" | select -Skip 1
$unshared | Out-GridView

$mailboxes  = foreach ($mail in $unshared){
   Get-Mailbox -Identity $mail
}

Import-Module ExchangeOnlineShell
$UserCredential = Get-Credential
Connect-ExchangeOnlineShell -Credential $UserCredential

Install-Module -Name ExchangeOnlineManagement

