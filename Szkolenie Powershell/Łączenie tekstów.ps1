# Tekst można łączyć na wiele sposobów

# Przykłady

$i = 10
$t1 = 'kup'
$t2 = 'jaj'

# Prościej
"$t1 $i $t2"

# Trudniej 
$t1 + " " + $i + " "+ $t2

# Czytelniej
"Kup $i jaj!"

# Ale to nie zadziała:
$i + " "+ $t2 + " " + $t1

# Musimy zacząć od tekstu, zatem:
"" + $i + " "+ $t2 + " " + $t1

#Lub zamienić wartość na tekst (2 sposoby)

$i.ToString() +" "+ $t2 + " " + $t1
[string]$i +" "+$t2 + " " + $t1

# Nie uda nam się wypisać parametrów zmiennej w 'ciapkach'

#Przykład
$proces = Get-Process explorer

"Proces explorer ma ID: $proces.id"

# Ale można tak:
$proces = Get-Process explorer
$id = $proces.Id
"Proces explorer ma ID: $id"

# Albo nawet tak:

"Proces explorer ma ID: " + (Get-Process explorer).Id