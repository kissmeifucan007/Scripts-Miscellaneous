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
#userList trinity:  adm.mwd! adm.bkl! adm.kgc! adm.jbl!


#$access = Compare-AdUsersGroupMembership adm.mwd adm.kgc trinitycs
Compare-AdUsersGroupMembership wojewodam! czarneckid! work.local | Out-GridView | export-csv -Delimiter ";" -NoTypeInformation -Encoding UTF8 -Path "Compare Michał Kamil Work.csv"
#get-aduser -Filter {name -like "*kamil glow*"}  -server work.local

