function Splatt-Command($command) {
   $Parameters = (Get-Command $command).Parameters.Keys
   $Result =  "`$"+$command.Replace("-","")+'Splatt = @{'
   foreach ($Parameter in $Parameters) {
      $Result += "`r`n   #"+$Parameter+' = '+ (Get-Command $command).Parameters[$Parameter].ParameterType
   }
   $Result += "`r`n}"
   $psISE.CurrentFile.Editor.InsertText($Result)
}

$getcommandSplatt = @{
   #Name = string[]
   #Verb = string[]
   #Noun = string[]
   #Module = string[]
   #FullyQualifiedModule = Microsoft.PowerShell.Commands.ModuleSpecification[]
   #CommandType = System.Management.Automation.CommandTypes
   #TotalCount = int
   #Syntax = switch
   #ShowCommandInfo = switch
   #ArgumentList = System.Object[]
   #All = switch
   #ListImported = switch
   #ParameterName = string[]
   #ParameterType = System.Management.Automation.PSTypeName[]
   #Verbose = switch
   #Debug = switch
   #ErrorAction = System.Management.Automation.ActionPreference
   #WarningAction = System.Management.Automation.ActionPreference
   #InformationAction = System.Management.Automation.ActionPreference
   #ErrorVariable = string
   #WarningVariable = string
   #InformationVariable = string
   #OutVariable = string
   #OutBuffer = int
   #PipelineVariable = string
}