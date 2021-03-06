<#
    .SYNOPSIS
        Creates a bootable VHD/VHDx containing Windows Server Nano 2016 RTM

    .DESCRIPTION
        Creates a bootable VHD/VHDx containing Windows Server Nano 2016 using the publically available Windows Server 2016 RTM ISO.

        This script needs the Convert-WindowsImage.ps1 script to be in the same folder. It will be automatically downloaded from if it is not found:
        https://raw.githubusercontent.com/PlagueHO/New-NanoServerVHD/master/Convert-WindowsImage.ps1

        This function turns the instructions on the following link into a repeatable script:
        https://technet.microsoft.com/en-us/library/mt126167.aspx

        Plesae see the link for additional information.

        This script can be found:
        Github Repo: https://github.com/PlagueHO/New-NanoServerVHD

    .PARAMETER ServerISO
    This is the path to the Windows Server 2016 RTM ISO downloaded from:
    https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016

    .PARAMETER DestVHD
    This is the path and name of the new Nano Server VHD.

    .PARAMETER VHDFormat
    Specifies whether to create a VHD or VHDX formatted Virtual Hard Disk. The default is VHD.

    .PARAMETER Packages
    This is a list of the packages to install in this Nano Server. As of RTM the available packages are:
    Compute = Hyper-V Server
    OEM-Drivers = Standard OEM Drivers
    Storage = Storage Server
    FailoverCluster = FailOver Cluster Server
    ReverseForwarders = ReverseForwarders to allow some older App Servers to run
    Guest = Hyper-V Guest Tools
    Containers = Support for Hyper-V and Windows containers
    Defender = Windows Defender
    DCB = DCB
    DNS = DNS Server
    DSC = PowerShell Desired State Configuration Support
    IIS = Internet Information Server (Web Server)
    NPDS = NPDS
    SCVMM = System Center VMM
    SCVMM-Compute = Sysmte Center VMM Compute
    BootFromWim = Boot from WIM
    SecureStartup = Secure Startup
    ShieldedVM = Shielded VM

    If not specified then packages OEM-Drivers, Storage and Guest packages are installed.

    .PARAMETER ComputerName
    This is the Computer Name for the new Nano Server (if the default Unattended.XML is used).

    .PARAMETER AdministratorPassword
    This is the Administrator account password for the new Nano Server (if the default Unattended.XML is used).

    .PARAMETER IPAddress
    This is a Static IP address to assign to the first ethernet card in this Nano Server. If not passed it will use DHCP.

    .PARAMETER SubnetMask
    This is the the subnet mask to use with the static IP address to assign to the first ethernet card
    in this Nano Server. Should only be passed if IPAddress is provided. Defaults to 255.255.255.0.

    .PARAMETER GatewayAddress
    This is the gateway IP address to assign to the first ethernet card in this Nano Server if static IP Address is
    being used. Should only be passed if IPAddress is provided.

    .PARAMETER DNSAddresses
    These are the DNS Serverer addresses to assign to the first ethernet card in this Nano Server if static IP Address
    is being used. Should only be passed if IPAddress is provided.

    .PARAMETER RegisteredOwner
    This is the Registered Owner that will be set for the Nano Server (if the default Unattended.XML is used).

    .PARAMETER RegisteredCorporation
    This is the Registered Corporation name that will be set for the Nano Server (if the default Unattended.XML is used).

    .PARAMETER UnattendedContent
    Allows the content of the Unattended.XML file to be overridden. Provide the content of a new Unattended.XML file in this parameter.

    .PARAMETER Edition
    This is the index name of the edition to install from the NanoServer.WIM. It defaults to 'Windows Server 2016 SERVERSTANDARDNANO'.

    As of RTM, there are two versions in the NanoServer.WIM:
    Windows Server 2016 SERVERSTANDARDNANO
    Windows Server 2016 SERVERDATACENTERNANO

    .PARAMETER Timezone
    This is the timezone the new NanoServer will be set to. If not provided it will default to Pacific Standard Time.

    .PARAMETER CacheFolder
    If this parameter is passed then the base NanoServer.VHD/VHDx file will be cached in this folder so that
    building new NanoServer images are faster. If the base NanoServer.VHD/VHDx file does not exist in this folder
    it will be created using Convert-WindowsImage.

    .PARAMETER DJoinFile
    This is the full path to the offline domain join blob file to use to join this server to the domain. The domain join
    File can be created manually by executing:
    DJOIN /provision /domain CONTOSO.COM /machine NANO01 /savefile c:\DJOIN_NANO01.TXT

    .PARMATER WorkFolder
    This is the path that this script will use to store temporary work files while creating the Nano Server VHD/VHDx.
    It defaults to %TEMP%\NanoSever if this parameter is not passed. If there is not enough space in your %TEMP% folder
    this can be used to specify a different working location.

    .EXAMPLE
        .\New-NanoServerVHD.ps1 `
            -ServerISO 'D:\ISOs\Windows Server 2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO' `
            -DestVHD D:\Temp\NanoServer01.vhd `
            -ComputerName NANOTEST01 `
            -AdministratorPassword 'P@ssword!1' `
            -Packages 'Storage','OEM-Drivers','Guest' `
            -IPAddress '10.0.0.20' `
            -SubnetMask '255.0.0.0' `
            -GatewayAddress '10.0.0.1' `
            -DNSAddresses '10.0.0.2','10,0,0,3'
            -Verbose

        This command will create a new VHD containing a Nano Server machine with the name NANOTEST01. It will contain only the Storage, OEM-Drivers and Guest packages.
        It will set the Administrator password to P@ssword!1 and set the IP address of the first ethernet NIC to 10.0.0.20/255.0.0.0 with gateway of 10.0.0.1 and DNS
        set to '10.0.0.2','10,0,0,3'

    .EXAMPLE
        .\New-NanoServerVHD.ps1 `
            -ServerISO 'D:\ISOs\Windows Server 2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO' `
            -DestVHD D:\Temp\NanoServer02.vhdx `
            -VHDFormat VHDX `
            -ComputerName NANOTEST02 `
            -AdministratorPassword 'P@ssword!1' `
            -Packages 'Storage','OEM-Drivers','Guest' `
            -IPAddress '192.168.1.66' `
            -Verbose

        This command will create a new VHDx (for Generation 2 VMs) containing a Nano Server machine with the name NANOTEST02. It will contain only the Storage, OEM-Drivers and Guest packages.
        It will set the Administrator password to P@ssword!1 and set the IP address of the first ethernet NIC to 192.168.1.66/255.255.255.0 with no Gateway or DNS.

    .EXAMPLE
        .\New-NanoServerVHD.ps1 `
            -ServerISO 'D:\ISOs\Windows Server 2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO' `
            -DestVHD D:\Temp\NanoServer03.vhdx `
            -VHDFormat VHDX `
            -ComputerName NANOTEST03 `
            -AdministratorPassword 'P@ssword!1' `
            -Packages 'Compute','OEM-Drivers','Guest','Containers','ReverseForwarders' `
            -IPAddress '192.168.1.66' `
            -DJoinFile 'D:\Temp\DJOIN_NANOTEST03.TXT' `
            -Verbose

        This command will create a new VHDx (for Generation 2 VMs) containing a Nano Server machine with the name NANOTEST03. It will contain be configured to be a container host.
        It will set the Administrator password to P@ssword!1 and set the IP address of the first ethernet NIC to 192.168.1.66/255.255.255.0 with no Gateway or DNS. It will also be joined to
        a domain using the Offline Domain Join file D:\Temp\DJOIN_NANOTEST03.TXT.

    .LINK
    https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016

    .LINK
    https://technet.microsoft.com/en-us/library/mt126167.aspx
#>
#Requires -Version 4.0

[CmdLetBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path -Path $_ })]
    [String]$ServerISO,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$DestVHD,

    [ValidateNotNullOrEmpty()]
    [ValidateSet('VHD', 'VHDX')]
    [String]$VHDFormat  = 'VHD',

    [ValidateSet('Compute','OEM-Drivers','Storage','FailoverCluster','Guest','Containers','Defender','DCB','DNS','DSC','IIS','NPDS','SCVMM','SCVMM-Compute','BootFromWim','SecureStartup','ShieldedVM')]
    [String[]]$Packages = @('OEM-Drivers','Storage','Guest'),

    [ValidateNotNullOrEmpty()]
    [String]$ComputerName = 'NanoServer01',

    [Parameter(
        Mandatory = $true,
        HelpMessage='Enter the Administrator password of the new Nano Server.'
        )]
    [String]$AdministratorPassword,

    [ValidateNotNullOrEmpty()]
    [String]$IPAddress,

    [ValidateNotNullOrEmpty()]
    [String]$SubnetMask='255.255.255.0',

    [ValidateNotNullOrEmpty()]
    [String]$GatewayAddress,

    [ValidateNotNullOrEmpty()]
    [String[]]$DNSAddresses,

    [ValidateNotNullOrEmpty()]
    [String]$RegisteredOwner = 'Nano Server User',

    [ValidateNotNullOrEmpty()]
    [String]$RegisteredCorporation = 'Contoso',

    [ValidateNotNullOrEmpty()]
    [String]$UnattendedContent,

    [ValidateNotNullOrEmpty()]
    [String]$Edition = 'Windows Server 2016 SERVERDATACENTERNANO',

    [ValidateNotNullOrEmpty()]
    [String]$Timezone = 'Pacific Standard Time',

    [ValidateNotNullOrEmpty()]
    [String]$CacheFolder,

    [ValidateNotNullOrEmpty()]
    [String]$DJoinFile,

    [ValidateNotNullOrEmpty()]
    [String]$WorkFolder = $ENV:Temp
)

If (-not (Test-Path -Path .\Convert-WindowsImage.ps1 -PathType Leaf)) {
    Write-Host 'Downloading the Convert-WindowsImage.ps1 script from GitHub'
    Invoke-WebRequest `
        -Uri 'https://raw.githubusercontent.com/PlagueHO/New-NanoServerVHD/master/Convert-WindowsImage.ps1' `
        -OutFile .\Convert-WindowsImage.ps1 `
}

# Check the Cache Folder exists
if ($CacheFolder) {
    if (-not (Test-Path -Path $CacheFolder)) {
        Throw "The CacheFolder $CacheFolder could not be found. Please specify a valid folder."
    }
}

# Check the Work Folder
If (-not (Test-Path -Path $WorkFolder)) {
    Write-Error -Message "The WorkFolder path '$WorkFolder' does not exist. Please specify a valid folder."
    Return
}


# Generate the file content for the Setup Complete script that runs on the VM
# Do this first because we can do address validation at the same time.
[String]$SetupComplete = "@ECHO OFF`n"
If ($IPaddress)
{
    if(!([System.Net.Ipaddress]::TryParse($IPaddress, [ref]0)))
    {
        Throw "The IP Address '$IPaddress' is not in a valid format"
    }
    # Defining these as variables in case at some point need to allow them to be overridden.
    $InterfaceAlias = 'Ethernet'
    $AddressFamiyly = 'IPv4'
    # For some reason setting this stuff via powershell doesn't work - so use NETSH.
    If ($GatewayAddress)
    {
        if(!([System.Net.Ipaddress]::TryParse($GatewayAddress, [ref]0)))
        {
            Throw "The Gateway Address '$GatewayAddress' is not in a valid format"
        }
        $IPAddressConfigString += "netsh interface ip set address $InterfaceAlias static addr=$IPaddress mask=$SubnetMask gateway=$GatewayAddress`n"
    } else {
        $IPAddressConfigString += "netsh interface ip set address $InterfaceAlias static addr=$IPaddress mask=$SubnetMask`n"
    }
    If ($DNSAddresses)
    {
        $Count = 1
        foreach ($DNSAddress in $DNSAddresses)
        {
            if(!([System.Net.Ipaddress]::TryParse($DNSAddress, [ref]0)))
            {
                Throw "The DNS Server Address '$DNSAddress' is not in a valid format"
            }
            If ($Count -eq 1)
            {
                $IPAddressConfigString += "netsh interface ip set dns $InterfaceAlias static addr=$DNSAddress`n"
            } Else {
                $IPAddressConfigString += "netsh interface ip add dns $InterfaceAlias addr=$DNSAddress index=$Count`n"
            }
            $Count++
        }
    }
    # Set a static IP Address on the machine
    $SetupComplete += $IPAddressConfigString
} # If

# Adjust the Work folder to create a subfolder
[String]$WorkFolder = Join-Path -Path $WorkFolder -ChildPath 'NanoServer'
[String]$DismFolder = Join-Path -Path $WorkFolder -ChildPath 'DISM'
[String]$MountFolder = Join-Path -Path $WorkFolder -ChildPath 'Mount'
[String]$TempVHDName = "NanoServer.$VHDFormat"
Switch ($VHDFormat) {
    'VHD' { [String]$DiskLayout = 'BIOS' }
    'VHDx' { [String]$DiskLayout = 'UEFI' }
}

# Create working folder
Write-Verbose -Message 'Creating Working Folders'
If (-not (Test-Path -Path $WorkFolder -PathType Container)) {
    $null = New-Item -Path $WorkFolder -ItemType Directory
}

# Mount the Windows Server 2016 ISO and get the drive letter
Write-Verbose -Message 'Mounting Server ISO'
$null = Mount-DiskImage -ImagePath $ServerISO
[String]$DriveLetter = (Get-Diskimage -ImagePath $ServerISO | Get-Volume).DriveLetter

# Copy DISM off the Windows ISO and put it into the working folder.
Write-Verbose 'Copying DISM from Server ISO to Working Folders'
If (-not (Test-Path -Path $DismFolder -PathType Container)) {
    $null = New-Item -Path $DismFolder -ItemType Directory
}
$null = Copy-Item -Path "$($DriveLetter):\Sources\api*downlevel*.dll" -Destination $DismFolder -Force
$null = Copy-Item -Path "$($DriveLetter):\Sources\*dism*" -Destination $DismFolder -Force
$null = Copy-Item -Path "$($DriveLetter):\Sources\*provider*" -Destination $DismFolder -Force

# Use Convert-WindowsImage.ps1 to convert the NanoServer.WIM into a VHD
Write-Verbose -Message 'Creating base Nano Server Image from WIM file'

$TempVHD = Join-Path -Path $WorkFolder -ChildPath $TempVHDName
if ($CacheFolder) {
    $CachedVHD = Join-Path -Path $CacheFolder -ChildPath $TempVHDName
    if (-not (Test-Path -Path $CachedVHD)) {
        # As of 2015-06-16 Convert-WindowsImage contains a function instead of being a standalone script.
        # . source the Convert-WindowsImage.ps1 so it can be called
        . .\Convert-WindowsImage
        Convert-WindowsImage `
            -Sourcepath "$($DriveLetter):\NanoServer\NanoServer.wim" `
            -VHD $CachedVHD `
            –VHDFormat $VHDFormat `
            -Edition $Edition `
            -DiskLayout $DiskLayout
    }
    $null = Copy-Item -Path $CachedVHD -Destination $TempVHD
} else {
    # As of 2015-06-16 Convert-WindowsImage contains a function instead of being a standalone script.
    # . source the Convert-WindowsImage.ps1 so it can be called
    . .\Convert-WindowsImage
    Convert-WindowsImage `
        -Sourcepath "$($DriveLetter):\NanoServer\NanoServer.wim" `
        -VHD $TempVHD `
        –VHDFormat $VHDFormat `
        -Edition $Edition `
        -DiskLayout $DiskLayout
}


If (-not (Test-Path -Path $MountFolder -PathType Container)) {
    $null = New-Item -Path $MountFolder -ItemType Directory
}

# Mount the VHD to load packages into it
& "$DismFolder\Dism.exe" '/Mount-Image' "/ImageFile:$TempVHD" '/Index:1' "/MountDir:$MountFolder"

$PackageList = @(
    @{ Name = 'Compute'; Filename = 'Microsoft-NanoServer-Compute-Package.cab' },
    @{ Name = 'OEM-Drivers'; Filename = 'Microsoft-NanoServer-OEM-Drivers-Package.cab' },
    @{ Name = 'Storage'; Filename = 'Microsoft-NanoServer-Storage-Package.cab' },
    @{ Name = 'FailoverCluster'; Filename = 'Microsoft-NanoServer-FailoverCluster-Package.cab' },
    @{ Name = 'Guest'; Filename = 'Microsoft-NanoServer-Guest-Package.cab' },
    @{ Name = 'Containers'; Filename = 'Microsoft-NanoServer-Containers-Package.cab' },
    @{ Name = 'Defender'; Filename = 'Microsoft-NanoServer-Defender-Package.cab' },
    @{ Name = 'DCB'; Filename = 'Microsoft-NanoServer-DCB-Package.cab' },
    @{ Name = 'DNS'; Filename = 'Microsoft-NanoServer-DNS-Package.cab' },
    @{ Name = 'DSC'; Filename = 'Microsoft-NanoServer-DSC-Package.cab' },
    @{ Name = 'IIS'; Filename = 'Microsoft-NanoServer-IIS-Package.cab' },
    @{ Name = 'NPDS'; Filename = 'Microsoft-NanoServer-NPDS-Package.cab' },
    @{ Name = 'SCVMM'; Filename = 'Microsoft-NanoServer-SCVMM-Package.cab' },
    @{ Name = 'SCVMM-Compute'; Filename = 'Microsoft-NanoServer-SCVMM-Compute-Package.cab' },
    @{ Name = 'BootFromWim'; Filename = 'Microsoft-NanoServer-BootFromWim-Package.cab' },
    @{ Name = 'SecureStartup'; Filename = 'Microsoft-NanoServer-SecureStartup-Package.cab' },
    @{ Name = 'ShieldedVM'; Filename = 'Microsoft-NanoServer-ShieldedVM-Package.cab' }
)

# Add the selected packages
foreach ($Package in $PackageList) {
    If ($Package.Name -in $Packages) {
        Write-Verbose -Message "Adding Package $($Package.Filename) to Image"
        & "$DismFolder\Dism.exe" '/Add-Package' "/PackagePath:$($DriveLetter):\NanoServer\packages\$($Package.Filename)" "/Image:$MountFolder"
        $PackageLangFile = $Package.Filename -replace '.cab',"_en-us.cab"
        & "$DismFolder\Dism.exe" '/Add-Package' "/PackagePath:$($DriveLetter):\NanoServer\packages\en-us\$PackageLangFile" "/Image:$MountFolder"
    }
}

# Apply Unattended File
If (($UnattendedContent -eq $null) -or ($UnattendedContent -eq '')) {
# For some reason applying computername in the Offline Servicing Phase doesn't work
# So it can be applied in the Specialize phase...

$UnattendedContent = [String] @"
<?xml version='1.0' encoding='utf-8'?>
<unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <settings pass="offlineServicing">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
      <ComputerName>$ComputerName</ComputerName>
    </component>
  </settings>

  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
      <UserAccounts>
        <AdministratorPassword>
           <Value>$AdministratorPassword</Value>
           <PlainText>true</PlainText>
        </AdministratorPassword>
      </UserAccounts>
      <TimeZone>$Timezone</TimeZone>
    </component>
  </settings>

  <settings pass="specialize">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
      <RegisteredOwner>$RegisteredOwner</RegisteredOwner>
      <RegisteredOrganization>$RegisteredCorporation</RegisteredOrganization>
    </component>
  </settings>
</unattend>
"@
}

Write-Verbose -Message 'Assigning Unattended.XML file to Nano Server'
$UnattendFile = Join-Path -Path $WorkFolder -ChildPath 'Unattend.xml'
Set-Content -Path $UnattendFile -Value $UnattendedContent
& "$DismFolder\Dism.exe" "/Image:$MountFolder" "/Apply-Unattend:$UnattendFile"
$null = New-Item -Path "$MountFolder\windows\panther" -ItemType Directory
$null = Copy-Item -Path $UnattendFile -Destination "$MountFolder\windows\panther"

# Write the Setup Complete script to the image
$null = New-Item "$MountFolder\Windows\Setup\Scripts" -ItemType Directory
Set-Content -Path "$MountFolder\Windows\Setup\Scripts\SetupComplete.cmd" -Value $SetupComplete

# Join a domain using offline Domain Join (DJOIN)?
if ($DJoinFile)
{
    if (-not (Test-Path -Path $DJoinFile))
    {
        Throw "The specified Domain Join File '$DJoinFile' could not be found"
    }
    Write-Verbose -Message "Applying DJoin File '$DJoinFile' to '$MountFolder\Windows'"
    & djoin @('/RequestODJ','/LoadFile',$DJoinFile,'/WindowsPath',"$MountFolder\Windows")
}

# Dismount the image after adding the Packages to it and configuring it
Write-Verbose -Message 'Dismounting Nano Server Image'
& "$DismFolder\Dism.exe" '/Unmount-Image' "/MountDir:$MountFolder" '/Commit'

# Dismount the ISO File
Write-Verbose -Message 'Dismounting Server ISO'
Dismount-DiskImage -ImagePath $ServerISO

Write-Verbose -Message "Moving Nano Server Image to $DestVHD"
$null = Copy-Item -Path $TempVHD -Destination $DestVHD -Force

# Cleanup
Write-Verbose -Message 'Cleaning up Working Folders'
$null = Remove-Item -Path $MountFolder -Recurse -Force
$null = Remove-Item -Path $DismFolder -Recurse -Force
$null = Remove-Item -Path $WorkFolder -Recurse -Force