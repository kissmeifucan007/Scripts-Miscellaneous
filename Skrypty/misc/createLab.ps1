[CmdletBinding()]
param()

$AzureModuleSourceURL = 'https://raw.githubusercontent.com/Azure/azure-devtestlab/master/samples/ClassroomLabs/Modules/Library/Az.LabServices.psm1'
$moduleFileName =  Split-Path -Path $AzureModuleSourceURL -Leaf
$PowershellModulesPath = "$env:PROGRAMFILES\WindowsPowerShell\Modules"
$targetPath = Join-Path $PowershellModulesPath $moduleFileName
Invoke-WebRequest -Uri $AzureModuleSourceURL -OutFile $targetPath
Import-Module $targetPath

$accountName     = "AccountName"
$labName    = "LabName"
$resourceGroupName     = "ResourceGroupName"
$hoursQuota = 20
$userName = "userName"
$password = "PaSSw0rd"
$email = "mwojewoda@sii.pl"
$resourceGroupLocation = "West Europe"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation| Out-Null

$labAccount = New-AzLabAccount -ResourceGroupName $resourceGroupName -LabAccountName $accountName
$image = ($labAccount| Get-AzLabAccountGalleryImage)[0] # Pick the first image, also have a Get-AzLabAccountSharedImage

$lab = $labAccount  |
    New-AzLab -LabName $LabName -Image $image -Size Basic -UsageQuotaInHours $hoursQuota  -SharedPasswordEnabled -UserName $userName -Password $password |
    Publish-AzLab |
    Add-AzLabUser -Emails $email |
    Set-AzLab -UsageQuotaInHours 20

$user = $lab | Get-AzLabUser -Email 'lucabol*'
$lab | Send-AzLabUserInvitationEmail -User $user -InvitationText 'Running tests'

$vm = $lab | Get-AzLabVm -ClaimByUser $user

$today  = (Get-Date).ToString()
$end    = (Get-Date).AddMonths(4).ToString()

$lab | New-AzLabSchedule -Frequency Weekly -FromDate $today -ToDate $end -StartTime '10:00' -EndTime '11:00' -Notes 'A classroom note.' | Out-Null
$lab | Get-AzLabSchedule `
     | Remove-AzLabSchedule

$lab | Remove-AzLabuser -User $user
$lab | Remove-AzLab

Remove-AzLabAccount -LabAccount $la
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force | Out-Null
Remove-Module Az.LabServices -Force