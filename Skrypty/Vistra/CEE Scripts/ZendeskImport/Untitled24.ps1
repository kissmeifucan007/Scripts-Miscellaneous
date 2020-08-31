Get-ADDomain | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator

Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster

Get-ADDomainController -Filter * |
     Select-Object Name, Domain, Forest, OperationMasterRoles |
     Where-Object {$_.OperationMasterRoles} |
     Format-Table -AutoSize

get-adcomputer AMSSRVDC004 -Properties operatingsystem

Get-ADDomainController -Filter * | Select-Object Name | measure | % { $_.Count }

$servers = Get-ADForest | Select-Object -ExpandProperty GlobalCatalogs | sort
Get-ADComputer amssrvdc002 -Properties operatingsyste

Get-ADForest

get-gpo -all |? {$_.displayname -like "*apploc*"} | Out-GridView

