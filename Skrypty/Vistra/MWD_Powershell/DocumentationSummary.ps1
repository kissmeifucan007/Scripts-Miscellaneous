
$CISplat = @{
   Path = "\\plwafs01\it$\IT_Documentation"
   Exclude = @("*.dll", "*.exe")
   File = $true
   Recurse = $true
}

$ExportCsvSplat = @{
   Delimiter = ";"
   Encoding = "UTF8"
   Path = "H:\exportCsv\DocumentationFiles.csv"
   Froce = $true
   NotypeInformation = $true
}

Get-ChildItem @CISplat | select name,directoryname | Export-Csv @ExportCsvSplat 

start $exportcsvsplat['Path']

