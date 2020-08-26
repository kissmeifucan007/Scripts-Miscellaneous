$result = Test-Connection WAWSRVFS001 -Count 1 | select ipv4address 
$result.ipv4address.IPAddressToString | clip



