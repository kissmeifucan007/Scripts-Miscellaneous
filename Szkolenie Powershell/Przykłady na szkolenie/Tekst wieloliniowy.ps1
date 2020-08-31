# Tekst wieloliniowy w Powershellu nazywa się "here string"
# Tekst znajduje się między znacznikami  @" "@ 
# Zamykający znacznik musi być jedynym tekstem w linni

# Przykład
$nazwisko = "Jan" 
$imię = "Kowalski"
@"
Użytkownik:
    Imię: $imię
Nazwisko: $nazwisko
"@
# Albo
@'
Użytkownik:
    Imię: $imię
Nazwisko: $nazwisko
'@

# Tekst wielolinijkowy jest przydatny do szybkiego 'obrabiania' listy danych bez zapisywania do pliku
# Tekst trzeba jednak podzielić poleceniem split()
# Źródło: https://stackoverflow.com/questions/23496105/split-string-with-variable-whitespace-characters-in-powershell
# Przykład
$użytkownicy = @"
Jan Kowalski
Maciej Nowak
Janina Szczepaniak
"@

# Polecenie split dzieli po systemowym znaku nowej linii
# Usuwa też zbędne puste wartości z wyników
$listaUżytkowników = $użytkownicy.split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$i = 0
foreach ($użytkownik in $listaUżytkowników){
   $imię,$nazwisko= $użytkownik.Split(" ")
   $i++
@"
============================
Użytkownik {2}:
Imię: {0}
Nazwisko: {1}
============================
"@ -f $imię, $nazwisko, $i
}

# Zadanie
# Zmodyfikuj powyższy kod, tak aby wyświetlał również inicjały użytkowników z poniższego tekstu
# Wymyśl jak wyświetlić inicjały dla poniższych przypadków
$użytkownicy = @"
Jan A.P. Kaczmarek
Lars Løkke Rasmussen
Per Gottfrid Svartholm Warg
Harry S. Truman
Jan Kowalski
J. Edgar Hoover
"@