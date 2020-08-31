$UserOUs =@(
"OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local",
"OU=Warsaw,OU=Vistra,DC=work,DC=local"
)


$singleName = "[A-Z][a-zß]+"
$part = "$singleName*(-$singleName*)?"

$middleOptions = @("de ",
                    "Le ",
                    "Mc",
                    "van "
                    "Van Der ",               
                    "De ",
                    "van den ",
                    "O'",
                    "O``",
                    "D'",
                    "van der ",
                    "von ",
                    "van de ",
                    "ter "
                  )

$middle = ""
foreach ($option in $middleOptions){
   $middle+="($option)?"
}
$regex = "\A$part $middle$part(( $middle$part)+)?\z"

function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}



$allSpecial = get-aduser -Filter {enabled -eq $true} | where {(Remove-StringLatinCharacters $_.name) -cmatch $regex} | select name


$locations = @("Luxembourg","Singapore","Hong Kong","Amsterdam","Jakarta","Geneva","Cyprus","Taiwan","Shenzen","Malta","Dubai","Guangzhou","Beijing","Macau")
$restrictedNames = @("Test","test","Team","Admin","Vistra","Info","Connect","Website", " Room","Radius","Mailbox","Jordan","vconnect","Trainer","Email","Service","Client")
$sestrictedABbreviations = @("CEE","accpay","lux")
$restrictedRegex = @(".*[A-Z][A-Z]+.*",
                 ".*[0-9].*",
                 ".*(\(|!|\)|_).*"
)

$exclusions += foreach ($location in $locations){
   
}
$regexFilter = ""
foreach ($exclusion in $exclusions){
  $regexFilter+="($exclusion)|"
}

$regexFilter = $regexFilter.Substring(0,$regexFilter.Length-1)

$specialFiltered = $allSpecial |  where {$_.name -cnotmatch $regexFilter} 

$specialFiltered.Count
$allSpecial.Count

$names = $specialFiltered | sort | Out-GridView -PassThru
