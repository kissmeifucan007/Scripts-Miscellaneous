for ($i = 1; $i -le 100; $i++ )
{
    sleep -Milliseconds 40
    Write-Progress -Activity ("Formatting C: drive. Please wait" ) -Status "$i% Complete:" -PercentComplete $i;
}

$test = 1.2345
$test2 =  Get-Date 
$test2.AddMonths(-1)
"{0:MMMM}" -f $test2 -replace "iec","ca" 
"Number: {0:n2}, Date: {1:dddd}, {1:dd} {1:MMMM} {1:yyyy}r." -f $test, $test2 

$miesiącePath = "C:\Users\mwojewoda\OneDrive - Sii Sp. z o.o\Documents\SII\Powershell\nazwy miesięcy.csv"
$miesiące = import-csv $miesiącePath -Delimiter ";"


$test2 =  Get-Date 
$test2 = $test2.AddMonths(-6)
$m = "{0:MMMM}" -f $test2
foreach ($miesiąc in $miesiące){
   $m = $m -replace $miesiąc.Podstawowy, $miesiąc.Odmieniony
}
"Number: {0:n2}, Date: {1:dddd}, {1:dd} {2} {1:yyyy}r." -f $test, $test2, $m 

