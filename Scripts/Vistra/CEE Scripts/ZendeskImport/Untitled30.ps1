get-aduser wojewodam -properties * | get-member | where{$_.membertype -eq "Property"} | select name

get-aduser wojewodam -Properties * | out-gridview


$usefulProperties =@"                                  
c                                                                                             
City                                                                                                    
co                                                                                                
Company                                                                      
Country                                                                                         
Department                                           
Description                                          
DisplayName                                                                             
Division                                             
DoesNotRequirePreAuth                                
dSCorePropagationData                                
EmailAddress                                                                                                                        
Enabled                                              
facsimileTelephoneNumber                             
Fax                                                  
GivenName                                            
HomeDirectory                                        
HomedirRequired                                      
HomeDrive                                            
HomePage                                                                                         
Initials                                                                                                                    
l
mail                                                                                                                                                                                                                                                                                                         
MobilePhone                                          
Modified                                             
modifyTimeStamp                                                                            
Name                                                                                         
Office                                               
OfficePhone                                                                        
PostalCode                                           
PrimaryGroup                                         
primaryGroupID                                       
PrincipalsAllowedToDelegateToAccount                 
ProfilePath                                          
ProtectedFromAccidentalDeletion                      
proxyAddresses                                       
pwdLastSet                                           
SamAccountName                                       
ScriptPath                                                                        
sn                                                   
st                                                   
State                                                
StreetAddress                                        
Surname                                                                                      
telephoneNumber                                                                       
Title                                                                                                                         
UserPrincipalName                                                                            
wWWHomePage
"@