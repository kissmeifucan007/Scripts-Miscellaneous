$usersWORK = @(
  "kolodochkab!",
  "glomskip!",
  "wojewodam!",
  "glowackik!",
  "czarneckid!",
  "jablonskik!",
  "becheanuv!"
)

$usersTRINITY = @(
  "adm.mwd",
  "adm.kjl",
  "adm.pgl",
  "adm.kgc",
  "adm.vbc",
  "adm.bkl",
  "adm.dcz"
)


$output = foreach ($user in $usersWORK) {
  Get-ADPrincipalGroupMembership $user -server work.local | select name, @{Name = 'User'; Expression = { $user } }, @{Name = 'Domain'; Expression = { "Work.local" } } 
} 
$output +=
foreach ($user in $usersTRINITY) {
  Get-ADPrincipalGroupMembership $user -server trinitycs | select name, @{Name = 'User'; Expression = { $user } }, @{Name = 'Domain'; Expression = { "Trinitycs" } } 
} 


$output | Export-Csv -Encoding UTF8 -Delimiter ";" -Path groups.csv

