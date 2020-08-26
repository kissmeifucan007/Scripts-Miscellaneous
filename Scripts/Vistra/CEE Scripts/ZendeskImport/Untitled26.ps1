$driveMappingGPOs = get-gpo -all -domain "work.local" | ? {$_.DisplayName -like "*Mapped Network Drives*"}
$driveMappingGPOs[0] | select *

$path = "C:\CEE scripts\ZendeskImport\From Bart\report.html"
$htmlReport = get-gporeport $driveMappingGPOs[0].DisplayName -ReportType html 
$htmlReport
