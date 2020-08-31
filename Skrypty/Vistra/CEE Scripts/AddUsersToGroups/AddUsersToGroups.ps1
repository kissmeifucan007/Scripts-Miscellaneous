$OU = "OU=Warsaw,OU=Vistra,DC=work,DC=local"
$groups = @"
Tech Contractors
"@

$ReportPath = "C:\CEE scripts\AddUsersToGroups\AddedToGroupsReport.csv"
$TranscriptPath = "C:\CEE scripts\AddUsersToGroups\AddedToGroupsTranscript.txt"
$csvSplatt  = @{
   Encoding = "UTF8"
   Path = $ReportPath
   NoTypeInformation = $true
   Delimiter = ";"
   Append = $true
}



$groups = $groups.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
$users = Get-ADUser -SearchBase $OU -Filter {active -eq $true}

foreach ($group in $groups){
   $filter = "*$group*"
   $groupId = Get-ADGroup -Filter {name -like $filter} | select -ExpandProperty DistinguishedName
   $membes = Get-ADGroup -Identity $groupId| Get-ADGroupMember | select -ExpandProperty SamAccountName
   $notMembers = $users | Where-Object {$_.SamAccountName -notin $membes} | select SamAccountName, Name
   $usersToAdd = $notMembers | Out-GridView -PassThru -Title "Select all users to add to group: $group"
   Start-Transcript -Path $TranscriptPath -Append
   Add-ADGroupMember -Identity $groupId -Members ($usersToAdd | select -ExpandProperty SamAccountName) -Confirm
   Stop-Transcript
   $updatedGroupMemebers = Get-ADGroup -Identity $groupId| Get-ADGroupMember | select -ExpandProperty SamAccountName
   $updatedGroupMemebers | 
      select @{Name = "SamAccountName"; Expression = {$_}},@{Name = "AD Group Name"; Expression = {$group}}, @{Name = "AD Group Identity"; Expression = {$groupID}}  |
      Where-Object {$_.SamAccountName -notin $membes} |
      Export-Csv @csvSplatt
}

