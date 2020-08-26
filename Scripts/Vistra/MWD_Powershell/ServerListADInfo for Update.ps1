$Servers = @"
PL-V1304
PL-V1305
PL-V1409
PL-V1501
PL-V1801
PLWAAT01
PLWAAV01
PLWADB01
PLWADB10
PLWADC02
PLWADC14
PLWADE01
PLWADE02
PLWADMS04
PLWADMS05
PLWADMS06
PLWAES01
PLWAES04
PLWAFB01
PLWAFS01
PLWAHR01
PLWAHR02
PLWALG01
PLWAMO02
PLWAOV01
PLWAOV02
PLWATM01
PLWATM08
PLWATM10
PLWATM21
PLWAYZ00
TEMP_KMU
WAWSRVAP004
WAWSRVOVS01
WAWSRVOVS02
WAWSRVSQL003
WAWSRVTM009
WAWSRVTM101
WAWSRVTS002
WAWSRVVPN001
WAWWRKCLN001
"@

$serverList = $Servers.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$ipExpression = {$_.ipv4address.IPAddressToString}


$computer = @(
 [PSCustomObject] @{
 "Name" = "Patriot Games";
 "Domain" = "Tom Clancy";
 "PageCount" = 540;
})
$i = 0
$result = foreach($server in $serverList){
   Write-Progress -Activity "Getting server info" -Status "Server # $i" -Id 1 -PercentComplete ([int](100*$i/$serverList.count)) -CurrentOperation "Current server: $server"
   $i++;
   try {
      $computer= get-adcomputer $server -Properties location,ipv4address,canonicalname,description,operatingsystem -Server trinitycs -ErrorAction Stop| select name,location,ipv4address,canonicalname,description,operatingsystem,@{Name='Domain'; Expression = {$_.canonicalname.split('//')[0]}}

   }
   catch{
       try{  
       $computer= get-adcomputer $server -Properties location,ipv4address,canonicalname,description,operatingsystem -Server work.local -ErrorAction Stop| select name,location,ipv4address,canonicalname,description,operatingsystem,@{Name='Domain'; Expression = {$_.canonicalname.split('//')[0]}}
       }
       catch{
          $computer = [PSCustomObject]@{
                Name = $server
                ipv4address = (Test-Connection  $server -Count 1 -ErrorAction SilentlyContinue| select @{Name='IPAddress'; Expression = $ipExpression}).ipaddress
                Domain = 'Error'
                location = ''
                canonicalname = ''
                description = ''
                operatingsystem = ''
              }
       }
   }
   $computer
}

$ExportPath =  "I:\IT_Scripts\MWD_Powershell\CSV\ServerAdInfo2.csv"
$ExportCsvSplatt = @{
   Path = $ExportPath
   Encoding = "UTF8"
   Delimiter = ';'
   NoTypeInformation = $true
}

$result | Export-Csv @ExportCsvSplatt -force

Start-Process  $ExportPath
