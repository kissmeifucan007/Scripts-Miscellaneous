$path = "\\plwafs01\inst$\SOFTWARE_installations\FOG\instalki\instalki 14.12.2018\BOMGAR"

$namehash =@{
   LUB = 'Lublin'
   POZ = 'Poznan'
   BUD = 'Budapest'
   WRO = 'Wroclaw'
   BUC = 'Bucharest'
   SOF = 'Sofia'
   KRA = 'Krakow'
   PRG = 'Prague'
   WAW = 'Warsaw'
}

$city = $namehash[(hostname).Substring(0,3)]
$bomgarpath = Join-Path $path $city
$bomgarpath = Join-Path $bomgarpath (Get-ChildItem  $bomgarpath -Filter "bomgar*.exe")[0].Name

if(!(Test-Path -Path $tempFolderPath )){
    New-Item -ItemType directory -Path $tempFolderPath
    Write-Host "Temp folder created"
}
else
{
  Write-Host "Temp folder already exists"
}

if(!(Test-Path -Path (join-path $tempFolderPath (Split-Path $bomgarpath -Leaf)))){
   copy $bomgarpath $tempFolderPath
}
else
{
  Write-Host "file already exists"
}

$bomgarExePath = join-path $tempFolderPath (Split-Path $bomgarpath -Leaf)
$StartProcessSplatt = @{
   FilePath = $bomgarExePath
   Verb = 'RunAs'
}


Start-Process @StartProcessSplatt
