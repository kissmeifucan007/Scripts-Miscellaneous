function Splatt-Command($command) {
   $Parameters = (Get-Command $command).Parameters.Keys
   $Result =  "`$"+$command.Replace("-","")+'Splatt = @{'
   foreach ($Parameter in $Parameters) {
      $Result += "`r`n   #"+$Parameter+' = '+ (Get-Command $command).Parameters[$Parameter].ParameterType
   }
   $Result += "`r`n}"
   $Result | clip
}

Function Get-Folder()
{  
    Param(
        [string]
        $InitialDirectory
        )
    Add-Type -AssemblyName System.Windows.Forms
    $foldername=New-Object System.Windows.Forms.OpenFileDialog
    $foldername.InitialDirectory = $initialDirectory
    $foldername.ShowDialog()
    $foldername.Description = "Select a folder"
    
    #= $InitialDirectory
    [void]$foldername.ShowDialog()
    $foldername.SelectedPath
}

Function Get-Filename()
{  
     Param(
        [string]
        $InitialDirectory,
        [string]
        $Extension
        )
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    $FileBrowser.InitialDirectory = $Directory
    $FileBrowser.filter = "Txt ($extension)| $extension"
    [void]$FileBrowser.ShowDialog()
    $FileBrowser.FileName
}


#$baseDirectory =  '\\plwafs01\COMMON_PL$\IT\NBP Certificates'
$baseDirectory = "\\$env:Computername\P$\IT\NBP Certificates"
$Directory = Get-Folder -InitialDirectory $baseDirectory
$certPath = Get-FileName -initialDirectory $Directory -extension "*.pfx"
$passowrdPath = Get-FileName -initialDirectory $Directory -extension "*.txt"

$ImportPfxCertificateSplatt = @{
   Exportable = $true
   Password = ConvertTo-SecureString(get-content($passowrdPath))
   CertStoreLocation = "cert:\localMachine\my"
   FilePath = $certPath
   
}


Import-PfxCertificate @ImportPfxCertificateSplatt