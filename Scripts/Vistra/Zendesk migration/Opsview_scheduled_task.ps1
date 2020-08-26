$servers = get-adgroupmember -Identity 'Security - IT - Amsterdam Opsview servers' | foreach { $_.Name }
$date = Get-Date -format "yyyy-MM-dd hhmmss"
$office = "AMS"
$log = "\\work.local\itsupport\Global\OpsView\Logs\AMS\$office $date.log"
Foreach ($server in $servers) {
$testpath = test-path "\\$server\c$\Program Files\Opsview Agent\"
echo ------------------------------------------------------------------ 2>%1 >> $log
echo $server  2>%1 >> $log
if ( $testpath -eq $True) {
xcopy "\\work.local\itsupport\Global\OpsView\Agent_Deploy\*" "\\$server\c$\Program Files\Opsview Agent\" /C /S /Y 2>%1 >> $log
psexec \\$server cmd /accepteula /c 'net stop NSClientpp & net start NSClientpp' 2>%1 >> $log
        }
else {
echo "Opsview doesn't seem to be installed on this machine. Please install it manually." 2>%1 >> $log
    }
}