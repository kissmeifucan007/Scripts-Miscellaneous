$groups =Get-ADPrincipalGroupMembership Larissa.Schimpf
$groups | Out-GridView

$members = Get-ADGroupMember "Email - Global - International Expansion Staff"
$members |%  {$_.distinguishedName.split(",")[2]} |sort