#poniższych komend trzeba użyc w CMD do włączenia PSremoting na stacjach roboczych użytkowników
#cd C:\PSTools
#psexec.exe \\RemoteComputerName -s powershell Enable-PSRemoting -Force

#computer number
$computerName = 'luxwrk309'

$session = New-PSSession -ComputerName $computerName

Invoke-Command -Session $session -ScriptBlock {
    c:\temp\program.exe /silent
}

#check if the program is installed
$programs = Invoke-Command -Session $session -ScriptBlock {
    Get-WmiObject -Class Win32_Product | Select-Object @{name="Server";expression={hostname}},name,vendor,version
}
$programs | out-gridview

#remove session
Remove-PSSession $session