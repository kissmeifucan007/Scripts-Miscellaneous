# https://ovgroup.zendesk.com/knowledge/lists/default/1/1?brand_id=44152

$url = "https://itsupport.vistra.com/api/v2/help_center/articles.json?page=1&per_page=100"

$logon = "michal.wojewoda@vistra.com/token: xxx"

$bytes = [System.Text.Encoding]::ASCII.GetBytes($logon)
$base64 = [System.Convert]::ToBase64String($bytes)

$basicAuthValue = "Basic $base64"

$headers = @{ Authorization = $basicAuthValue}

#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$page = Invoke-WebRequest -uri $url -Headers $headers

$json = $page.Content | ConvertFrom-Json
$articles = @()
do{
   $nextPage = $json.next_page
   $articles += $json.articles
   $page = Invoke-WebRequest -uri $nextPage -Headers $headers
   $json = $page.Content | ConvertFrom-Json
}while ($nextPage -ne $null)
$articles | Out-GridView
$fileName = "important.csv"
$importantOnly = $articles | select id,html_url,draft,author_id,section_id,created_at,updated_at,edited_at,name,@{ Name = 'Labels';  Expression = {
   $string = foreach ($label in $_.label_names){
   "$label, "
   }
$string
}}
$importantOnly |export-csv -Path $fileName -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Force
start $fileName

$articles[3].label_names
