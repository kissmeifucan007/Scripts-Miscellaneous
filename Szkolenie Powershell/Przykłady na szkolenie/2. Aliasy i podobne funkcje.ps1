# Źródło : Powershell Notes for Professionals
# Wiele poleceń powershella ma swoje aliasy, które są bardziej rozpoznawalne niż właściwe polecenie

# poniższe polecenia są tożsame:

ls
dir
Get-ChildItem

# Podczas pisania dłuższych skryptów należy jednak unikać aliasów, aby zwiększyć czytelność kodu
# Visyal Studio Code podkreśla takie polecenia na żółto, i ułatwia poprawianie: 
# kliknij na podkreślenie, a następnie na żółtą lampkę

# Można utworzyć własne aliasy dla poleceń np.:

Set-Alias -Name ping -Value Test-NetConnection
ping 8.8.8.8

# Polecenie Get-Alias wyświetla wszystkie aliasy dostępne w systemie 

Get-Alias

# Przykład wypisywania tekstu na ekran
$hello = "Helo World"

$hello
echo $hello
Write-Host $hello
Write-Output $hello
write $hello

# Polecenia Write-Host i Write-Output są często ze sobą mylone, gdyż zazwyczaj wyświetlają ten sam wynik
# Write-Output (wraz z aliasami write i echo) powinno być wykorzystywane ze względu na możliwośc przekazania polecenia dalej
# Przykład
$filtr = "*Szkolenie*"
Write-Output $filtr |  Get-ChildItem -Filter $filtr