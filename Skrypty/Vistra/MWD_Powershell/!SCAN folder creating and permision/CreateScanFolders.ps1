#Set to $homedir local path
$basePath = "E:\homedir"

$folders = Get-ChildItem $basePath -Directory


  foreach ($folder in $folders){
    $path =$folder.FullName+"\!Scan"
    if (!(Test-Path $path)){
       New-Item -path $path -ItemType Directory
    }
 }


 #Set execution policy back to restricted
 Set-ExecutionPolicy restricted
