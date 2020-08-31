get-module -ListAvailable
Connect-MsolService
import-module msonline
install-module msonline -Force
Get-AzureADSubscribedSku | Select SkuPartNumber
