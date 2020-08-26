Get-ChildItem -Path $PSScriptRoot -File | 
    foreach {get-filehash $_ -Algorithm MD5} |
    select hash, @{n="FileName";e={$_.path.split("\")[-1]}} |
    export-csv -Delimiter ";" -Path "$PSScriptRoot\Hashes.csv" -NoTypeInformation -Encoding UTF8 -Force
    Read-Host

