$OUs = @"
OU=Amsterdam,OU=Vistra,DC=work,DC=local
OU=Barcelona,OU=Vistra,DC=work,DC=local
OU=DubaiCyprus,OU=Vistra,DC=work,DC=local
OU=Geneva,OU=Vistra,DC=work,DC=local
OU=Madrid,OU=Vistra,DC=work,DC=local
OU=Malta,OU=Vistra,DC=work,DC=local
OU=Antwerp,OU=Vistra,DC=work,DC=local
OU=Eemnes,OU=Vistra,DC=work,DC=local
OU=Frankfurt,OU=Vistra,DC=work,DC=local
OU=Rotterdam,OU=Vistra,DC=work,DC=local
OU=Zug,OU=Vistra,DC=work,DC=local
OU=Zurich,OU=Vistra,DC=work,DC=local
OU=Warsaw,OU=Vistra,DC=work,DC=local
OU=Poznan,OU=Vistra,DC=work,DC=local
OU=VFS,OU=Servers,OU=CEE,OU=Vistra,DC=work,DC=local
OU=VFS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Workstations Test,OU=VFS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Sofia,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Bratislava,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Budapest,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Lublin,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Bucharest,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Poznan,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Warsaw,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Krakow,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Prague,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=Wroclaw,OU=VCS,OU=Workstations,OU=CEE,OU=Vistra,DC=work,DC=local
OU=CEE,OU=Vistra,DC=work,DC=local
"@

$OUs = $OUs.split([System.Environment]::NewLine, [System.StringSplitOptions]::RemoveEmptyEntries)
$ComputerList = @()
$CurrentList = @()
$ComputersInOu = @()
$currentCount
foreach ($ou in $OUs){
   $CurrentList  = get-adcomputer -SearchBase $ou -properties ipv4address,operatingsystem -ErrorAction SilentlyContinue -filter "((operatingsystem -like '*Windows 7*') -or (operatingsystem -like '*Server 2008*'))"|
     ? {$_.enabled -eq $true} |
     select name, ipv4address, operatingsystem, distinguishedName, @{n="OU"; e={ ($_.DistinguishedName.Split(",") | select -skip 1) -join ","}}
   $o = New-Object -TypeName psobject
   $o | Add-Member -MemberType NoteProperty -Name OU -Value $ou
   $win7count = $CurrentList |? {$_.operatingsystem -like '*Windows 7*'}| measure | select -ExpandProperty count
   $o | Add-Member -MemberType NoteProperty -Name 'Windows 7 count' -Value $win7count
   $server2008count = $CurrentList |? {$_.operatingsystem -like '*Server 2008*'}| measure | select -ExpandProperty count 
   $o | Add-Member -MemberType NoteProperty -Name 'Server 2008 count'  -Value $server2008count
   $ComputersInOu += $o
   $ComputerList += $CurrentList  
}

$ComputersInOu | export-csv "C:\CEE scripts\January 14 2020 update\ComputersInOu.csv" -Encoding UTF8 -Delimiter ";" -NoTypeInformation
$exportPath = "C:\CEE scripts\January 14 2020 update\allOutdatedWindowsMachines.csv"
$ComputerList | export-csv -Path $exportPath  -Encoding UTF8 -Delimiter ";" -NoTypeInformation
$ComputerList | measure | select -ExpandProperty count
start $exportPath