
 $oldWinServers =    get-adcomputer  -filter {enabled -eq $true} -properties operatingSystem |select operatingSystem,name | where-object {$_.operatingSystem -like "Windows Server 2008*"} | out-gridview    
($oldWinServers | where {$_.name -like "HKG*"}).count