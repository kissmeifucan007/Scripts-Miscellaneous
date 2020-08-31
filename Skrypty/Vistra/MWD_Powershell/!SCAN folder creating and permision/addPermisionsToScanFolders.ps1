#1 runthis script as an administrator
Set-ExecutionPolicy unrestricted
#2
Install-Module -Name NTFSSecurity

#3 - Set to $homedir local path
$basePath = "\\10.10.10.110\homedir$\jablonskik"
$folders = Get-ChildItem $basePath -Directory

#4 - adding an account to a !scan folder
 foreach ($folder in $folders){
 #Add !Scan folder name to path
    $path =$folder.FullName+"\!Scan" 
    Add-NTFSAccess –Path $path –Account 'trinitycs\ceesrvscn' –AccessRights Full
 }

 #5 - Set execution policy back to restricted
 Set-ExecutionPolicy restricted
