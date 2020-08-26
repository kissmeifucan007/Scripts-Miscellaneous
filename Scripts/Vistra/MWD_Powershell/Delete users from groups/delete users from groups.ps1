Import-Csv -Delimiter ";" -path "I:\IT_Scripts\MWD_Powershell\Delete users from groups\deleteusersgroups.csv"| ForEach-Object {Remove-ADGroupMember -identity $_.Group -Members $_.User} -ErrorAction SilentlyContinue $ConfirmPreference="high"


$usersToCheck = Import-Csv -Delimiter ";" -Path "I:\IT_Scripts\MWD_Powershell\Delete users from groups\deleteusersgroups.csv" 

$result  =  foreach ($entry in $usersToCheck){
  $entry | Select-Object user,group,@{Name = 'Contains'; Expression = {(Get-ADGroupMember -ErrorAction SilentlyContinue $entry.group).contains($entry.user)}}
  }

$result | export-csv -Delimiter ";" -path "I:\IT_Scripts\MWD_Powershell\Delete users from groups\deleteusersgroups2.csv"