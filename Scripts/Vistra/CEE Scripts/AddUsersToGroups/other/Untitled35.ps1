$users = @"
ahmed.hamed@vistra.com
bart.kroef@vistra.com
constanta.chiriac@vistra.com
egbert.loenen@vistra.com
jabir.azoubairi@vistra.com
jamie.carter@vistra.com
jonathan.devries@vistra.com
kamil.glowacki@vistra.com
krystian.jablonski@vistra.com
mehmet.gul@vistra.com
michal.wojewoda@vistra.com
miguel.jose@vistra.com
wai.yu@vistra.com
wiebe.vandervelde@vistra.com
"@
$users = $users.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$adUsers = foreach ($user in $users){
   get-aduser -filter {emailaddress -eq $user} -properties emailaddress
}
$path = 'C:\CEE scripts\usersAmsterdam.csv'
$adUsers | export-csv 'C:\CEE scripts\usersAmsterdam.csv' -Delimiter ";" -Encoding UTF8
start $path
