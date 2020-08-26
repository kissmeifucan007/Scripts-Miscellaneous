$canonCsv = import-csv '\\plwafs01\it$\IT_Scripts\MWD_Powershell\abook.csv' 
$properties = ($canonCsv[0]  | Select -First 1).PSObject.Properties | ?{$_.Value -ne $null} | select name

cls
$canonCsv[0]

function Remove-EmptyProperties {

  param(
    [parameter(Mandatory,ValueFromPipeline)]
    [psobject] $InputObject
  )

  process {
    # Create the initially empty output object
    $obj = [pscustomobject]::new()
    # Loop over all input-object properties.
    foreach($prop in $InputObject.psobject.properties) {
      # If a property is non-$null, add it to the output object.
      if ("" -ne $InputObject.$($prop.Name)) {
        Add-Member -InputObject $obj -NotePropertyName $prop.Name -NotePropertyValue $prop.Value
      }
    }
    # Give the output object a type name that reflects the type of the input
    # object prefixed with 'NonNull.' - note that this is purely informational, unless
    # you define a custom output format for this type name.
    $obj.pstypenames.Insert(0, 'NonNull.' + $InputObject.GetType().FullName)
    # Output the output object.
    $obj
  }

}

$canonCsfValues = foreach ($entry in $canonCsv){
$entry | Remove-EmptyProperties 
}

$exampleproperties = $canonCsv | Remove-EmptyProperties

$OU = "OU=Lublin,OU=Poland,OU=VCS,OU=Users,OU=CEE,OU=Vistra,DC=work,DC=local"

$lublinUsers = get-aduser -server work.local -Filter * -SearchBase $ou -Properties * | select name,EmailAddress,HomeDirectory

$lublinUsersToExport =@()
$i=0
foreach ($user in $lublinUsers){
   $CanonProperties = New-Object -TypeName PSObject -Property @{
      objectclass       = "remotefilesystem"
      cn                = $user.Name
      cnread            = $user.Name
      cnshort           = ""
      subdbid           = "1"
      mailaddress       = $user.EmailAddress
      dialdata          = ""
      uri               = ""
      url               = $user.HomeDirectory.Split("\")[2]
      path              = $user.HomeDirectory + "\!Scan"
      protocol          = "smb"
      username          = "WORK.local\ceesvcscn"
      pwd               = "PASSWORD"
      member            = ""
      indxid            = $i
      enablepartial     = ""
      sub               = ""
      faxprotocol       = ""
      ecm               = ""
      txstartspeed      = ""
      commode           = ""
      lineselect        = ""
      uricommode        = ""
      uriflag           = ""
      pwdinputflag      = "on"
      ifaxmode          = ""
      transsvcstr1      = ""
      transsvcstr2      = ""
      ifaxdirectmode    = ""
      documenttype      = ""
      bwpapersize       = ""
      bwcompressiontype = ""
      bwpixeltype       = ""
      bwbitsperpixel    = ""
      bwresolution      = ""
      clpapersize       = ""
      clcompressiontype = ""
      clpixeltype       = ""
      clbitsperpixel    = ""
      clresolution      = ""
      accesscode        = "0"
      uuid              = ""
      cnreadlang        = "en"
      enablesfp         = ""
      memberobjectuuid  = ""
      loginusername     = ""
      logindomainname   = ""
      usergroupname     = ""
      personalid        = ""
  }

   $i++
   $lublinUsersToExport += $CanonProperties
}

$lublinUsersToExport | Out-GridView
$lublinUsersToExport | select objectclass,cn,cnread,cnshort,subdbid,mailaddress,dialdata,uri,url,path,protocol,username,pwd,member,indxid,enablepartial,sub,faxprotocol,ecm,txstartspeed,commode,lineselect,uricommode,uriflag,pwdinputflag,ifaxmode,transsvcstr1,transsvcstr2,ifaxdirectmode,documenttype,bwpapersize,bwcompressiontype,bwpixeltype,bwbitsperpixel,bwresolution,clpapersize,clcompressiontype,clpixeltype,clbitsperpixel,clresolution,accesscode,uuid,cnreadlang,enablesfp,memberobjectuuid,loginusername,logindomainname,usergroupname,personalid |
 export-csv export3.csv -NoTypeInformation -Encoding UTF8 
Start  export3.csv

$header = @"
# Canon AddressBook CSV version: 0x0002
# CharSet: UTF-8
# dn: fixed
# DB Version: 0x010a

"@


Add-Content -Path export.csv -Value $header


 #