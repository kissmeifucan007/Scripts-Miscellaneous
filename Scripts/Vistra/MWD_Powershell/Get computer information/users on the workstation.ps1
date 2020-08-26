$list = Get-ADComputer -searchbase "OU=Workstations,OU=Luxembourg,OU=Vistra,DC=work,DC=local" -Filter {enabled -eq $true} | select -expandproperty name
$list += Get-ADComputer -searchbase "OU=Workstations Windows 10,OU=Luxembourg,OU=Vistra,DC=work,DC=local" -Filter {enabled -eq $true} | select -expandproperty name
#or
 $prelist = @"
\\10.10.10.110\homedir$\jablonskik\SCAN
"@
$list = $prelist.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$result=@()
foreach ($computer in $list){
$user = Get-ChildItem "\\$computer\c$\Users" | Sort-Object LastWriteTime -Descending | Select-Object -ExpandProperty Name -first 2
$info = [pscustomobject]@{
computer = $computer
user1 = $user[0]
user2 = $user[1]
}
$result += $info
}

