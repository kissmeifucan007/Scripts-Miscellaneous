Get-ADOrganizationalUnit  -Filter {name -like "wawwrk1901"}

function get-ADObjectOU {
   Param(
       [Parameter(Mandatory)]
       [string]$Name,
       [Parameter()]
       [ValidateSet("Computer", "User", "Group")]
       [String]$ADObjectType="Computer"
       )
       switch ($ADObjectType){
           Computer { (Get-ADComputer $Name | select -ExpandProperty distinguishedname | % {$_ -split ","} | select -Skip 1 ) -join "," ; break} 
               User { (Get-ADUser $Name | select -ExpandProperty distinguishedname | % {$_ -split ","} | select -Skip 1 ) -join "," ; break} 
              Group { (Get-ADGroup $Name | select -ExpandProperty distinguishedname | % {$_ -split ","} | select -Skip 1 ) -join "," ; break} 
       }
    
}

get-ADObjectOU -Name "wojewodam!" -ADObjectType User


$objectType = "Computer"
$name = "wawwrk1901"
$codeString = "Get-AD$objectType $name"
Invoke-Expression $codeString