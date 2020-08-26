$userToCopy = Read-Host -Prompt 'Type name of the user to be copied' 

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$selectUserform = New-Object System.Windows.Forms.Form
$selectUserform.Text = 'Select ad user to copy'
$selectUserform.Size = New-Object System.Drawing.Size(300,200)
$selectUserform.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$selectUserform.AcceptButton = $OKButton
$selectUserform.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$selectUserform.CancelButton = $CancelButton
$selectUserform.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a computer:'
$selectUserform.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

$searchText = "*$userToCopy*"
$users = get-aduser -filter {name -like $searchText} -Properties c,City,co,Company,Country,Department,Description,facsimileTelephoneNumber,Fax,HomePage,l,Manager,MemberOf,Office,physicalDeliveryOfficeName,PostalCode,st,State,StreetAddress,Title,wWWHomePage
foreach ($user in $users){
  [void] $listBox.Items.Add($user)
}

$selectUserform.Controls.Add($listBox)

$selectUserform.Topmost = $true

$result = $selectUserform.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $selection = $listBox.SelectedItem
    $selection
}

<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    New User
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '423,312'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$createButton                    = New-Object system.Windows.Forms.Button
$createButton.text               = "Create"
$createButton.width              = 60
$createButton.height             = 30
$createButton.Anchor             = 'top'
$createButton.location           = New-Object System.Drawing.Point(335,246)
$createButton.Font               = 'Microsoft Sans Serif,10'

$firstNameTextBox                = New-Object system.Windows.Forms.TextBox
$firstNameTextBox.multiline      = $false
$firstNameTextBox.width          = 129
$firstNameTextBox.height         = 20
$firstNameTextBox.location       = New-Object System.Drawing.Point(121,50)
$firstNameTextBox.Font           = 'Microsoft Sans Serif,10'

$LastNameTextBox                 = New-Object system.Windows.Forms.TextBox
$LastNameTextBox.multiline       = $false
$LastNameTextBox.width           = 271
$LastNameTextBox.height          = 20
$LastNameTextBox.location        = New-Object System.Drawing.Point(121,88)
$LastNameTextBox.Font            = 'Microsoft Sans Serif,10'

$DescriptionTextBox              = New-Object system.Windows.Forms.TextBox
$DescriptionTextBox.text         = $result.description
$DescriptionTextBox.multiline    = $false
$DescriptionTextBox.width        = 273
$DescriptionTextBox.height       = 20
$DescriptionTextBox.location     = New-Object System.Drawing.Point(120,166)
$DescriptionTextBox.Font         = 'Microsoft Sans Serif,10'

$InitialsTextBox                 = New-Object system.Windows.Forms.TextBox
$InitialsTextBox.multiline       = $false
$InitialsTextBox.width           = 100
$InitialsTextBox.height          = 20
$InitialsTextBox.location        = New-Object System.Drawing.Point(292,50)
$InitialsTextBox.Font            = 'Microsoft Sans Serif,10'

$LastNameLabel                   = New-Object system.Windows.Forms.Label
$LastNameLabel.text              = "Last name:"
$LastNameLabel.AutoSize          = $true
$LastNameLabel.width             = 25
$LastNameLabel.height            = 10
$LastNameLabel.location          = New-Object System.Drawing.Point(42,92)
$LastNameLabel.Font              = 'Microsoft Sans Serif,10'

$DisplayNameTextBox              = New-Object system.Windows.Forms.TextBox
$DisplayNameTextBox.multiline    = $false
$DisplayNameTextBox.width        = 273
$DisplayNameTextBox.height       = 20
$DisplayNameTextBox.location     = New-Object System.Drawing.Point(121,129)
$DisplayNameTextBox.Font         = 'Microsoft Sans Serif,10'

$firstNameLabel                  = New-Object system.Windows.Forms.Label
$firstNameLabel.text             = "First name:"
$firstNameLabel.AutoSize         = $true
$firstNameLabel.width            = 25
$firstNameLabel.height           = 10
$firstNameLabel.location         = New-Object System.Drawing.Point(45,52)
$firstNameLabel.Font             = 'Microsoft Sans Serif,10'

$DisplayNameLabel                = New-Object system.Windows.Forms.Label
$DisplayNameLabel.text           = "DisplayName:"
$DisplayNameLabel.AutoSize       = $true
$DisplayNameLabel.width          = 25
$DisplayNameLabel.height         = 10
$DisplayNameLabel.location       = New-Object System.Drawing.Point(20,133)
$DisplayNameLabel.Font           = 'Microsoft Sans Serif,10'

$DescriptionLabel                = New-Object system.Windows.Forms.Label
$DescriptionLabel.text           = "Description:"
$DescriptionLabel.AutoSize       = $true
$DescriptionLabel.width          = 25
$DescriptionLabel.height         = 10
$DescriptionLabel.location       = New-Object System.Drawing.Point(32,169)
$DescriptionLabel.Font           = 'Microsoft Sans Serif,10'

$OfficeLabel                     = New-Object system.Windows.Forms.Label
$OfficeLabel.text                = "Office:"
$OfficeLabel.AutoSize            = $true
$OfficeLabel.width               = 25
$OfficeLabel.height              = 10
$OfficeLabel.location            = New-Object System.Drawing.Point(69,203)
$OfficeLabel.Font                = 'Microsoft Sans Serif,10'

$OfficeTextBox                   = New-Object system.Windows.Forms.TextBox
$OfficeTextBox.multiline         = $false
$OfficeTextBox.text              = $result.office
$OfficeTextBox.width             = 275
$OfficeTextBox.height            = 20
$OfficeTextBox.location          = New-Object System.Drawing.Point(120,202)
$OfficeTextBox.Font              = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($createButton,$firstNameTextBox,$LastNameTextBox,$DescriptionTextBox,$InitialsTextBox,$LastNameLabel,$DisplayNameTextBox,$firstNameLabel,$DisplayNameLabel,$DescriptionLabel,$OfficeLabel,$OfficeTextBox))
$form.ShowDialog()