$InitialPath = "\\amssrvfs001\nlusers$\"
$Domain = "work\"
$name = $null
$Path = $null
$Folders = $null
$Account = $null

#go to the users$ location and get the list of folders
cd $InitialPath
$Folders = dir | Get-Item

#Changing rights on all folders exept zz_OLD Users
foreach($name in $Folders.name)
    {
    if($name -notlike "zz_OLD Users")
        {
        $Path = $null
        $user = $null
        $Account = $null
        $Path = $InitialPath + $name
        $Account = $Domain + $name
        #Enable Inheritance so right are correctly setup in subfolders and files
        Enable-Inheritance -Path $Path
        #Clean all the ace exept the admins one
        Get-Ace -Path $Path | Where-Object { $_.ID -notlike "*admin*" } | Remove-Ace
        # Verify that the user exists ; if yes add the ace 
        $user = Get-ADUser -Identity $name
        if($user)
            {
            #Add the user with full rights
            Add-Ace -Path $Path -Account $Account -AccessRights FullControl -AccessType Allow -InheritanceFlags ObjectInherit,ContainerInherit
            }
        }
    }
    