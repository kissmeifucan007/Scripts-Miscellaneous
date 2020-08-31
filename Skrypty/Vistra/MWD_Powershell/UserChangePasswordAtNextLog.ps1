#to set password change at next login user needs to have password never expires option turned off

$prelist = @"
zitnanskyf
nemcovk
dvorakl
gawlikj
bilewij
szalanskaj
blochki
czarneckid
brzozol
kukurykai
forrova
horalep
frankom
zeminos
poupam
knizets
zapotockav
donatm
pacutm
siwarsa
zabinsa
szokej
ryanm
jonasd
valeane
"@
$users = $prelist.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$result = foreach ($user in $users){
Set-ADUser $user -PasswordNeverExpires:$FALSE
set-aduser $user -ChangePasswordAtLogon $true
Get-ADUser $user -properties Name, PasswordNeverExpires | Select name, samaccountname, PasswordNeverExpires
}


$result | Out-GridView



