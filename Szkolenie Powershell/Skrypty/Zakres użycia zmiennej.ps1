# Zmienne nie muszą być dostępne z każdego miejsca
# Zmienna w funkcji może nie być dostępna poza tą funkcją

$foo = "Global Scope"
function myFunc {
    $foo = "Function (local) scope"
    Write-Host $global:foo
    Write-Host $local:foo
    Write-Host $foo
}
myFunc
Write-Host $local:foo
Write-Host $foo

# Usuwanie zmiennej
$zmienna = "Jakiś tekst"  #Definicja zmiennej
$zmienna                  #Wyświetlenie zmiennej
Remove-Variable -Name var #Usunięcie zmiennej
$zmienna