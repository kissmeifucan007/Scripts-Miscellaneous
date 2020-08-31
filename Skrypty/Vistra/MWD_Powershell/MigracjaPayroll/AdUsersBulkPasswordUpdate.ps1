#work in progress

$csvFilePath = "I:\IT_Scripts\MWD_Powershell\MigracjaPayroll\payrollResetTrinity12.04.2019"
$csvDelimiter = ';'

$singlePassword = Read-Host "Do you want to use single password for all users? (y/n)"

$users = Import-Csv -Path $csvFilePath -Delimiter $csvDelimiter

$credential = Get-Credential -Message "Provide credential allowed to changed user passwords:" -UserName "work.local\"

if ($singlePassword -like "y"){
   $pass = Get-Credential -UserName "doNotChange" -Message "Provide new user password for all users - user name can be anything"
   foreach ($user in $users){
      #Delete What-If to start processing changes
      Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword $pass.Password -Server work.local -Credential $credential -WhatIf
   }
}

else{
   foreach ($user in $users){
   #Delete What-If to start processing changes
   Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword (ConvertTo-SecureString $user.NewPassword ) -Server work.local -Credential $credential -WhatIf
   }
}




