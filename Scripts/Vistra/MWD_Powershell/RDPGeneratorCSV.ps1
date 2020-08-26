$ServersPath = "I:\IT_Scripts\MWD_Powershell\Servers.csv"
$usersPath = "I:\IT_Scripts\MWD_Powershell\!STARTERS EXCEl.csv"
$basePath = "I:\IT_Scripts\MWD_Powershell\RDP"

$servers = import-csv -Delimiter ";" -Encoding UTF8 -Path $ServersPath
$users = import-csv -Delimiter ";" -Encoding UTF8 -Path $usersPath


foreach ($user in $users){
   $path = $basePath + "\" + $user.'Name Surname'
   $username = "work.local\"+$user.'AD - work.local'
   $city = (get-aduser $user.'AD - work.local' -Properties City -Server work.local).city
   $terminalServer =($servers | Where-Object {$_.city -eq $City -and ($_.Mid -eq "TM")} | select IP).IP
   New-Item -Path $path -ItemType Directory
   (Get-Content I:\IT_Scripts\MWD_Powershell\rdp.rdp) `
    -replace '(?<=full address:s:)', $terminalServer `
    -replace '(?<=username:s:)', $username |
    Out-File ($path +"\Terminal.rdp") -Force
}

<#
$cities = $servers | select City | Group-Object {$_.City} |select name |sort

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Computer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a computer:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

foreach ($city in $cities){
[void] $listBox.Items.Add($city.Name)
}

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $listBox.SelectedItem
}

$terminalServer =($servers | Where-Object {$_.city -eq $x -and ($_.Mid -eq "TM")} | select IP).IP
$username = Read-Host -Prompt "user name for RDP connection"

(Get-Content I:\IT_Scripts\MWD_Powershell\rdp.rdp) `
    -replace '(?<=full address:s:)', $terminalServer `
    -replace '(?<=username:s:)', $username |
  Out-File I:\IT_Scripts\MWD_Powershell\rdpOut.rdp -Force
  Get-Content I:\IT_Scripts\MWD_Powershell\rdpOut.rdp

#>