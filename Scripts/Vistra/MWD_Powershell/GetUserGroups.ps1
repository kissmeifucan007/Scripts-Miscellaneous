function Compare-AdUsersGroupMembership {
   param(
   [Parameter(Mandatory,Position=0)]
   [String]$user1,
   [Parameter(Mandatory,Position=1)]
   [String]$user2,
   [Parameter(Position=2)]
   [String]$domain
   )
   $list1 = Get-ADPrincipalGroupMembership $user1 -Server $domain |sort name |select -ExpandProperty name
   $list2 = Get-ADPrincipalGroupMembership $user2 -Server $domain |sort name |select -ExpandProperty name
   
   $access =[PsObject]@()
   $differences = compare $list1 $list2 -IncludeEqual
   foreach ($entry in $differences){
      switch ($entry.SideIndicator){
         '<=' {
             $user =$user1
         }
         '=>'{
             $user = $user2
         }
         Default {
             $user = "#Both users#"
         }
      } 
      $newObject = New-Object -TypeName PSObject -Property @{
         'Which User' = $user
         'AD Group' = $entry.InputObject
      }
      $access+=($newObject)
   }
   $access | Out-GridView
   $access
}

#userList work:  kolodochkab! jablonskik! glomskip! wojewodam!
#userList trinity:  adm.mwd! adm.bkl! adm.kgc! adm.jbl! adm

$siiUsers = @(
"Michał Wojewoda",
"Kamil Głowacki",
"Krystian Jabłoński",
"Piotr Głomski"
)

$trinitySiiUserLogins = foreach ($user in $siiUsers){
   Get-ADUser -Filter {name -like $user} | where {$_.samaccountname.length -eq 3} | select -ExpandProperty samaccountname
}

$trinitySiiAdminLogins = foreach ($user in $trinitySiiUserLogins){
   Get-ADUser "adm.$user" |select -ExpandProperty samaccountname
}

$workSiiUserLogins = foreach ($user in $siiUsers){
   Get-ADUser -Filter {name -like $user} -Server work.local | select -ExpandProperty samaccountname
}

$workSiiAdminLogins = foreach ($user in $workSiiUserLogins){
   Get-ADUser "$user!" -Server work.local|select -ExpandProperty samaccountname
}

$Trinity = $trinitySiiUserLogins + $trinitySiiAdminLogins
$Work = $workSiiUserLogins + $workSiiAdminLogins

$result = @()

$result+= foreach ($user in $Trinity){
   Get-ADPrincipalGroupMembership $user | select @{name="Name"; Expression={$_.name}},@{name="Name"; Expression={$User}}, @{name="Domain"; Expression={"trinitycs"}}
}

$result+= foreach ($user in $Work){
   Get-ADPrincipalGroupMembership $user -Server "work.local"| select @{name="Name"; Expression={$_.name}},@{name="User"; Expression={$User}}, @{name="Domain"; Expression={"trinitycs"}}
}

$result | export-csv -Delimiter ";" -NoTypeInformation -Encoding UTF8 "groupMembership.csv"
$result | select name,user| Group-Object name | select -ExpandProperty group
Start-Process groupmembership.csv 

Get-ADPrincipalGroupMembership mwd

#$access = Compare-AdUsersGroupMembership adm.mwd adm.kgc trinitycs
Compare-AdUsersGroupMembership jablonskik! glowackik! work.local | export-csv -Delimiter ";" -NoTypeInformation -Encoding UTF8 -Path "Compare Michał Kamil Work.csv"
#get-aduser -Filter {name -like "*kamil glow*"}  -server work.local

