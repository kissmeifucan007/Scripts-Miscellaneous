$ArticlesUrl = "https://itsupport.vistra.com/api/v2/help_center/articles.json?page=1&per_page=100"
$UsersUrl    = "https://ovgroup.zendesk.com/api/v2/users.json"
$logon = "michal.wojewoda@vistra.com/token:oxwPpUWJ2JiO6KVJ4Wl5Du2AzDSR9xvEE9a4KaZW"
function makeWebRequestHeader($logon){
$bytes = [System.Text.Encoding]::ASCII.GetBytes($logon)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue}
$headers
}
function get-zendeskData($myurl,$myheaders){
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$page = Invoke-WebRequest -uri $myurl -Headers $myheaders

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
$data
}

$headers = makeWebRequestHeader($logon)
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