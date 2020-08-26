$ArticlesUrl = "https://itsupport.vistra.com/api/v2/help_center/articles.json?page=1&per_page=100"
$UsersUrl    = "https://itsupport.vistra.com/api/v2/users.json?page=1&per_page=100"
$logon = "michal.wojewoda@vistra.com/token:oxwPpUWJ2JiO6KVJ4Wl5Du2AzDSR9xvEE9a4KaZW"
function makeWebRequestHeader($logon){
$bytes = [System.Text.Encoding]::ASCII.GetBytes($logon)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue}
$headers
}
$headers = makeWebRequestHeader($logon)
function Get-ZendeskData{
   Param(
       [parameter(Mandatory=$true)]
       [hashtable]$headers,
       [parameter(Mandatory=$true)]
       [string]$url
   ) 
   $itemsPerPage = 100 
   $page = Invoke-WebRequest -uri $UsersUrl -Headers $headers
   $json = $page.Content | ConvertFrom-Json
   $totalPages = [math]::ceiling($json.count/$itemsPerPage)
   $data = @()
   $nextPage = $json.next_page
   $i = 0
   while (($nextPage -ne $null) -and ($nextPage -ne "")){
      $pComplete = [int](($i/$totalPages)*100)
      Write-Progress -Activity "Reading json content page by page" -Status "$pComplete% Complete:" -PercentComplete $pComplete;
      $data += $json.users
      $page = Invoke-WebRequest -uri $nextPage -Headers $headers
      $json = $page.Content | ConvertFrom-Json
      $nextPage = $json.next_page
   }
   $data
}

$users = get-zendeskData -headers $headers -url $UsersUrl

$CsvExportParams = @{
   path = "users.csv"
   encoding = "UTF8"
   noTypeInformation = $true
   delimiter = ";"
} 
$users | select -Skip 118 | Export-Csv @CsvExportParams
#   $fileName = "important.csv"
#   $importantOnly = $articles | select id,html_url,draft,author_id,section_id,created_at,updated_at,edited_at,name,@{ Name = 'Labels';  Expression = {
#      $string = foreach ($label in $_.label_names){
#      "$label, "
#      }
#   $string
#   }}
#}

$data | Out-GridView


$articles = get-zendeskData($ArticlesUrl,$headers)
$users = get-zendeskData($UsersUrl,$headers)
$users | out-gridview
$articles[3]
$importantOnly |export-csv -Path $fileName -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Force
start $fileName

$articles[10].body |out-file body.html
start body.html

$path = "https://itsupport.vistra.com/api/v2/help_center/article_attachments.json"
$page = Invoke-WebRequest -uri $path -Headers $headers
$json = $page.links | ConvertFrom-Json
$json


$dataSources = @"
categories
#sections
articles

"@


$page = Invoke-WebRequest -uri $UsersUrl -Headers $headers

$json = $page.Content | ConvertFrom-Json
$data = @()
do{
   $nextPage = $json.next_page
   $data += $json.articles
   $page = Invoke-WebRequest -uri $nextPage -Headers $myheaders
   $json = $page.Content | ConvertFrom-Json
}while (($nextPage -ne $null) -and ($nextPage -ne ""))
$fileName = "important.csv"
$importantOnly = $articles | select id,html_url,draft,author_id,section_id,created_at,updated_at,edited_at,name,@{ Name = 'Labels';  Expression = {
   $string = foreach ($label in $_.label_names){
   "$label, "
   }
$string
}}
$data | Out-GridView

$data | export-csv -Delimiter ";" -Encoding UTF8 -Path $users.csv
[math]::Round(120/100)
[math]::ceiling(120/100)

