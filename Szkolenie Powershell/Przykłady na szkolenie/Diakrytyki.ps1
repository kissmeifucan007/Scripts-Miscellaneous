# 1. Pozbywanie się "polskich znaków" (znaków diakrytycznych) z tekstu i zastępowanie odpowiednimi literami
# Źródło: https://lazywinadmin.com/2015/05/powershell-remove-diacritics-accents.html
# na stronie są inne wersje, ale ta jest najkrótsza i działa dla polskich znaków
function Remove-StringLatinCharacters{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}

# Przykład użycia

# list 'nazw' użytkowników
$names = @("Grzegorz Brzęczyszczykiewicz","Jan Kowalski","Ędward Ącki","Anna Nowak","Izabela Łęcka")

# znajdź użytkowników ze znakami diakrytycznymi
$names | ? {(Remove-StringLatinCharacters $_) -ne $_}

# wyświetl poprawione wersje nazw
$names | % {Remove-StringLatinCharacters $_}
