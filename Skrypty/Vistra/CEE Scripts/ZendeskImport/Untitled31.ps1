get-aduser -filter {name -like "Angelika Grochocka"} | Get-ADPrincipalGroupMembership | Out-GridView

get-adgroup  -Filter {name -like "*languard*"} | Out-GridView

