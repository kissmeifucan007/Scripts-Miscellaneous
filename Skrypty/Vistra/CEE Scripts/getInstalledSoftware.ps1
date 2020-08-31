$countryCode = "ZRH"
$searchString = $countryCode + "WRK*"

$computerNames = get-adcomputer -filter {(name -like $searchString) -and (enabled -eq $true)} | select -ExpandProperty name

function Ping-MultipleHosts {
    
  [cmdletbinding()]
  param (
        
    [parameter (Position = 0, 
      Mandatory = $True, 
      ParameterSetName = 'Comp', 
      ValueFromPipeline = $True)]
    [Alias ('ComputerName', 'Name')]
    [string[]]$HostName,

    [parameter (Mandatory = $True, 
      ParameterSetName = 'Range')]
    [IPAddress]$StartAddress,

    [parameter (Mandatory = $True, 
      ParameterSetName = 'Range')]
    [IPAddress]$EndAddress,

    [int]$Timeout = 2000,

    [switch]$DontFragment,

    [int]$BufferSize = 32
  )

  begin {
        
    $global:PingRezult = @()
    $InputObjects = @()

    if ($StartAddress) {

      $IPArray = @()

      $Start = $StartAddress.GetAddressBytes()
      [Array]::Reverse($Start)
      $Start = ([IPAddress]($Start -join '.')).Address

      $End = $EndAddress.GetAddressBytes()
      [Array]::Reverse($End)
      $End = ([IPAddress]($End -join '.')).Address

      for ($i = $Start; $i -le $End; $i++) {
        $IP = ([IPAddress]$i).GetAddressBytes()
        [Array]::Reverse($IP)
        $IPArray += $IP -join '.'  
      }

      $Hostname = $IPArray            
    }
    
  }

  process {

    foreach ($Host_ in $HostName) {
      $InputObjects += $Host_
    }
  }

  end {

    $DF = New-Object Net.NetworkInformation.PingOptions
    if (!$DontFragment) {      
      $DF.DontFragment = $false
    }
    else {
      $DF.DontFragment = $true    
    }

    $InputObjects | foreach {

      $Ping = New-Object System.Net.NetworkInformation.Ping

      Register-ObjectEvent $Ping PingCompleted -Action {
        $global:PingRezult += [pscustomobject][ordered]@{
          Host    = $event.SourceArgs[1].UserState
          Status  = $event.SourceArgs[1].Reply.Status
          Time    = $event.SourceArgs[1].Reply.RoundtripTime
          Address = $event.SourceArgs[1].Reply.Address
        }   
      } | Out-Null

      $Ping.SendAsync($_, $Timeout, (New-Object Byte[] $BufferSize), $DF, $_) | Out-Null
    }

    while ($global:PingRezult.count -lt $InputObjects.Count) {
      Start-Sleep -Milliseconds 10
    }

    return $global:PingRezult
    
  }
}

$pingResults = Ping-MultipleHosts -HostName $computerNames -Timeout 1000
$respondingHosts = $pingResults | Where-Object {$_.status -eq "Success"} | select -ExpandProperty Host
$respondingHostIPs = $pingResults | Where-Object {$_.status -eq "Success"} | select -ExpandProperty Address | select -ExpandProperty IPAddressToString
#$psexecLocation = 'C:\Vistra\tools\psexec.exe'


# Installed module psexec from PSGallery

workflow Enable-Psexec
{
   foreach  -parallel ($ip in $respondingHostIPs){ 
      Parallel
      {  
         Invoke-PsExec -Command 'powershell -Command "Enable-PSRemoting -Force"' -ComputerName $IP -System 
      }
   }
}

Test-Connection 


Function Get-RemoteProgram {
<#
.Synopsis
Generates a list of installed programs on a computer

.DESCRIPTION
This function generates a list by querying the registry and returning the installed programs of a local or remote computer.

.NOTES   
Name       : Get-RemoteProgram
Author     : Jaap Brasser
Version    : 1.5
DateCreated: 2013-08-23
DateUpdated: 2019-08-02
Blog       : http://www.jaapbrasser.com

.LINK
http://www.jaapbrasser.com

.PARAMETER ComputerName
The computer to which connectivity will be checked

.PARAMETER Property
Additional values to be loaded from the registry. Can contain a string or an array of string that will be attempted to retrieve from the registry for each program entry

.PARAMETER IncludeProgram
This will include the Programs matching that are specified as argument in this parameter. Wildcards are allowed. Both Include- and ExcludeProgram can be specified, where IncludeProgram will be matched first

.PARAMETER ExcludeProgram
This will exclude the Programs matching that are specified as argument in this parameter. Wildcards are allowed. Both Include- and ExcludeProgram can be specified, where IncludeProgram will be matched first

.PARAMETER ProgramRegExMatch
This parameter will change the default behaviour of IncludeProgram and ExcludeProgram from -like operator to -match operator. This allows for more complex matching if required.

.PARAMETER LastAccessTime
Estimates the last time the program was executed by looking in the installation folder, if it exists, and retrieves the most recent LastAccessTime attribute of any .exe in that folder. This increases execution time of this script as it requires (remotely) querying the file system to retrieve this information.

.PARAMETER ExcludeSimilar
This will filter out similar programnames, the default value is to filter on the first 3 words in a program name. If a program only consists of less words it is excluded and it will not be filtered. For example if you Visual Studio 2015 installed it will list all the components individually, using -ExcludeSimilar will only display the first entry.

.PARAMETER SimilarWord
This parameter only works when ExcludeSimilar is specified, it changes the default of first 3 words to any desired value.

.PARAMETER DisplayRegPath
Displays the registry path as well as the program name

.PARAMETER MicrosoftStore
Also queries the package list reg key, allows for listing Microsoft Store products for current user

.EXAMPLE
Get-RemoteProgram

Description:
Will generate a list of installed programs on local machine

.EXAMPLE
Get-RemoteProgram -ComputerName server01,server02

Description:
Will generate a list of installed programs on server01 and server02

.EXAMPLE
Get-RemoteProgram -ComputerName Server01 -Property DisplayVersion,VersionMajor

Description:
Will gather the list of programs from Server01 and attempts to retrieve the displayversion and versionmajor subkeys from the registry for each installed program

.EXAMPLE
'server01','server02' | Get-RemoteProgram -Property Uninstallstring

Description
Will retrieve the installed programs on server01/02 that are passed on to the function through the pipeline and also retrieves the uninstall string for each program

.EXAMPLE
'server01','server02' | Get-RemoteProgram -Property Uninstallstring -ExcludeSimilar -SimilarWord 4

Description
Will retrieve the installed programs on server01/02 that are passed on to the function through the pipeline and also retrieves the uninstall string for each program. Will only display a single entry of a program of which the first four words are identical.

.EXAMPLE
Get-RemoteProgram -Property installdate,uninstallstring,installlocation -LastAccessTime | Where-Object {$_.installlocation}

Description
Will gather the list of programs from Server01 and retrieves the InstallDate,UninstallString and InstallLocation properties. Then filters out all products that do not have a installlocation set and displays the LastAccessTime when it can be resolved.

.EXAMPLE
Get-RemoteProgram -Property installdate -IncludeProgram *office*

Description
Will retrieve the InstallDate of all components that match the wildcard pattern of *office*

.EXAMPLE
Get-RemoteProgram -Property installdate -IncludeProgram 'Microsoft Office Access','Microsoft SQL Server 2014'

Description
Will retrieve the InstallDate of all components that exactly match Microsoft Office Access & Microsoft SQL Server 2014

.EXAMPLE
Get-RemoteProgram -Property installdate -IncludeProgram '*[10*]*' | Format-Table -Autosize > MyInstalledPrograms.txt

Description
Will retrieve the ComputerName, ProgramName and installdate of the programs matching the *[10*]* wildcard and using Format-Table and redirection to write this output to text file

.EXAMPLE
Get-RemoteProgram -IncludeProgram ^Office -ProgramRegExMatch

Description
Will retrieve the InstallDate of all components that match the regex pattern of ^Office.*, which means any ProgramName starting with the word Office

.EXAMPLE
Get-RemoteProgram -DisplayRegPath

Description
Will retrieve list of programs from the local system and displays the registry path

.EXAMPLE
Get-RemoteProgram -DisplayRegPath -MicrosoftStore

Description
Will retrieve list of programs from the local system, while also retrieving Microsoft Store package and displaying the registry path
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(ValueFromPipeline              =$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0
        )]
        [string[]]
            $ComputerName = $env:COMPUTERNAME,
        [Parameter(Position=0)]
        [string[]]
            $Property,
        [string[]]
            $IncludeProgram,
        [string[]]
            $ExcludeProgram,
        [switch]
            $ProgramRegExMatch,
        [switch]
            $LastAccessTime,
        [switch]
            $ExcludeSimilar,
        [switch]
            $DisplayRegPath,
        [switch]
            $MicrosoftStore,
        [int]
            $SimilarWord
    )

    begin {
        $RegistryLocation = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\',
                            'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'

        if ($psversiontable.psversion.major -gt 2) {
            $HashProperty = [ordered]@{}    
        } else {
            $HashProperty = @{}
            $SelectProperty = @('ComputerName','ProgramName')
            if ($Property) {
                $SelectProperty += $Property
            }
            if ($LastAccessTime) {
                $SelectProperty += 'LastAccessTime'
            }
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            try {
                $socket = New-Object Net.Sockets.TcpClient($Computer, 445)
                if ($socket.Connected) {
                    'LocalMachine', 'CurrentUser' | ForEach-Object {
                        $RegName = if ('LocalMachine' -eq $_) {
                            'HKLM:\'
                        } else {
                            'HKCU:\'
                        }

                        if ($MicrosoftStore) {
                            $MSStoreRegPath = 'Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages\'
                            if ('HKCU:\' -eq $RegName) {
                                if ($RegistryLocation -notcontains $MSStoreRegPath) {
                                    $RegistryLocation = $MSStoreRegPath
                                }
                            }
                        }
                        
                        $RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::$_,$Computer)
                        $RegistryLocation | ForEach-Object {
                            $CurrentReg = $_
                            if ($RegBase) {
                                $CurrentRegKey = $RegBase.OpenSubKey($CurrentReg)
                                if ($CurrentRegKey) {
                                    $CurrentRegKey.GetSubKeyNames() | ForEach-Object {
                                        Write-Verbose -Message ('{0}{1}{2}' -f $RegName, $CurrentReg, $_)

                                        $DisplayName = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('DisplayName')
                                        if (($DisplayName -match '^@{.*?}$') -and ($CurrentReg -eq $MSStoreRegPath)) {
                                            $DisplayName = $DisplayName  -replace '.*?\/\/(.*?)\/.*','$1'
                                        }

                                        $HashProperty.ComputerName = $Computer
                                        $HashProperty.ProgramName = $DisplayName
                                        
                                        if ($DisplayRegPath) {
                                            $HashProperty.RegPath = '{0}{1}{2}' -f $RegName, $CurrentReg, $_
                                        } 

                                        if ($IncludeProgram) {
                                            if ($ProgramRegExMatch) {
                                                $IncludeProgram | ForEach-Object {
                                                    if ($DisplayName -notmatch $_) {
                                                        $DisplayName = $null
                                                    }
                                                }
                                            } else {
                                                $IncludeProgram | Where-Object {
                                                    $DisplayName -notlike ($_ -replace '\[','`[')
                                                } | ForEach-Object {
                                                        $DisplayName = $null
                                                }
                                            }
                                        }

                                        if ($ExcludeProgram) {
                                            if ($ProgramRegExMatch) {
                                                $ExcludeProgram | ForEach-Object {
                                                    if ($DisplayName -match $_) {
                                                        $DisplayName = $null
                                                    }
                                                }
                                            } else {
                                                $ExcludeProgram | Where-Object {
                                                    $DisplayName -like ($_ -replace '\[','`[')
                                                } | ForEach-Object {
                                                        $DisplayName = $null
                                                }
                                            }
                                        }

                                        if ($DisplayName) {
                                            if ($Property) {
                                                foreach ($CurrentProperty in $Property) {
                                                    $HashProperty.$CurrentProperty = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue($CurrentProperty)
                                                }
                                            }
                                            if ($LastAccessTime) {
                                                $InstallPath = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('InstallLocation') -replace '\\$',''
                                                if ($InstallPath) {
                                                    $WmiSplat = @{
                                                        ComputerName = $Computer
                                                        Query        = $("ASSOCIATORS OF {Win32_Directory.Name='$InstallPath'} Where ResultClass = CIM_DataFile")
                                                        ErrorAction  = 'SilentlyContinue'
                                                    }
                                                    $HashProperty.LastAccessTime = Get-WmiObject @WmiSplat |
                                                        Where-Object {$_.Extension -eq 'exe' -and $_.LastAccessed} |
                                                        Sort-Object -Property LastAccessed |
                                                        Select-Object -Last 1 | ForEach-Object {
                                                            $_.ConvertToDateTime($_.LastAccessed)
                                                        }
                                                } else {
                                                    $HashProperty.LastAccessTime = $null
                                                }
                                            }

                                            if ($psversiontable.psversion.major -gt 2) {
                                                [pscustomobject]$HashProperty
                                            } else {
                                                New-Object -TypeName PSCustomObject -Property $HashProperty |
                                                Select-Object -Property $SelectProperty
                                            }
                                        }
                                        $socket.Close()
                                    }

                                }

                            }

                        }
                    }
                }
            } catch {
                Write-Error $_
            }
        }
    }
}

$installedSoftwareReg =  get-remoteprogram -ComputerName "luxwrk262"

$scriptBlock = {
   Get-ciminstance -Class Win32_Product | Select-Object @{name="Computers";expression={hostname}},name,vendor,version
}

$credential = get-credential

$scriptBlock = {
    Get-WmiObject -Class Win32_Product | Select-Object @{name="Server";expression={hostname}},name,vendor,version
}



Measure-Command {
$installedSoftwareReg =  get-remoteprogram -ComputerName $respondingHosts
}

 

$installedSoftwareReg = @()

 foreach  ($computerName in $respondingHosts){     
           $installedSoftwareReg +=  get-remoteprogram -ComputerName $computerName 
   }

   $ComputersProcessedSuccessfully = $installedSoftwareReg | select -ExpandProperty ComputerName -Unique 
   $Unsuccessful = $respondingHosts | Where-Object {$_ -notin $ComputersProcessedSuccessfully}

   
$filters = @(".*(KB\d+).*", ".*Visual c.*",".*Microsoft Office.*",".*Microsoft \.Net Framework.*",
  "Intel.*","Dell .*","Citrix *","Bomgar Jump Client.*","Realtek .*","Office 16 Click-to-Run .*",
  "Java \d Update \d+")

$uniqueSoftware = $installedSoftwareReg | select -expandProperty programname -Unique | sort 

$filtered = foreach ($software in $uniqueSoftware){
  $result = $software
  foreach ($filter in $filters){
     if ($software -match $filter){
        $result = $null
     } 
  }
  $result
  }

  $filtered| out-file -FilePath  "C:\Vistra\zurich filtered application list.csv" -Force