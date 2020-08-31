import-module ActiveDirectory
$credential = Get-Credential 
$adConnection = @{
   Server = "work.local"
   Credential = $credential
}
get-aduser @adConnection muchak | Get-ADPrincipalGroupMembership @adConnection | select name | where {($_.name -notlike "*Friends*") -and ($_.name -notlike "*Domain Users*")}