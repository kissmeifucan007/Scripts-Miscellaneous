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
WAWSRVDC002
WAWSRVDC003
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

$servers2 = @"
WAWSRVVH001
LUBSRVVH001
WROSRVVH001
POZSRVVH001
KRASRVVH001
BUCSRVVH001
BUDSRVVH001
SOFSRVVH001
PRGSRVVH001
WAWSRVDC001
LUBSRVDC001
WROSRVDC001
POZSRVDC001
KRASRVDC001
BUCSRVDC001
BUDSRVDC001
SOFSRVDC001
PRGSRVDC001
WAWSRVAP001
LUBSRVAP001
WROSRVAP001
POZSRVAP001
KRASRVAP001
BUCSRVAP001
BUDSRVAP001
SOFSRVAP001
PRGSRVAP001
WAWSRVFOG001
LUBSRVFOG001
WROSRVFOG001
POZSRVFOG001
KRASRVFOG001
BUCSRVFOG001
BUDSRVFOG001
SOFSRVFOG001
PRGSRVFOG001
"@

$servers2 = @"
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
PLWADB01
PLWADB10
PLWADC14
PLWADMS04
PLWADMS05
PLWADMS06
PLWAES04
PLWAFB01
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
WAWSRVADMIN001
WAWSRVDMS001
WAWSRVDMS003
WAWSRVDMS004
WAWSRVFOG001
WAWSRVFS002
WAWSRVFTP001
WAWSRVGIT001
WAWSRVGIT002
WAWSRVLG001
WAWSRVLG002
WAWSRVOVS01
WAWSRVOVS02
WAWSRVSQL003
WAWSRVTM101
PLWAES01
WAWSRVTM001
WAWSRVTM002
WAWSRVTM003
WAWSRVTM004
WAWSRVTM005
WAWSRVTM006
WAWSRVTM007
WAWSRVTM008
WAWSRVTM009
WAWSRVVPN001
PLWADC02
PLWADE01
PLWADE02
PLWAFS01
PLWAHR01
PLWAHR02
WAWSRVAP002
WAWSRVAP003
WAWSRVAP004
WAWSRVARC001
WAWSRVCLN001
WAWSRVCLN002
WAWSRVCLN003
WAWSRVCLN004
WAWSRVDC001
WAWSRVFS001
WAWSRVHR011
WAWSRVHR012
WAWSRVSQL001
WAWSRVSQL002
WAWSRVSQL006
WAWSRVSQL007
WAWSRVSQL008
WAWSRVSQL009
WAWSRVTS001
WAWSRVTS002
WAWSRVWWW001
WAWWRKCLN001
"@




$serverList = $Servers2.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$ipExpression = {$_.ipv4address.IPAddressToString}

<#
$pingResults = 
foreach($server in $serverList){
    
    Test-Connection  $server -Count 1 -ErrorAction SilentlyContinue| select @{Name='Server Name'; Expression = {$server}},@{Name='IP Address'; Expression = $ipExpression}
 
}
#>



$computer = @(
 [PSCustomObject] @{
 "Name" = "Patriot Games";
 "Domain" = "Tom Clancy";
 "PageCount" = 540;
})
$result = foreach($server in $serverList){
   try {
      $computer= get-adcomputer $server -Properties location,ipv4address,canonicalname,description,operatingsystem -Server trinitycs -ErrorAction Stop| select name,location,ipv4address,canonicalname,description,operatingsystem,@{Name='Domain'; Expression = {$_.canonicalname.split('//')[0]}}

   }
   catch{
       try{  
       $computer= get-adcomputer $server -Properties location,ipv4address,canonicalname,description,operatingsystem -Server work.local -ErrorAction Stop| select name,location,ipv4address,canonicalname,description,operatingsystem,@{Name='Domain'; Expression = {$_.canonicalname.split('//')[0]}}
       }
       catch{
         <# $computer = [PSCustomObject]@{
                Name = $server
                ipv4address = (Test-Connection  $server -Count 1 -ErrorAction SilentlyContinue| select @{Name='IPAddress'; Expression = $ipExpression}).ipaddress
                Domain = 'Error'
                location = ''
                canonicalname = ''
                description = ''
                operatingsystem = ''
              }#>
       }
   }
   $computer
}
$errors

$ExportCsvSplatt = @{
   Path = "I:\IT_Scripts\MWD_Powershell\CSV\DatacenterServers.csv"
   Encoding = "UTF8"
   Delimiter = ';'
   NoTypeInformation = $true}

$result | Export-Csv @ExportCsvSplatt 

start-process "I:\IT_Scripts\MWD_Powershell\CSV\DatacenterServers.csv"
