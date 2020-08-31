connect-azuread

$groups = Get-AzureADGroup | 
   Select MailEnabled,  DisplayName, Mail,SecurityEnabled  | 
   Where-Object {($_.SecurityEnabled -eq $true) -and ($_.MailEnabled -eq $true)} | 
   select 
$MailNonsecurityGroups = Get-AzureADGroup  -all $true| 
Select MailEnabled,  DisplayName, Mail,SecurityEnabled  | 
Where-Object {($_.SecurityEnabled -eq $false) -and ($_.MailEnabled -eq $true)} 
$MailNonsecurityGroups.count
$MailNonsecurityGroups | export-csv "Mail Groups Azure.csv"

$contacts = import-csv "adcontacts.csv" | Where-Object {$_.mail -ne ""} | select -ExpandProperty mail
$groups = $MailNonsecurityGroups | select @{n='Name';e={$_.DisplayName}},Mail | select -ExpandProperty mail
Compare-Object $contacts $groups | Where-Object {$_.sideIndicator -ne "=>"}
$contactsWithGroups = foreach($contact in $contacts){
    $percentComplete = $i/$contacts.count /100
    Write-Progress -Activity "Finding contacts matching groups" -Status ("Complete: {0:n2}%" -f $percentComplete) -PercentComplete $percentComplete
    $MailNonsecurityGroups| Where-Object {$_.mail -eq $contact.mail}
    $i++
 }

 Get-AzureADGroup  |select * -first 1|where-object {$_.mail -eq 'yoozapistatus@vistra.com'}  


 Connect-MsolService


function Get-OtherCommandsFromModule {
    param(
    [string]$CommandName
    )
    Get-Command $CommandName |% {get-command -Module $_.module}
}

Get-OtherCommandsFromModule Connect-MsolService
Get-OtherCommandsFromModule Connect-MsolService | ? {$_.name -like "*group*"}

$groupMailAddresses = get-msolgroup -All| select emailaddress
$groupEmails = $groupMailAddresses | where {$_.emailaddress -ne $null} | select -ExpandProperty emailaddress |sort
$contacts = import-csv "adcontacts.csv" | select -ExpandProperty mail |sort
Compare-Object $groupEmails $contacts | ? {$_.sideIndicator  }

$groupEmails | out-file "exchangeOnlineGroups.csv" 

$matching = import-csv ".\GroupsMatchingAdContacts.csv"
$matching = $matching | select -ExpandProperty email
Connect-MsolService
$groupIds = Get-MsolGroup -all | select ObjectId,emailaddress| Where-Object {$_.emailaddress -in $matching}
Get-MsolGroupMember -groupobjectid $groupIds[0].objectid
$memberships = $groupIds | select @{n='email';e={$_.emailaddress}}, @{n='members';e={Get-MsolGroupMember -groupobjectid $_.ObjectId }}

$list = foreach ($group in $memberships){
    $group.members | select @{n='Group Email';e={$group.email}},displayName,EmailAddress,GroupMemberType 
} 

$list | export-csv "membership summary.csv"
$groupids | export-csv "group ids.csv"