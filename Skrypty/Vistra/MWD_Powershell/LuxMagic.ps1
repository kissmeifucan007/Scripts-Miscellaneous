$path =  "E:\Data\LUX\Profiles"
#$path = "C:\Temp\Test"
#$logins = Get-ChildItem $path -Directory | select @{name="name";expression={$_.name.Split(".")[0]}} | select -ExpandProperty name
# Powershell 2.0 version:
$logins = Get-ChildItem $path | ?{ $_.PSIsContainer } 
# for powershell 5.0 | select @{name="name";expression={$_.name.Split(".")[0]}} | select -ExpandProperty name
$logins | export-csv -Delimiter ";" -Encoding UTF8 -Path logins.csv

$logins  =  import-csv "\\plwafs01\it$\IT_Knowladge_Base\Helpdesk\Luxemburg\temp\logins.csv" -Delimiter ";" -Encoding UTF8 | select @{name="name";expression={$_.basename -replace  ".V\d$" }},basename

$disabledUsers = @()
$notUsers = @()
$users = @()
$i=0
foreach ($login in $logins){
   try{
      $isDisabled = -not ( get-aduser $login.name -Properties enabled -Server work.local | select -ExpandProperty enabled )
   }
   catch{$isDisabled = $false
    $notUsers += $login
   }
   if ($isDisabled){
      $disabledUsers += $login
   }
   else{
      $users += $login
   }
}

$disabledUsers | Export-Csv "\\plwafs01\it$\IT_Knowladge_Base\Helpdesk\Luxemburg\TEMP\disabled.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8
$notUsers | Export-Csv "\\plwafs01\it$\IT_Knowladge_Base\Helpdesk\Luxemburg\TEMP\notUsers.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8

# to run on lux server:

$disabledPath = "C:\Users\wojewodam!\disabled.csv"
$notUsersPath = "C:\Users\wojewodam!\notUsers.csv"

$disabledUsers =  import-csv $disabledPath -Delimiter ";" -Encoding UTF8 