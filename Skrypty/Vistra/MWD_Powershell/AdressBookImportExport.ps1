function Splatt-Command($command) {
   $Parameters = (Get-Command $command).Parameters.Keys
   $Result =  "`$"+$command.Replace("-","")+'Splatt = @{'
   foreach ($Parameter in $Parameters) {
      $Result += "`r`n   #"+$Parameter+' = '+ (Get-Command $command).Parameters[$Parameter].ParameterType
   }
   $Result += "`r`n}"
   $Result | clip
}


$cityList = @(
  "Warsaw",
  "Poznan",
  "Lublin",
  "Wroclaw",
  "Budapest",
  "Sofia",
  "Prague",
  "Bucharest"
)

$city = $cityList[$host.UI.PromptForChoice('Select city', 'Choose city', $cityList, 0)]

$exportCSVSplat = @{
   Delimiter = ';'
   Encoding = "UTF8"
   NotypeInformation = $true
   Path = "\\plwafs01\it$\IT_Scripts\MWD_Powershell\XeroxCsv\XeroxAddressBook$city.csv"
   Force = $true
}


$SelectObjectSplatt = @{
    Property = @{N="XrxAddressBookId";E={""}},
               @{N="DisplayName";E={$_.name}},
               @{N="FirstName";E={$_.firstName}},
               @{N="LastName";E={$_.LastName}},
               @{N="Company";E={""}},
               @{N="XrxAllFavoritesOrder";E={""}},
               @{N="MemberOf";E={"`"`""}},
               @{N="IsDL";E={0}},
               @{N="XrxApplicableWorkflows";E={""}},
               @{N="FaxNumber";E={""}},
               @{N="XrxIsFaxFavorite";E={""}},
               @{N="E-mailAddress";E={$_.emailaddress}},
               @{N="XrxIsEmailFavorite";E={""}},
               @{N="InternetFaxAddress";E={""}},
               @{N="ScanNickName";E={$_name}},
               @{N="XrxIsScanFavorite";E={0}},
               @{N="ScanTransferProtocol";E={4}},
               @{N="ScanServerAddress";E={"(null)"}},
               @{N="ScanServerPort";E={0}},
               @{N="ScanDocumentPath";E={""}},
               @{N="ScanLoginName";E={""}},
               @{N="ScanLoginPassword";E={""}},
               @{N="ScanSMBShare";E={""}},
               @{N="ScanNDSTree";E={""}},
               @{N="ScanNDSContext";E={""}},
               @{N="ScanNDSVolume";E={""}}
}
		

$exportData = Get-ADUser -Server work.local -Filter {office -eq $city} -Properties *| select @SelectObjectSplatt

for ($i = 0; $i -lt $exportData.Count; $i++)
{ 
    $exportData[$i].XrxAddressBookId = $i+1
    $exportData[$i].XrxAllFavoritesOrder = $i+1
}

$exportData | Out-GridView
$exportData | Export-Csv @exportCSVSplat
start $exportCSVSplat.Path

