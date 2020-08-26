#wawsrvdc003
$dhcpServer = Read-Host -Prompt "DHCP Server name or address"

$hostname = Read-Host -Prompt "Hostname to find MAC Address" 
$macAddressSeparator = ""
#$macAddressSeparator = Read-Host -Prompt "MAC address field separator (':' or '-' etc.)"

$DHCPLeaseInfo = Get-DhcpServerv4Scope -ComputerName $dhcpServer| 
foreach { Get-DhcpServerv4Lease -ComputerName $dhcpServer -ScopeId $_.ScopeId} |
select IpAddress, @{label=’MAC Address’;expression={$_.clientid.replace("-",$macAddressSeparator)}}, @{label=’ShortHostName’;expression={$_.hostname.split("`.")[0]}}, HostName, AddressState, LeaseExpieryTime, ScopeID |
? {$_.shorthostname -like $hostname}  
$DHCPLeaseInfo | Out-GridView

$DHCPReservationInfo = Get-DhcpServerv4Scope -ComputerName $dhcpServer| 
foreach { Get-DhcpServerv4Reservation -ComputerName $dhcpServer -ScopeId $_.ScopeId} |
select IpAddress, @{label=’ShortName’;expression={$_.name.split("`.")[0]}}, Name,@{label=’MAC Address’;expression={$_.clientid.replace("-",$macAddressSeparator)}}, Type, Description, ScopeID |
? {$_.shorthostname -like $hostname}  
$DHCPReservationInfo | Out-GridView

$leasedIPs = Get-DhcpServerv4Scope -ComputerName $dhcpServer| 
foreach { Get-DhcpServerv4Lease -ComputerName $dhcpServer -ScopeId $_.ScopeId} | select -ExpandProperty IPAddress |? {$_.IPAddressToString -like "10.10.20.*"} | select -ExpandProperty IPAddressToString  
$i =1
while ($leasedIPs -ccontains "10.10.20.$i"){
   $i++
}
"10.10.20.$i"

#Add-DhcpServerv4Reservation -ComputerName $dhcpServer -ScopeId $DHCPLeaseInfo.scopeId -IPAddress $DHCPLeaseInfo.IPAddress -Name $DHCPLeaseInfo.HostName -ClientId $DHCPLeaseInfo.'MAC Address' -WhatIf

#$matches = @()
#foreach ($entry in $DHCPLeaseInfo){
#   $matches+= $DHCPReservationInfo | ? {$_.ipaddress -eq $entry.ipaddress }
#}

$matches | Out-GridView

$DHCPLeaseInfo.'MAC Address' 
$DHCPLeaseInfo.'MAC Address' | clip