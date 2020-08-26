$trinityComputers = get-adcomputer -server trinitycs -Filter * -Properties *

$trinityServers = $trinityComputers | select name,ipv4address,description,operatingSystem | ? {$_.OperatingSystem -like "*server*"} 

$runningSrvers = foreach ($server in $trinityServers){
   try {
   Test-Connection -Count 1 $server.name -ErrorAction SilentlyContinue
   }
   catch{
   }
}


$runningSrvers  | Out-GridView 

