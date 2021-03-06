workflow inlstall-HyperV {
# Install only the PowerShell module
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell
# Install the Hyper-V management tool pack (Hyper-V Manager and the Hyper-V PowerShell module)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All
# Install the entire Hyper-V stack (hypervisor, services, and tools)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
Restart-Computer -Wait
}
$scriptBlock = {install-HyperV}
Start-Process -FilePath powershell.exe -ArgumentList $ScriptBlock -verb RunAs