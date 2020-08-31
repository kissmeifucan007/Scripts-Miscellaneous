$baseOu  = 'ad:\OU=Vistra,DC=work,DC=local'
$OUs = Get-ChildItem $baseOu | Out-GridView -Title "Select OUs" -PassThru 

$selectedOUs = $OUS.foreach{
  $groups = Get-ADGroup -SearchBase $_.DistinguishedName -Filter * |
      Where-Object {$_.groupCategory -eq "Security"}
   $groups | 
      Select Name, DistinguishedName |
      Out-GridView -Title "Select OUs to verify" -PassThru
} 




# Find GPO by name
get-gpo -all | ? {$_.DisplayName -like "*Berlin*"}

# Find groups, for which with given GPO is appiled
Get-GPPermission "Vistra - BER - Printer Distribution" -all | ? {$_.permission -eq "GPOApply"}

get-gpo  -name "Vistra - BER - Printer Distribution"

Get-GPPermission "Vistra - Terminal Server - Berlin - Mapped Network Drives (OF DEBER)" -All | ? {$_.permission -eq "GPOApply"}