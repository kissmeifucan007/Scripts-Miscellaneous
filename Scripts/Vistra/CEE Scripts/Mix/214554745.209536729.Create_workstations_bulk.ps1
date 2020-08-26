Import-Module ActiveDirectory
$OU = "OU=x64,OU=Workstations,OU=Luxembourg,OU=Vistra,DC=work,DC=local"
$Descr = "Luxembourg Workstation - Dec 2016 - repl 2017"
Import-Csv "c:\scripts\Create_workstations_bulk.csv" | foreach-object {
New-ADComputer -Name $_.ComputerAccount -Path $OU -Description $Descr
ADD-ADGroupMember -identity “Security - Luxembourg - OF Computers” -members (Get-ADComputer $_.ComputerAccount)
ADD-ADGroupMember -identity “Security - Luxembourg Windows 7 Computers” -members (Get-ADComputer $_.ComputerAccount)
ADD-ADGroupMember -identity “Security - Luxembourg x64 Workstations” -members (Get-ADComputer $_.ComputerAccount)
}