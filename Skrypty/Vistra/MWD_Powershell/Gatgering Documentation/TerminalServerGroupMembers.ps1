$SQLServers = @"
WAWSRVSQL001
WAWSRVSQL002
WAWSRVSQL006
WAWSRVSQL007
WAWSRVSQL008
WAWSRVSQL009
"@


$tsGroupMembers = Foreach ($Server in $SqlServers)
{
	$Groups = Get-WmiObject Win32_GroupUser –Computer wawsrvtm004
	
    $LocalAdmins = $Groups | Where GroupComponent –like '*"Administrators"'
	$LocalUsers = $Groups | Where GroupComponent –like '*"Users"'
	$RDPUsers = $Groups | Where GroupComponent –like '*"Remote Desktop Users"'
    $match = {".+Domain\=(.+)\,Name\=(.+)$"  > $nul}


	$LocalAdmins = $LocalAdmins |% {  
	$_.partcomponent –match ".+Domain\=(.+)\,Name\=(.+)$"  > $nul 
	$matches[1].trim('"') + "\" + $matches[2].trim('"')
	}

	$LocalUsers = $LocalUsers |% {  
	$_.partcomponent –match ".+Domain\=(.+)\,Name\=(.+)$"  > $nul
	$matches[1].trim('"') + "\" + $matches[2].trim('"')
	}

	$RDPUsers = $RDPUsers |% {  
	$_.partcomponent –match ".+Domain\=(.+)\,Name\=(.+)$"  > $nul
	$matches[1].trim('"') + "\" + $matches[2].trim('"')
	}

    $LocalAdmins  = $LocalAdmins | ? {$_ -ne $False} 
    $LocalUsers = $LocalUsers | ? {$_ -ne $False} 
    $RDPUsers  = $RDPUsers | ? {$_ -ne $False} 

    $LocalAdmins | select @{name="Server";expression={$server}},@{name="group";expression={"LocalAdmins"}},@{name="member";expression={$_}}
    $LocalUsers  | select @{name="Server";expression={$server}},@{name="group";expression={"LocalUsers"}},@{name="member";expression={$_}}
    $RDPUsers    | select @{name="Server";expression={$server}},@{name="group";expression={"RDPUsers"}},@{name="member";expression={$_}}
   
}
