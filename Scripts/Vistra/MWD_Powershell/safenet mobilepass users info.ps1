## for the safenet mobilepass to work you have to add users to group "Security - Global Citrix Token Users"



##import user list
$list = get-aduser -SearchBase "OU=Users,OU=Geneva,OU=Vistra,DC=work,DC=local" -Filter * | Select -ExpandProperty name
##or manual list
$prelist = @"
Marlene.Summermatter@vistra.com
nicole.kourouma@vistra.com
Alexandra.Gurosheva@vistra.com
olga.tuymantseva@vistra.com
Fabrizio.Patane@vistra.com
Lucia.Povodova@vistra.com
Christophe.Couture@vistra.com
Laurent.Ponti@vistra.com
Altheatest.Andriotto@vistra.com
Julie.Meesemaecker@vistra.com
Sophie.Lacroix-Metraz@vistra.com
Olga.Tejerina@vistra.com
Eliza.Mathon-Ibrahimaj@vistra.com
pierre.grandjean@vistra.com
Walter.Stresemann@vistra.com
Alain.Mauris@vistra.com
Francine.Kouame@vistra.com
Stephane.Hauguel@vistra.com
Florence.Triat@vistra.com
Noemie.Wetzel@vistra.com
"@
$list = $prelist.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)


#info about user
$result = @()
foreach ($user in $list){
$all = get-aduser -filter {(displayname -eq $user) -or (SamAccountName -eq $user) -or (userprincipalname -eq $user)} -properties StreetAddress, OfficePhone,physicalDeliveryOfficeName, co | select givenname, surname, SamAccountName, UserPrincipalName, StreetAddress, physicalDeliveryOfficeName, co, OfficePhone
$info = [pscustomobject]@{
user = $user
name = $all.givenname
surname = $all.surname
SamAccountName = $all.SamAccountName
UserPrincipalName = $all.UserPrincipalName 
#StreetAddress = $all.StreetAddress
physicalDeliveryOfficeName =$all.physicalDeliveryOfficeName
co = $alll.co
OfficePhone = $all.OfficePhone 
}
$result += $info
}

$exportCSVSplat = @{
   Delimiter = ';'
   Encoding = "UTF8"
   NotypeInformation = $true
   Path = "C:\tmp\zrhusers.csv"
   Force = $true
}
$result | Export-Csv @exportCSVSplat
start $exportCSVSplat.Path

#add users to a citrix group
foreach ($user in $result){
$a = $user.SamAccountName
Add-ADGroupMember -Identity "Security - Global Citrix Token Users" -Members $a
}