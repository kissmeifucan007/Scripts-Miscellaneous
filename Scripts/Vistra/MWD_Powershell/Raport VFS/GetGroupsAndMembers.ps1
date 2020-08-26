#zbiera grupy z kontenerka
$ou = 'OU=Security Groups VFS,OU=CEE,OU=Vistra,DC=work,DC=local'
$groups = Get-ADGroup -filter * -SearchBase $ou | sort name | Select -expandproperty name


#puszczamy sprawdzanie czlonkow
$result = foreach ($group in $groups){
Get-ADGroupMember $group -Recursive | select @{Name='Group'; Expression={$group}}, name, SamAccountName
}

#sypie errorem przy 1 grupie bo nazwa grupy w ad jest inna, to dodaje ja recznie
$result+=
Get-ADGroupMember SUZIi-ORGIN_FIZ | select @{Name='Group'; Expression={'SUZI-ORGIN_FIZ \ SUZIi-ORGIN_FIZ'}}, name, SamAccountName

#nie chciało mi się do CSV
$result | Out-GridView

#-Recursive powinno dodawać też grupy w wyszukiwanych grupach, nie wiem czy dało

#jakby tytuły w oudgrid view poprawnie ustawić 
##Get-ADGroupMember -identity "Ksiegowosc_OFIZ" -Recursive | select @{Name='Group'; Expression={'Ksiegowosc ofiz'}}, @{Name='Imie i nazwisko'; Expression={$_.name}}, @{Name='Login'; Expression={$_.SamAccountName}}