get-aduser -Properties title 

get-aduser -SearchBase "OU=Soest,OU=Orangefield,DC=work,DC=local" -Properties title -Filter * | ? {$_.title -eq "Accountant"} | Out-GridView