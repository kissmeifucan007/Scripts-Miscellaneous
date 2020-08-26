
$mailboxes = Import-Csv "C:\powershell\sharedMailboxes.csv"

ForEach($item in $Mailboxes)
{
 New-Remotemailbox "$items.name" -Userprincipalname "$item.upn" -PrimarySMTP "$item.email" -alias "$item.alias" -Shared

}