# Przełącznik -f po bloku tekstu pozwala zdefiniować sposób wyświetlania tekstu ze zmiennych
# źródło: https://ss64.com/ps/syntax-f-operator.html

# Przykład

# wyświetlanie wartości %
$max = 15
foreach ($i in 1..$max){
    $procent = $i/$max 
   "Procent: {0:p2}" -f $procent
} 

# wyświetlanie daty
"Dziś jest {0:dddd}; dzień miesiąca: {0:dd}; Miesiąc: {0:MMMM}" -f  (Get-Date)

$odmienioneMiesiące = @("stycznia","lutego","marca","kwietnia","maja","czerwca","lipca","sierpnia","września","października","listopada","grudnia")
"Dziś jest {0:dddd}, {0:dd} {1}" -f  (Get-Date), ($odmienioneMiesiące[(Get-date).Month])