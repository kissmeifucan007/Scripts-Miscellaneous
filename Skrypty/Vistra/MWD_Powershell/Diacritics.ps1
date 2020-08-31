function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}

$name = "Pchnąć w tę łódź jeża lub ośm skrzyń fig François-Xavier Cat aábcčdďeéěfghchiíjklmnňoópqrřsštťuúůvwxyýzž"
$name2 = Remove-StringLatinCharacters -String $name
$name2


get-aduser -Filter * | select name | where {$_.name -ne (Remove-StringLatinCharacters -String $_.name)}

