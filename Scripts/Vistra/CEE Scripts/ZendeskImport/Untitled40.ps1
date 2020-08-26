Add-Type -AssemblyName System.Windows.Forms
$credential = get-credential
enter-pssession 10.10.10.210 -Credential $credential -UseSSL

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('\\10.10.10.210\home$') }
$null = $FileBrowser.ShowDialog()


get-a