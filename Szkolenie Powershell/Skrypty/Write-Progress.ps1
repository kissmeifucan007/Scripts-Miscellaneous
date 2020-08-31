# Polcenie Write-Progress znacznie ułatwia działanie z pętlami, które przetwarzają wiele obiektów
# Funkcja ułatwia oszacowanie czasu wywołania

# Przykład użycia

$tablica = 1..100000

$i=0
$nowaTablica = foreach ($element in $tablica){
    $percentComplete = $i/$tablica.Count * 100
    Write-Progress -Activity "Dodawanie elementów do nowej tablicy" -Status ("Ukończono: {0:n2}%" -f $percentComplete) -PercentComplete $percentComplete
    $i++
    $element * [Math]::PI
}
