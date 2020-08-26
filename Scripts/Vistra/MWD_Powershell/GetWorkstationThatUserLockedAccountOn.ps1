## Define the username that’s locked out
$Username = ‘balintp’

## Find the domain controller PDCe role
$Pdce = (Get-AdDomain).PDCEmulator

## Build the parameters to pass to Get-WinEvent
$GweParams = @{
     ‘Computername’ = $Pdce
     ‘LogName’ = ‘Security’
     ‘FilterXPath’ = "*[System[EventID=4740] and EventData[Data[@Name='TargetUserName']='$Username']]"
}

## Query the security event log
$Events = Get-WinEvent @GweParams
## Get the workstation that user locked account on
$Events | foreach {$_.Properties[1].Value}