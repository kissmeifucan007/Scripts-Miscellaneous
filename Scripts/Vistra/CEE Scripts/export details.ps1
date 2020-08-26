#trinitycs.com/TRINITY/PL/WA
$ADUSR = Get-ADUser -SearchBase "OU=WA,OU=PL,OU=TRINITY,DC=trinitycs,DC=com" -SearchScope Subtree -Filter * -Properties * |select mail, physicalDeliveryOfficeName, department, streetAddress, l, st, postalCode, co
$ADUSR | Export-Csv C:\mbi migracja\PL_WA_out.csv

#trinitycs.com/CEE_USERS
$ADUSR = Get-ADUser -SearchBase "OU=CEE_USERS,DC=trinitycs,DC=com" -SearchScope Subtree -Filter * -Properties * |select mail, physicalDeliveryOfficeName, department, streetAddress, l, st, postalCode, co
$ADUSR | Export-Csv C:\mbi migracja\CEE_USERS_out.csv