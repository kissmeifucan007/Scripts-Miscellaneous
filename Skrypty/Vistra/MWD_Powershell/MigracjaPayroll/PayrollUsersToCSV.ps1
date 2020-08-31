#work in progress
$searchBases = "OU=Payroll DC,OU=Users,OU=Warsaw,OU=Vistra,DC=work,DC=local", "OU=Payroll HQ,OU=Users,OU=Warsaw,OU=Vistra,DC=work,DC=local"
$csvFilePath = "I:\IT_Scripts\MWD_Powershell\MigracjaPayroll\payrollUsers.csv"
$csvDelimiter = ','


foreach ($searchBase in $searchBases){
   get-aduser -Server work.local -SearchBase $searchBase -Filter * | Export-Csv -Append -Delimiter $csvDelimiter -Encoding UTF8 -NoTypeInformation -Path $csvFilePath
} 