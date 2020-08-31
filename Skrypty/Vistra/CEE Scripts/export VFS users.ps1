$SearchBase = "OU=VFS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"
$ADUSR = Get-ADUser -SearchBase $SearchBase -SearchScope Subtree -Filter * -Properties * |select givenName, sn, displayName, description, telephoneNumber, mail, streetAddress, l, st, postalCode, co
#$ADUSR | Export-Csv C:\script\exp_VFS_logins.csv
$ADUSR | Export-Csv C:\script\VFS_backup.csv