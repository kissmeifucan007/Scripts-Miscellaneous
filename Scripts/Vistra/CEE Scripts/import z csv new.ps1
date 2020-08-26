Import-Module ActiveDirectory 
#$users = Import-CSV -Delimiter ";" -Path "C:\mbi migracja\CEE_USERS_import.csv"
$users = Import-CSV -Delimiter ";" -Path "C:\mbi migracja\CEE_USERS_TEST.csv"
$users|Foreach{
Set-ADUSer -Identity $_.mail -Replace @{physicalDeliveryOfficeName=$_.physicalDeliveryOfficeName; department=$_.department; streetAddress=$_.streetAddress; l=$_.l; st=$_.st; postalCode=$_.postalCode}
};