# Start cmd.exe as local user - to allow finding user's SID
$localusername = (Get-WmiObject -Class Win32_Process -Filter 'Name="cmd.exe"').GetOwner().User
$AdObj = New-Object System.Security.Principal.NTAccount($localusername)
#Store user's SID in variable
$sid = ($AdObj.Translate([System.Security.Principal.SecurityIdentifier])).Value

Write-Host "User to add registry changes - $localusername : $username"

try {
    # try to add EnableAdal entry with value 0 to user's registry
    New-PSDrive -Name HKUser -PSProvider Registry -Root "HKEY_USERS\$sid" | Out-Null
    $value = 0
    $Name = "EnableADAL"
    $path = "HKUser:\SOFTWARE\Microsoft\Office\16.0\Common\Identity\"
    
    # Apply the changes, confirm action needed
    New-ItemProperty -Path $path -Name $name -Value $value -PropertyType DWORD -Confirm


} finally {
     #  close psdrive connection
    Remove-PSDrive -Name HKUser
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}