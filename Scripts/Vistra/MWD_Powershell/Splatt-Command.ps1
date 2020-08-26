function Splatt-Command($command) {
   $Parameters = (Get-Command $command).Parameters.Keys
   $Result =  "`$"+$command.Replace("-","")+'Splatt = @{'
   foreach ($Parameter in $Parameters) {
      $Result += "`r`n   #"+$Parameter+' = '+ (Get-Command $command).Parameters[$Parameter].ParameterType
   }
   $Result += "`r`n}"
   $Result | clip
}