$UserOUs =@(
"OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Warsaw,OU=Vistra,DC=work,DC=local",
"OU=Wroclaw,OU=Vistra,DC=work,DC=local"
)

$ContactOus = "OU=CEE,OU=Vistra,DC=work,DC=local" 
$GroupName = "Email - All Staff Trinity MGW - Migrated to 365"
# $GroupName = "Email - Global - International Expansion Staff"

function Get-UsersNotInGroup{
   [cmdletbinding()]
   param(
   [String[]]$UserOUs,
   [String[]]$ContactOus,
   [String]$GroupName
   )

$groupMembers = Get-ADGroup $GroupName -Properties members | select-object -ExpandProperty members

$users = foreach ($ou in $UserOUs){
   get-aduser -Filter {Enabled -eq $true} -SearchBase $ou | select-object -ExpandProperty DistinguishedName
}

$contacts = foreach ($ou in $ContactOus){
   Get-ADObject -Filter {objectclass -eq  "Contact"} -SearchBase $ou | select-object -ExpandProperty DistinguishedName
}

$all = $users + $contacts

$inGroup    = Compare-Object $groupMembers $all -IncludeEqual| where {$_.sideindicator -eq "=="} | select-object -ExpandProperty InputObject
$notInGroup = Compare-Object $groupMembers $all | where {$_.sideindicator -eq "=>"} | select-object -ExpandProperty InputObject


$groupMembers = Get-ADGroup  "Email - Global - International Expansion Staff" -Properties members | select-object -ExpandProperty members

$regex ="CN=(.*?$searchstring.+?)," 
$namesInGroup = foreach ($item in $inGroup){
  $item -match $regex |Out-Null
  $Matches[1]
}

$namesInGroup = $namesInGroup | sort -Unique

$regex ="CN=(.*?$searchstring.+?)," 
$namesNotInGroup = foreach ($item in $notinGroup){
  $item -match $regex |Out-Null
  $Matches[1]
}

$namesNotInGroup = $namesNotInGroup | sort -Unique

Compare-Object  $namesInGroup $namesNotInGroup | where {$_.sideindicator -eq "=>"} | select-object  inputobject
}

$result = Get-UsersNotInGroup -UserOUs $UserOUs -ContactOus $ContactOus -GroupName $GroupName
cls
$result

