# Operatory arytmetyczne
# Tu wszystko prosto, podobnie jak winnych językach

1 + 2 # Dodawanie
1 - 2 # Odejmowanie
  -1  # Zmiana znaku
1 * 2 # Mnożenie
1 / 2 # Dzielenie
1 % 2 # Reszta z dzielenie

# Operatory logiczne 
-and # i (and)
-or # lub (or)
-xor # albo (exclusive or)
-not $x # negacja; nie (not)
! $x # '!' to alias dla -not

# Operatory przypisania
$zmienna = 1

# Każdy operator arytmetyczny można dodać po znaku '='
# Przykład
$zmienna += 1
$zmienna
$zmienna *= 3
$zmienna

# Operatory porównania
# Powershell ma tekstowe, zazwyczaj 2 znakowe operatory porównania
# Nazwy operatorów pochodzą wprost od angielskich słów co powinno ułatwić zapamiętanie nazw
# Przykłady
2 -eq 2 # Equal to (==)
2 -ne 4 # Not equal to (!=) or (<>)
5 -gt 2 # Greater-than (>)
5 -ge 5 # Greater-than or equal to (>=)
5 -lt 10 # Less-than (<)
5 -le 5 # Less-than or equal to (<=)

# Dzięki takiemu podejściu nie można pomylić przypisania z porównaniem, tak jak w innych językach
# Jednak nadal można popełnić błędy :/
# Przykład
# BŁĘDY IF
$i = 1
if ($i = 3){ # Przypisanie się udało - zatem prawda 
    return "Takie samo : $i = 3" # I nawet się zgadza
}else {
    return "Różne : $i != 3" # Ale miało być nadal $i = 1 ...
}

Write-Output "`$i: $i" 
Write-Output "`$i: $i" 
# Co gorsza $i zmieniło wartość
# Powinno być
$i = 1
if ($i -eq 3){ # Porównaj
    return "Takie samo : $i = 3"
}else {
    return "Różne : $i != 3"
}

# Operatory tekstowe

# Przykład z wykorzystaniem '*' (wildcard) 
$tekst1 = "Ala ma kota"
$tekst2 = "Kot ma Alę"
$tekst1 -like "Ala*" # tekst zaczyna się od 'Ala'
$tekst2 -like "*Al*" # tekst ma w środku 'Al'
$tekst1 -notlike "*Alę*"  # tekst nie ma w środku 'Alę'
$tekst2 -notlike "*Alę*"  # tekst nie ma w środku 'Alę'

# Wyrażenia regularne (regex)
# Pomoc: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7
# Materiały : https://powershellexplained.com/2017-07-31-Powershell-regex-regular-expression/
#             https://ss64.com/ps/syntax-regex.html\
#             https://www.regular-expressions.info/powershell.html

$tekst1 -match '^[\w+ ]+$' # ciągi liter i spacje
$tekst2 -notmatch '.*ę.*'  # litera ę w tekście
$tekst1 -notmatch '.*ę.*'  # litera ę w tekście

# !UWAGA! Operatory tekstowe domyślnie nie rozróżniają wielkości znaków
# Przykład
'a' -match 'A'
'b' -like 'B'
"C" -notLike 'c'
'.Net' -eq '.NET'
 
# Można wymusić sprawdzanie wielkości liter dopisując 'c' do operatora (c - Case Sensitive)
# Przykład
'a' -cmatch 'A'
'b' -clike 'B'
"C" -cnotLike 'c'
'.Net' -ceq '.NET'

# Analogicznie można dopisać 'i' (i - case Insensitive) 
# W ten sposób można wprost wskazać, że intencą było nie porównywanie wielkości znaków.
'b' -like 'B'
'b' -ilike 'B'

# Występują jeszcze operatory przekierowania (redirection)
# Operatory działają jak w cmd
# Pomoc: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7

#Przykład
'zawartość' > plik.txt        # przekierowanie do pliku
'nowa zawartość' >> plik.txt  # dopisanie na końcu pliku (append)

# Zamiast operatorów warto użyć komendy Out-File, która daje większą kontrolę nad przekierowaną treścią.
# Zwłaszcza, że
if (36 > 42) { "true" } else { "false" } # Powstaje plik "42" z treścią "36"

# Mieszanie różnych operatorów
# Przykłady 

# Dodawanie
"4" + 2 # "42"
4 + "2" # 6
1,2,3 + "Hello" # 1,2,3,"Hello"
"Hello" + 1,2,3 # "Hello1 2 3"

# Mnożenie
"3" * 2 # "33"
2 * "3" # 6
1,2,3 * 2 #  1,2,3,1,2,3
2 * 1,2,3 # error op_Multiply is missing

# Ukryte konsekwencje
$a = Read-Host "Podaj liczbę" # Podaj 33
$a -gt 5

# Źródło problemu
$a.GetType()
$a[0]

# Rozwiązanie (uproszczenie)
$a = [int] (Read-Host "Podaj liczbę") # Podaj 33
$a -gt 5


