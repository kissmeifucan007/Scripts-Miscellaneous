# Zmienne w powershellu nie muszą mieć określonego wcześniej typu danych
# Zmienne zaczynają się od znaku '$'
# Nazwa nie może zawierać spacji

# Przykłady
$foo = 'bar'
$foo

$liczba1 = 10
$liczba2 = [Math]::PI
$liczba3 = 3.14

$liczba1
$liczba2
$liczba3

# Zmienne mają jdnak określony typ danych, określony automatycznie na podstawie wartości

$foo.GetType()
$liczba1.GetType()
$liczba2.GetType()
$liczba3.GetType()

# Tablice

# Tablica to zbiór uporządkowanych wartości tego samego typu
# Przykład
$tablica1 = 1,2,3,4
$tablica1

$tablica2 = 6..10
$tablica2

$tablica3 = "1","2","3","4"
$tablica3

# Do wartości tablicy odwołujemy się po indeksie w nawiasach kwadratowych []
# Indeks zaczyna się od 0 i kończy na wartości 1 mniejszej niż liczba elementów

# Przykład
$tablica1[0]
$tablica2[2]
$tablica3[4]

$tablica1[0].GetType()
$tablica2[2].GetType()
$tablica3[4].GetType()

# Do tablicy można dodać elementy z pomocą operatora + lub +=

$tablica1 += 5
$tablica1[0] += 1

# Tak samo można łączyć tablice

$tablica2 = $tablica1 + $tablica2
$tablica2

# Operacje na wartościach tablicy
# indeks -1 oznacza ostatni element tablicy
$tablica1[-1]-=$tablica1[0]
$tablica1

# ujemne indeksy pozwalają przeglądać elementy tablicy od końca

$tablica = 6..10

foreach ($i in 1..4){
    $tablica[-$i]
}

# Wartości tablicy można przypisywać do kilku zmiennych na raz
# Przykład
$tablica = 1..3
$pierwszy,$drugi,$trzeci = $tablica
$trzeci,$drugi,$pierwszy

# Jest to szczególnie przydatne przy dzieleniu tekstu

# Przykład
$tekst = "foo.bar.baz"
# Zamiast tak:
$części = $tekst.Split(".")
$foo = $parts[0]
$bar = $parts[1]
$baz = $parts[2]
# Można poprostu tak:
$foo, $bar, $baz = $input.Split(".")

# Tekst typu [string] zachowuje się tak jak tablica znaków
# Przykład

$listen = "listen"
$listen[0]
$listen[5]
$order = 2,1,-6,-2,-1,3
$notListen = ""
foreach($i in $order) {
  $notListen+=$listen[$i]
}
# Co jest w zmiennej $notListen?
$notListen
