function Set-ADLeaver {
param(
[Parameter(Mandatory,Position=0)]
[String]$username
)

$getaduserSplatt = @{
   Identity = $username
   SearchBase = "OU=Leavers,OU=Luxembourg,OU=Vistra,DC=work,DC=local"
   Server = "work.local"
   Properties = "*"
}

$adUsers = Get-ADUser @getaduserSplatt
$adUsers
}

function List-Adusers {
param(
[Parameter(Mandatory,Position=0)]
[String]$username
)

$usernameFilter = "*$username*"

$getaduserSplatt = @{
   Filter = {name -like $usernameFilter}
   SearchBase = "OU=Leavers,OU=Luxembourg,OU=Vistra,DC=work,DC=local"
   Server = "work.local"
   Properties = "*"
}

$adUsers = Get-ADUser @getaduserSplatt


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select ADUser'
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
$label.Text = 'Please select Leaver:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80


foreach ($user in $adUsers){
   [void] $listBox.Items.Add($user)
}

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $return = $listBox.SelectedItem
    $return
}
}



$username = Read-Host -Prompt "Get user"

$user = List-Adusers $username

get-date -UFormat %d/%m/%Y

