# Od powershella 3.0 instrukcje pomocy można aktualizować:
# Warto zacząć pracę z powershellem na nowym komputerze od aktualizacji pomocy
# Polecenie Update-Help zaktualizuje pliki pomocy przechowywane na komputerze
# !UWAGA! proces aktualizacji może potrwać kilka minut

Update-Help

# Używanie pomocy
# Podstawowe wykorzystanie to 'Get-Help nazwaPolecenia'

Get-Help Select-Object

# Get-Help ma dwa aliasy: help i man
# Poniższe polecenia dadzą ten sam rezultat co powyżej

man Select-Object
help Select-Object

# Czasem warto ograniczyć się do samych przykładów
man Select-Object -Examples

# Można też wymusić wyświetlenie całej pomocy
Get-Help Get-Command -Full

# Oraz do określonego perametru
Get-Help Get-Content -Parameter Path

# Czasem wygodniej otworzyć zawartość w graficznym oknie
help Select-Object -ShowWindow

# A czasem łatwiej przeczytać dokument na stronie
# Wiele poleceń nie ma prawidłowo zrobionych odnośników do stron pomocy, ale warto próbować.
Get-Help Select-Object -Online
