$Servers = @"
PL-V1304
PL-V1305
PL-V1409
PL-V1501
PL-V1801
PLWAAP01
PLWAAT01
PLWAAV01
PLWACL01
PLWACL02
PLWACL03
PLWACL06
PLWADB10
PLWADC02
PLWADC14
PLWADE01
PLWADE02
PLWAES01
PLWAES04
PLWAFB01
PLWAFS01
PLWAHR01
PLWAHR02
PLWAHV01
PLWAHV02
PLWAHV03
PLWALG01
PLWAMO02
PLWATM01
PLWATM08
PLWATM10
PLWATM21
PWADB01
WASRVLG002
WASRVOVS001
WASRVTS001
WAWRKCLN001
WAWSRVAP02
WAWSRVAP03
WAWSRVAP04
WAWSRVARC001
WAWSRVCLN001
WAWSRVCLN001
WAWSRVCLN002
WAWSRVCLN002
WAWSRVCLN003
WAWSRVCLN003
WAWSRVCLN004
WAWSRVCLN004
WAWSRVDC001
WAWSRVDMS001
WAWSRVDMS001
WAWSRVDMS002
WAWSRVDMS003
WAWSRVDMS003
WAWSRVDMS004
WAWSRVDMS004
WAWSRVFOG001
WAWSRVFS001
WAWSRVFS002
WAWSRVFTP001
WAWSRVGIT001
WAWSRVGIT002
WAWSRVHR001
WAWSRVHR012
WAWSRVLG001
WAWSRVOVS002
WAWSRVSQL001
WAWSRVSQL002
WAWSRVSQL006
WAWSRVSQL007
WAWSRVSQL008
WAWSRVSQL009
WAWSRVTM001
WAWSRVTM002
WAWSRVTM003
WAWSRVTM004
WAWSRVTM005
WAWSRVTM006
WAWSRVTM007
WAWSRVTM008
WAWSRVTM009
WAWSRVWWW001
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

$ExportCsvSplatt = @{
   Path = "I:\IT_Scripts\MWD_Powershell\CSV\ServerAdInfo.csv"
   Encoding = "UTF8"
   Delimiter = ';'
   NoTypeInformation = $true
}

$result | Export-Csv @ExportCsvSplatt -force

get-adcomputer wawsrvadmin001 -properties *

