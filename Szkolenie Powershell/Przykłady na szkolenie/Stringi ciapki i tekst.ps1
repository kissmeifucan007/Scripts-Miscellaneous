# Zmienne tekstowe w Powershellu pozwalają na dużą elastyczność
# Łączenie tekstu i użycie 'ciapek': ",' pozwala na sporą dowolność

# W większości przypadków można dowolnie użyć podwójnych: " " i pojedynczych : ' ' ciapek

# Przykład

$hello1 = "Hello World"
$hello2 = 'Hello World'

# czy są takie same?
$hello1 -eq $hello2 

# Pomoc 
Get-Help about_quoting_rules 
# albo: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7
# dają sporo przykładów użycia 'ciapek'

# Zmienne i niektóre wyrażenia mogą być wykorzystywane jako wartości w podwójnych 'ciapkach'.
# Pojedyncze 'ciapki' zwrócą niezmieniony tekst
# Przykłady

$i = 5
"The value of $i is $i."
"The value of $(2+6) is 8."

'The value of $i is $i.'
'The value of $(2+6) is not 8 :('

# W podwójnych 'ciapkach' (") można używać znaków specjalnych takich jak:
# Pomoc: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7

`0 #Null
`a #Alert/Beep
`b #Backspace
`f #Form feed (used for printer output)
`n #New line
`r #Carriage return
`t #Horizontal tab
`v #Vertical tab (used for printer output)

# Znaki te poprzedzone są ` - (na klawiszu z tyldą '~' - pod Esc na klawiaturze)
# Znak ` to 'znak modyfikacji (escape character):  zmienia znaczenie następnego znaku
# Znak ` działa tylko pomiędzy podwójnymi 'ciapkami' " "

# Przykłady

# Likwidacja znaczenia symbolu '$'
"The value of `$(2+6) is 'dollar'(2+6)."

# Dodatkowa pojedyncza 'ciapka' przez wstawienie dwóch dodatkowych
'don''t go there!'

# Zastosowanie znaku '`' w podwójnych 'ciapkach'

"Użyj znaku (`") na początku ciągu znaków"

" Zawiń wiersz tu: `r`n a tu wstaw tabulator: `t."

# 'Ciapki' można zagnieżdżać na różne spospby:

"Podwójne w podwójnych: ""tekst""."
"Pojedyncze w podwójnych: 'tekst'."
'Podwójne w pojedynczych: "tekst".'

