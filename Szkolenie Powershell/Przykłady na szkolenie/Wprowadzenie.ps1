# Kod w przykładach jest komentowany po polsku. Tak samo tworzone są nazwy zmiennych, z wykorzystaniem polskich znaków diakrytycznych.
# W praktyce sugeruję użycie nazw angielskich, najlepiej identycznych z nazwami przełączników wykorzystywanych komend.

# Czasem nazwy przełączników różnią się pomiędzy modułami i komendami Powershella

# Przykład
# zmienna $surname, zamiast $lastname bo tak w Powershellu nazywa się parametr dla nazwiska w komendzie Get-AdUser

$surname = 'Kowalski'
$users = Get-ADUser -Properties surname | Where-Object {$_.surname -eq $surname}

# Dla pętli foreach staram się używać liczby pojedynczej i mnogiej z 's' na końcu

$userNames = @("user1","user2","user3")

foreach ($userName in $userNames) {
   Get-AdUser $user
}

# Nazwy zmiennych piszę w camelCase, zaczynając od małej litery

# Szczegółowe zalecenia edycyjne można znaleźć tu:
# https://github.com/PoshCode/PowerShellPracticeAndStyle
# i tu: https://www.networkworld.com/article/2268752/chapter-2--basic-powershell-concepts.html?page=2