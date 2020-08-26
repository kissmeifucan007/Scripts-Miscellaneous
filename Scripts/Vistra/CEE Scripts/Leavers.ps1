# Not applicable to CEE (except Warsaw) due to OU configuration

# 1.  Move user

# Get-Aduser
# Get-OU - Leavers OU
# Move User ; Confirm
# Scanned PDF issue

$city = Read-Host -Prompt "Enter user office name (for OU location)"
$name = Read-Host -Prompt "Enter user name (for AD Search)"

$name = "*$name*"
$OUBase = ",OU=Vistra,DC=work,DC=local"
$OU = "OU=$city$OUBase"
$leaversOU = "OU=Leavers,$OU"
$user = (get-aduser -SearchBase $OU -Filter {name -like $name} | Out-GridView -Title "Select the user account" -PassThru)

$ExpirationDate = (get-date).AddDays(2)
# 2
$user | Set-ADAccountExpiration -DateTime $ExpirationDate -Confirm 
# 1
$user | Move-ADObject -TargetPath $leaversOU  -Confirm 
# 3
$userGroups = $user | Get-ADPrincipalGroupMembership | where {$_.name -ne "Domain Users"}
# remove user from each group
$userGroups.foreach{
   $_ | Remove-ADGroupMember -Members $user -Confirm
}

$OnPremiseLeaversGroup = Get-ADGroup "Security - Mimecast - On-Premise Leaver Email Routing"
$ArchiveGroupNamePattern = "Security*$city* Archive Leavers"
$ArchiveLeaversGroup = get-adgroup -Filter {name -like $ArchiveGroupNamePattern} | Out-GridView -PassThru -Title "Select Archive Leavers group"

# select users' groups, except Domain Users
