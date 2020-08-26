1..10 | %{
$percent = $_*10
Write-Progress -PercentComplete $percent -Status ("Percent complete: {0:n2}" -f $percent) -Activity "Counting 1"
Start-Sleep -Milliseconds  (Get-Random(50))
1..10 | %{
$percent = $_*10
Write-Progress -PercentComplete $percent -Status ("Percent complete: {0:n2}" -f $percent) -Id 1 -Activity "Counting 2"
Start-Sleep -Milliseconds  (Get-Random(20))
Write-Host
1..100 | %{
$percent = $_
Write-Progress -PercentComplete $percent -Status ("Percent complete: {0:n2}" -f $percent) -Id 2 -Activity "Counting 3"
Write-Host "$_ " -NoNewline 
}
}
}

