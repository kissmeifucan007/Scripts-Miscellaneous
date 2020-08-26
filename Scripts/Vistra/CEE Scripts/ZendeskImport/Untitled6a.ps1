$PragueOU = "OU=Prague,OU=Czech Republic,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"

$users = get-aduser -Filter * -SearchBase $PragueOU -Properties emailaddress | select Name, emailaddress
$users

$TemplateFolder = "C:\Users\wojewodam!\Desktop\Printer"

$groupFile = Join-Path $TemplateFolder "group.xml"
$addressFile = Join-Path $TemplateFolder "address.xml"

[XML]$addressXml = Get-Content $addressFile
[XML]$groupXML = Get-Content $groupFile

$addressXML.VCards.InnerXml