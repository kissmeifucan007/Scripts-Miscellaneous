# Lists local groups on selected terminals servers and exports member info to CSV

$Servers = @"
WAWSRVSQL001
WAWSRVSQL002
WAWSRVSQL006
WAWSRVSQL007
WAWSRVSQL008
WAWSRVSQL009
WAWSRVTS001
WAWSRVTM001
WAWSRVTM002
WAWSRVTM003
WAWSRVTM004
WAWSRVTM005
WAWSRVTM006
WAWSRVTM007
WAWSRVTM008
WAWSRVTM009
"@

$serverList = $Servers.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$tsGroupMembers = Foreach ($Server in $serverList)
{
	$Groups = Get-WmiObject Win32_GroupUser –Computer $server
	

    foreach ($group in $Groups){
        $groupName = $group |% {  
	    $_.partcomponent –match ".+Domain\=(.+)\,Name\=(.+)$"  > $nul 
	    $matches[1].trim('"') + "\" + $matches[2].trim('"')
        }

        $groupPrent = $group |% {  
	    $_.groupcomponent –match ".+Domain\=(.+)\,Name\=(.+)$"  > $nul 
	    $matches[1].trim('"') + "\" + $matches[2].trim('"')
        }
        

        if ($group -ne $false){
            $group | select @{name="Server";expression={$server}},@{name="group";expression={$groupPrent}} ,@{name="member";expression={$groupname}}
        }
	}
   
   }



     


   

$csvExportPath = "I:\IT_Scripts\MWD_Powershell\CSV\ServerGroupMembers.csv"

$ExportCsvSplatt = @{
   Path = $csvExportPath
   Encoding = "UTF8"
   Delimiter = ';'
   NoTypeInformation = $true}

$tsGroupMembers | Export-Csv @ExportCsvSplatt -Force 

start $csvExportPath