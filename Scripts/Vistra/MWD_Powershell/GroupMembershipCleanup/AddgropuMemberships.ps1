$usersWORK = @(
"kolodochkab!",
"glomskip!",
"wojewodam!",
"glowackik!",
"czarneckid!",
"jablonskik!",
"becheanuv!"
)


$groups = Get-Content "allGroups.txt"

foreach ($group in $groups){
    foreach ($user in $usersWORK){
       Add-ADGroupMember $group -Members (Get-ADUser $user) -ErrorAction SilentlyContinue
    }
}