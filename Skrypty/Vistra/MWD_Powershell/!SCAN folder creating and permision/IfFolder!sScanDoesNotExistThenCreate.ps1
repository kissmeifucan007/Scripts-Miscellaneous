#run this script in admin powershell session

#this script autmaticly creates !Scan folders for all users in their home catalog \\10.10.10.110\homedir$\%username%
#if the catalog was already there than it does nothing and leaves it there

# step 1
Set-ExecutionPolicy unrestricted
# step 2
$basePath = "\\10.10.10.110\homedir$"
$folders = Get-ChildItem $basePath -Directory
# step 3
 foreach ($folder in $folders){
    $path =$folder.FullName+"\!Scan"
    If(!(test-path $path)){
      New-Item -ItemType Directory -Force -Path $path
}
}
#4
 Set-ExecutionPolicy restricted