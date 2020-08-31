#Install-Module -Name NTFSSecurity
#wymagane jest zainstalowanie modułu NTFSSecurity


Import-Module -Name NTFSSecurity
$path = "\\wawsrvfs002\groups$"
$folderlist = Get-ChildItem -Path $path | select -ExpandProperty fullname 
$table = @()
foreach ($folder in $folderlist){
$owner = Get-NTFSOwner -Path $folder | select -ExpandProperty owner
$info = [pscustomobject]@{
folder = $folder | Split-Path -Leaf
owner = $owner
}
$table += $info
}

$table | Out-GridView