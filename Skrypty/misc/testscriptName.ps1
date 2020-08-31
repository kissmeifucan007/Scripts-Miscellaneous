$scriptName = [io.fileinfo]  $MyInvocation.mycommand.path  | % basename
$xamlName = $scriptName + ".xaml"
$xamlPath = Join-Path $PSScriptRoot $xamlName
Write-Host $xamlPath
