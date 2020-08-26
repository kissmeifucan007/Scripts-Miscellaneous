$UserOUs =@(
"OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Warsaw,OU=Vistra,DC=work,DC=local"
)

function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}

$CEEUsers =  foreach ($ou in $UserOUs){
 get-aduser -Filter {enabled -eq $true} -SearchBase $ou
}


$regex = "\A[A-Z][a-z]+(-[A-Z][a-z]+)? (de )?[A-Z][a-z]+(-[A-Z][a-z]+)?\z"

$regular = @()
$special = @()
foreach ($user in $CEEUsers){
   $noDiacriticsName = Remove-StringLatinCharacters $user.name
   if ($noDiacriticsName -cmatch $regex){
      $regular+= $user.name
   }else{
      $special += $user.name
   } 
}

$exclusions = @("Zenonek Testowy")
$forFixing = @("Mateusz  Gan","Izabela Dybowska-staciwa", "konrad.bialach")


# Regular user names matching regex, 
# Exclude special accounts matching same regex - from array
# Add accounts that do not match regex because of bad formatting - require fixing

$regular+$forFixing |select @{n="Name";e={$_}} | Where-Object Name -NotIn $exclusions | sort 


# Special accounts - not matching regex
# Exclude accounts which require name fix
# Include wrongly matched 
$special | select @{n="Name";e={$_}} | Where-Object Name -NotIn $forFixing | sort 


get-aduser -Filter {name -like "Zenonek Testowy"}