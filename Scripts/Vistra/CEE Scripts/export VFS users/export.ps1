#Listowanie przynale¿noœci do grup wszystkich
#u¿ytkowników znajduj¹cych siê w OU podanym w $args[0].
#Wynik wyœwietlany jest na ekran
#Skrypt ma argument wywo³ania $arg[0] gdzie:
#   $arg[0] - FQDN do OU
#   
#np. (w œrodowisku PowerShell):
#   .\LsUserGrp.ps1 "OU=USERS,DC=DOMENA,DC=CORP"
#
#(w œrodowisku cmd/commmand.com):
#   powersshell -file .\LsUserGrp.ps1
# "OU=USERS,DC=DOMENA,DC=CORP"
#
########################################################
#
 
function GetMemberOf 
{
    param([string]$Dom) 
    $strFilter = "(&(objectCategory=User))"
    $objDomain = New-Object System.DirectoryServices.DirectoryEntry  $Dom
    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher 
    $objSearcher.SearchRoot = $objDomain 
    $objSearcher.PageSize = 3000 
    $objSearcher.Filter = $strFilter 
    $objSearcher.SearchScope = "Subtree"
    $colResults = $objSearcher.FindAll() 
    #
    foreach ($objResult in $colResults){
    $objUser = $objResult.GetDirectoryEntry()
    $($objUser.DistinguishedName)
    ""
    $objUser.MemberOf
    "*"
    ""
    } 
}
 
$ldap="LDAP://"+$args[0]
GetMemberOf $ldap