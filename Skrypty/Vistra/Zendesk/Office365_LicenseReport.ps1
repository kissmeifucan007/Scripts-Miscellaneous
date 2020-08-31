##################################################################################
# THIS SCRIPT WAS WRITTEN AND CREATED BY PETER RIVERA (peter.rivera@vistra.com). #
##################################################################################
# The purpose of this script is to get all licensed users from Office365 and     #
# create a report categorized by the "office" attribute. Each office listed will #
# have a list of products based on the licensed users in that specific office.   #
# Each license has a corresponding price which is multiplied to the count of     #
# users using that product which will be inserted to the MRC field.              #
##################################################################################
# IMPORTANT NOTES:                                                               #
#================================================================================#
# 1. This script runs on a monthly basis in SGPSRVADMIN01.                       #
# 2. Always make sure that the supplied credential file has valid credentials.   #
# 3. Make sure that the SMTP values and recipients are correct.                  #
# 4. Update the product price accordingly ($price variable in PHASE TWO).        #
##################################################################################

#region DECLARATIONS AND DEFINITIONS

$ErrorActionPreference = "SilentlyContinue"

#---LOG OBJECTS---#

$date = (Get-Date -Format yyyy-MM-dd-HHmm)
$curUser = whoami
$curHost = hostname
$logFileName = "\\work.local\itsupport\IT Support - Asia\_Singapore Hub\Script_Logs\O365_License_Review_Logs.txt"
if([System.IO.File]::Exists($logFileName) -eq $false){
    New-Item $logFileName -ItemType file | Out-Null
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Log created from $PSScriptRoot\$($MyInvocation.MyCommand.Name) executed by $curUser"
}

if((Get-Item $logFileName).Length -gt 10mb){
    Write-Host "Log file is greater than 10MB. Consider renaming it."
}

Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Script $PSScriptRoot\$($MyInvocation.MyCommand.Name) executed by $curUser from $curHost"

#---CONNECTIONSTRING---#

$creds = Import-Clixml C:\Scripts\o365-itcl.xml
try {
    Connect-MsolService -Credential $creds
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Successfully connected to MS Online"
} catch {
    Write-Host "An error occurred while connecting to Microsoft Online. Please see logs for detailed information"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Error: Error occured while connecting to Microsoft Online"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t $($error[0].ToString()) + $($error[0].InvocationInfo.PositionMessage)"
}

#endregion

#region PHASE ONE: GET ALL USERS WITH LICENSE

Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Phase one started"

$licensed = Get-MsolUser -All | Where {$_.isLicensed -eq $true -and $_.Licenses[0].ServiceStatus[8].ProvisioningStatus -ne "Disabled"}
$licenseType = $licensed.Licenses.AccountSkuid | Select -Unique

try {
    $licensed = Get-MsolUser -All | Where {$_.isLicensed -eq $true -and $_.Licenses[0].ServiceStatus[8].ProvisioningStatus -ne "Disabled"}
    $licenseType = $licensed.Licenses.AccountSkuid | Select -Unique
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Total of $($licensed.Count) retrieved from server"
} catch {
    Write-Host "An error occurred while getting licensed users from Microsoft Online. Please see logs for detailed information"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Error: Error occured while gathering licensed users from Microsoft Online"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t $($error[0].ToString()) + $($error[0].InvocationInfo.PositionMessage)"
}

#---ORGANIZING THE RETRIEVED USERS---#

$results = @()
try {
    foreach($user in $licensed){
        $results += New-Object PSObject -Property @{
            Name = $user.DisplayName
            Office = $user.Office
            License = $user.Licenses.accountskuid
        }
    }
} catch {
    Write-Host "An error occurred while organizung retrieved users from Microsoft Online. Please see logs for detailed information"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Error: Error occured while processing retrieved users from Microsoft Online"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t $($error[0].ToString()) + $($error[0].InvocationInfo.PositionMessage)"
}

#endregion

#region PHASE TWO: PROCESS LICENSED USERS

Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Phase two started"

#---PRICE DECLARATION---#

$preResult = @()
try {
    foreach($result in $results){
        $price = 0
        $origOffice = $result.Office

        if($result.License.Count -eq 1){
            if($result.License -eq "ofiz:MCOSTANDARD"){
                $price = 3.99
                $result.Office = "VGMAL"
            }
            if($result.License -eq "ofiz:EXCHANGEENTERPRISE"){
                $price = 5.70
            }
            if($result.License -eq "ofiz:ENTERPRISEPACK"){
                $price = 16.72
            }
            if($result.License -eq "ofiz:PROJECTCLIENT"){
                $price = 19.18
            }
            if($result.License -eq "ofiz:MCOMEETADV"){
                $price = 3.69
            }
            if($result.License -eq "ofiz:VISIOCLIENT"){
                $price = 9.41
            }
            if($result.License -eq "ofiz:WACONEDRIVESTANDARD"){
                $price = 3.62
                $result.Office = "VGMAL"
            }
            if($result.License -eq "ofiz:STANDARDPACK"){
                $price = 5.70
            }
            if($result.License -eq "ofiz:O365_BUSINESS_PREMIUM"){
                $price = 9.05
            }
            if($result.License -eq "ofiz:EXCHANGEDESKLESS"){
                $price = 1.46
            }
            if($result.License -eq "ofiz:MCOIMP"){
                $price = 1.43
                $result.Office = "VGMAL"
            }
            if($result.License -eq "ofiz:RIGHTSMANAGEMENT"){
                $price = 1.44
                $result.Office = "VGMAL"
            }
            if($result.License -eq "ofiz:AAD_PREMIUM"){
                $price = 4.28
                $result.Office = "VGMAL"
            }

            $preResult += New-Object PSObject -Property @{
                Office = $result.Office
                License = $result.License
                Price = $price
                Name = $result.Name
            }
        } elseif($result.License.Count -gt 1) {
            foreach($lic in $result.License){
                if($lic -eq "ofiz:MCOSTANDARD"){
                    $price = 3.99
                    $result.Office = "VGMAL"
                }
                if($lic -eq "ofiz:EXCHANGEENTERPRISE"){
                    $price = 5.70
                }
                if($lic -eq "ofiz:ENTERPRISEPACK"){
                    $price = 16.72
                }
                if($lic -eq "ofiz:PROJECTCLIENT"){
                    $price = 19.18
                }
                if($lic -eq "ofiz:MCOMEETADV"){
                    $price = 3.69
                }
                if($lic -eq "ofiz:VISIOCLIENT"){
                    $price = 9.41
                }
                if($lic -eq "ofiz:WACONEDRIVESTANDARD"){
                    $price = 3.62
                    $result.Office = "VGMAL"
                }
                if($lic -eq "ofiz:STANDARDPACK"){
                    $price = 5.70
                }
                if($lic -eq "ofiz:O365_BUSINESS_PREMIUM"){
                    $price = 9.05
                }
                if($lic -eq "ofiz:EXCHANGEDESKLESS"){
                    $price = 1.46
                }
                if($lic -eq "ofiz:MCOIMP"){
                    $price = 1.43
                    $result.Office = "VGMAL"
                }
                if($lic -eq "ofiz:RIGHTSMANAGEMENT"){
                    $price = 1.44
                    $result.Office = "VGMAL"
                }
                if($lic -eq "ofiz:AAD_PREMIUM"){
                    $price = 4.28
                    $result.Office = "VGMAL"
                }

                $preResult += New-Object PSObject -Property @{
                    Office = $result.Office
                    License = $lic
                    Price = $price
                    Name = $result.Name
                }
                $result.Office = $origOffice
            }    
        }
    }
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: $($preResult.Count) licenses out of $($results.Count) processed from licensed users"
} catch {
    Write-Host "An error occurred while processing licensed users. Please see logs for detailed information"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Error: Error occured while processing licensed users"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t $($error[0].ToString()) + $($error[0].InvocationInfo.PositionMessage)"
}

#endregion

#region PHASE THREE: PREPARE FINAL TABLE

Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Phase three started"

$fix = $preResult | Group-Object Office,License
$finalResult = @()
try {
    foreach($line in $fix){

        $splitter = (($line.Name).Split(","))
    
        if($splitter.Count -eq 2) {
            $fSplit = $splitter[1].Replace(" ","")
            $fPrice = ($preResult | Where {$_.License -eq $fSplit})[0].Price
            $office = $splitter[0]
            $lName = $fSplit
        } else {
            $fPrice = ($preResult | Where {$_.License -eq $splitter[0]})[0].Price
            $office = "Vistra CEE"
            $lName = $splitter[0]
        }

        if($lName -eq "ofiz:MCOSTANDARD"){
            $licenseName = "Skype for Business (Plan 2)"
        }
        if($lName -eq "ofiz:EXCHANGEENTERPRISE"){
            $licenseName = "Exchange Online (Plan 2)"
        }
        if($lName -eq "ofiz:ENTERPRISEPACK"){
            $licenseName = "Office 365 Enterprise E3"
        }
        if($lName -eq "ofiz:PROJECTCLIENT"){
            $licenseName = "Project Pro for Office 365"
        }
        if($lName -eq "ofiz:MCOMEETADV"){
            $licenseName = "Skype for Business Audio Conferencing"
        }
        if($lName -eq "ofiz:VISIOCLIENT"){
            $licenseName = "Visio Pro for Office 365"
        }
        if($lName -eq "ofiz:WACONEDRIVESTANDARD"){
            $licenseName = "OneDrive for Business (Plan 1)"
        }
        if($lName -eq "ofiz:STANDARDPACK"){
            $licenseName = "Office 365 Enterprise E1"
        }
        if($lName -eq "ofiz:O365_BUSINESS_PREMIUM"){
            $licenseName = "Office365 Business Premium"
        }
        if($lName -eq "ofiz:EXCHANGEDESKLESS"){
            $licenseName = "Exchange Online Kiosk"
        }
        if($lName -eq "ofiz:MCOIMP"){
            $licenseName = "Skype for Business (Plan 1)"
        }
        if($lName -eq "ofiz:RIGHTSMANAGEMENT"){
            $licenseName = "Azure Information Protection (Plan 1)"
        }
        if($lName -eq "ofiz:AAD_PREMIUM"){
            $licenseName = "Azure Active Directory Premium (Plan 1)"
        }
        if($lName -eq "ofiz:POWER_BI_STANDARD"){
            $licenseName = "Power BI for Office 365 Standard"
            $fPrice = 0
        }
        if($lName -eq "ofiz:SKU_Dynamics_365_for_HCM_Trial"){
            continue
        }

        $finalResult += New-Object PSObject -Property @{
            Office = $office
            License = $licenseName
            Count = $line.Count
            Price = $fPrice
            Cost = $line.Count * $fPrice
        }
    }
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Successfully processed table for export"
} catch {
    Write-Host "An error occurred while processing table for export. Please see logs for detailed information"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Error: Error occured while processing table for export"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t $($error[0].ToString()) + $($error[0].InvocationInfo.PositionMessage)"
}

#endregion

#region PHASE FOUR: EXPORT AND SEND REPORT

Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Phase four started"

#---SORT FINAL TABLE FOR EXPORT---#

$exportResult = $finalResult | Select Office,License,Count,Price,Cost | Sort Office,License

#---TABLE STYLE---#

$htmlReport += "<style>"
$htmlReport += "BODY{background-color:white;}"
$htmlReport += "TABLE{font-family:Arial, Helvetica, sans-serif;border-collapse:collapse;F}"
$htmlReport += "TH{font-size:1.1em;
border:1px solid #a39382;
padding-top:5px;
padding-bottom:5px;
padding-right:7px;
padding-left:7px;
background-color:#bf0d3e;
color:#ffffff;}"
$htmlReport += "TD{
font-size:1em;
border:1px solid #a39382;
padding:5px 5px 5px 5px;
}
"
$htmlReport += "</style>"
$htmlReport += "<table>"
$htmlReport += "`n"
$htmlReport += "<tr>"
$htmlReport += "<th>Office</th>"
$htmlReport += "<th>License</th>"
$htmlReport += "<th>Count</th>"
$htmlReport += "<th>Price</th>"
$htmlReport += "<th>MRC</th>"
$htmlReport += "</tr>"

#---ADDING DATA TO EXPORT TABLE---#

foreach ($res in $exportResult){

    if($exportResult.IndexOf($res) -eq 0){
        $htmlReport += "<tr>"
        $htmlReport += "<td>$($res.Office)</td>"
        $htmlReport += "<td>$($res.License)</td>"
        $htmlReport += "<td>$($res.Count)</td>"
        $htmlReport += "<td>£$($res.Price)</td>"
        $htmlReport += "<td>£$($res.Cost)</td>"
        $htmlReport += "</tr>"
    } else {
        if($res.Office -ne $exportResult[$exportResult.IndexOf($res)-1].Office){
            $htmlReport += "<tr>"
            $htmlReport += "<td>$($res.Office)</td>"
            $htmlReport += "<td>$($res.License)</td>"
            $htmlReport += "<td>$($res.Count)</td>"
            $htmlReport += "<td>£$($res.Price)</td>"
            $htmlReport += "<td>£$($res.Cost)</td>"
            $htmlReport += "</tr>"
        } else {
            $htmlReport += "<tr>"
            $htmlReport += "<td>$($null)</td>"
            $htmlReport += "<td>$($res.License)</td>"
            $htmlReport += "<td>$($res.Count)</td>"
            $htmlReport += "<td>£$($res.Price)</td>"
            $htmlReport += "<td>£$($res.Cost)</td>"
            $htmlReport += "</tr>"
        }
    }
}

#---EMAIL OBJECTS---#

$enc = New-Object System.Text.utf8encoding
try {
    #Send-MailMessage -smtpserver 10.104.10.30 -From "hk.itsupport@vistra.com" -To "Jacco.Sloover@vistra.com","Pravin.Yeole@vistra.com","wendy.ewens@vistra.com","Payable.Asia@vistra.com" -Subject "Vistra - O365 Exchange Online License Count" -Body $htmlReport -BodyAsHtml -Encoding $enc
    Send-MailMessage -smtpserver 10.104.10.30 -From "hk.itsupport@vistra.com" -To "peter.rivera@vistra.com" -Subject "Vistra - O365 Exchange Online License Count" -Body $htmlReport -BodyAsHtml -Encoding $enc
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Report sent successfully"
} catch {
    Write-Host "An error occurred while sending the report. Please see logs for detailed information"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Error: Error occured while sending the report"
    Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t $($error[0].ToString()) + $($error[0].InvocationInfo.PositionMessage)"
}

Add-Content -Path $logFileName -Value "`n$((Get-Date -Format yyyy-MM-dd-HH:mm:ss))`t Information: Script exited successfully"

#endregion