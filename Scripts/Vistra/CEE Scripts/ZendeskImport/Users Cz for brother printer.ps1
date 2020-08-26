$ou = "OU=Prague,OU=Czech Republic,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"
$index=1
$users = get-aduser -Filter * -SearchBase $ou -Properties emailaddress | 
   select @{n="ns2:model";e={"MFC-L8690CDW series"}}, @{n="ns2:dial-id";e={$global:index;$global:index++}}, @{n="ns1:text";e={$_.name.toupperInvariant()}},  @{n="ns2:index";e={1}},  @{n="ns3:text";e={$_.emailaddress}} 

$users | Export-Csv -Path "C:\Users\wojewodam!\Documents\Scripts\users.csv" -NoTypeInformation -Encoding UTF8 -Force
