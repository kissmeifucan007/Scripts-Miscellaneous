
function Splatt-Command($command) {
   $Parameters = (Get-Command $command).Parameters.Keys
   $Result =  "`$"+$command.Replace("-","")+'Splatt = @{'
   foreach ($Parameter in $Parameters) {
      $Result += "`r`n   #"+$Parameter+' = '+ (Get-Command $command).Parameters[$Parameter].ParameterType
   }
   $Result += "`r`n}"
   $Result | clip
}



$OUs = @(
'OU=Amsterdam,OU=Service Accounts,DC=work,DC=local', 
'OU=CEE,OU=Vistra,DC=work,DC=local', 
'OU=Luxembourg,OU=Vistra,DC=work,DC=local',          
'OU=Luxembourg,OU=Service Accounts,DC=work,DC=local',
'OU=Luxembourg,OU=Orangefield,DC=work,DC=local',  
'OU=Amsterdam,OU=Vistra,DC=work,DC=local',          
'OU=Amsterdam,OU=Service Accounts,DC=work,DC=local',
'OU=Amsterdam,OU=Orangefield,DC=work,DC=local'
)

$GetADComputerSplatt = @{
   Filter = "*"
   SearchBase = ''
   Server = 'work.local'
   Properties = 
}



foreach ($ou in $OUs){
   $GetADComputerSplatt['SearchBase']=$ou
   Get-ADComputer @GetADComputerSplatt | select name
}


