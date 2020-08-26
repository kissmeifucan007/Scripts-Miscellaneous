$data =  Import-Excel '.\Pending Employees List.xlsx'
#foreach ($entry in $data) {
#  $emailRegex = "^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"
#  $email = $entry | select -ExpandProperty 'email address'
#  if ($email -match $emailRegex){
#     get-aduser -Properties emailaddress -Filter {emailaddress -eq $email} | select name
#  }
#}

$result = @()
foreach ($user in $data){
   $user= ""
   try {
      $userFound += get-aduser $user.'sam id' | select -ExpandProperty name
   }catch {}
   finally{
      if ($userFound -eq ""){
         $userFound = "#/NA#"
      }
   }   
   $userFound
}

$result
