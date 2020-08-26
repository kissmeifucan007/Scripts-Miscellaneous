$userName = Read-Host "Enter user's name"
$userName = "*$userName*"


$myProperties = @"
badPasswordTime                     
badPwdCount                         
c                                   
CanonicalName                       
City                                
CN                                  
co                                  
Company                             
CompoundIdentitySupported           
Contains                            
Country                             
Created                             
Department                          
Description                         
DisplayName                         
DistinguishedName                   
EmailAddress                        
Enabled                             
Equals                              
facsimileTelephoneNumber            
Fax                                 
GetEnumerator                       
GetHashCode                         
GetType                             
HomeDirectory                       
HomeDrive                           
HomePage                            
HomePhone                           
Initials                            
Item                                
l                                   
lastLogoff                          
lastLogon                           
LockedOut                           
logonCount                          
mail                                
Manager                             
MemberOf                            
MobilePhone                         
Name                                
Office                              
OfficePhone                         
Organization                        
PasswordExpired                     
PasswordNeverExpires                
PostalCode                          
ProfilePath                         
pwdLastSet                          
ScriptPath                          
sDRightsEffective                   
ServicePrincipalNames               
SID                                 
SmartcardLogonRequired              
st                                  
State                               
StreetAddress                       
telephoneNumber                     
Title                               
ToString                            
whenChanged                         
whenCreated                         
wWWHomePage                         
"@

$propertyList
foreach ($property in $myProperties){
   $propertyList+=$property
} 

$users = Get-ADUser -filter {name -like $userName} -Properties $propertyList