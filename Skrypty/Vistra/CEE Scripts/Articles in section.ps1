$creators = @(362944984318,362303084058)
$ArticlesUrl = "https://itsupport.vistra.com/api/v2/help_center/articles.json"
$Filter = "&section_id=201595111"
#$Filter = "&author_id=362944984318,362303084058" 
$itemsPerPage = 100
$ArticlesPerPage = "?page=1&per_page=$itemsPerPage"

$FullArticleUrl = $ArticlesUrl + $ArticlesPerPage + $Filter 
$logon = "michal.wojewoda@vistra.com/token:oxwPpUWJ2JiO6KVJ4Wl5Du2AzDSR9xvEE9a4KaZW"

function New-WebRequestHeader($logon){
$bytes = [System.Text.Encoding]::ASCII.GetBytes($logon)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue}
$headers
}

$headers = New-WebRequestHeader($logon)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Get-ZendeskData{
   Param(
       [parameter(Mandatory=$true)]
       [hashtable]$headers,
       [parameter(Mandatory=$true)]
       [string]$url,
       [int]$itemsPerPage = 100
   ) 
   $itemsPerPage = 100 
   $page = Invoke-WebRequest -uri $url -Headers $headers
   $json = $page.Content | ConvertFrom-Json
   $totalPages = [math]::ceiling($json.count/$itemsPerPage)
   $data = @()
   $nextPage = $json.next_page
   $i = 0
   while (($nextPage -ne $null) -and ($nextPage -ne "")){
      $pComplete = [int](($i/$totalPages)*100)
      Write-Progress -Activity "Reading json content page by page" -Status "$pComplete% Complete:" -PercentComplete $pComplete;
      $data += $json.articles
      $page = Invoke-WebRequest -uri $nextPage -Headers $headers
      $nextPage = $json.next_page
      $json = $page.Content | ConvertFrom-Json
   }
   $data
}


function ArticlesToHtml {
    Param(
       [parameter(Mandatory=$true)]
       $articles,
      [parameter(Mandatory=$true)]
       [string]$path
       )
       $CsvExportParams = @{
                           path = "C:\CEE scripts\ZendeskImport\articles.csv"
                           encoding = "UTF8"
                           noTypeInformation = $true
                           delimiter = ";"
                           } 

   
   $text = $articles | foreach {"<h1>"+$_.title+"</h1> <br> <a href=`""+$_.html_url + "`">link</a><br><h3> ID: "+$_.id+"</h3>Created at: "+$_.created_at+"<br><br>"+$_.body}  
   $text | Out-File -FilePath $path -Force
   start $path
}

$articles = Get-ZendeskData -headers $headers -url $FullArticleUrl | select * -Unique
$authors = $articles | foreach {$_.author_id} | group | select Name,Count | sort -Property Count -Descending
$ourArticles = $articles | ? {$_.section_id -eq 201595111}
$ourArticles.count

$vistraGroupArticles = $articles | ? {$_.section_id -eq 201595111} | select * -Unique
$vistraGroupArticles.count

$ourArticles


$excelPath = "C:\CEE scripts\ZendeskImport\KB Update.xlsx"
$ourArticles |select title,created_at,updated_at,@{n="labels"; e={$_.label_names -join ","}},html_url| Export-Excel -Path $excelPath
start $excelPath
$ourArticles[0].label_names

$path = "C:\CEE scripts\ZendeskImport\vistra group.html"

ArticlesToHtml -articles $ourArticles -path $path 
start $path








##$data | Out-GridView
##
##
##$articles = get-zendeskData($ArticlesUrl,$headers)
##$users = get-zendeskData($UsersUrl,$headers)
##$users | out-gridview
##$articles[3]
##$importantOnly |export-csv -Path $fileName -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Force
##start $fileName
##
##$articles[10].body |out-file body.html
##start body.html
##
##$path = "https://itsupport.vistra.com/api/v2/help_center/article_attachments.json"
##$page = Invoke-WebRequest -uri $path -Headers $headers
##$json = $page.links | ConvertFrom-Json
##$json
##
##
##$dataSources = @"
##categories
###sections
##articles
##
##"@
##
##
##$page = Invoke-WebRequest -uri $UsersUrl -Headers $headers
##
##$json = $page.Content | ConvertFrom-Json
##$data = @()
##do{
##   $nextPage = $json.next_page
##   $data += $json.articles
##   $page = Invoke-WebRequest -uri $nextPage -Headers $myheaders
##   $json = $page.Content | ConvertFrom-Json
##}while (($nextPage -ne $null) -and ($nextPage -ne ""))
##$fileName = "important.csv"
##$importantOnly = $articles | select id,html_url,draft,author_id,section_id,created_at,updated_at,edited_at,name,@{ Name = 'Labels';  Expression = {
##   $string = foreach ($label in $_.label_names){
##   "$label, "
##   }
##$string
##}}
##$data | Out-GridView
##
##$data | export-csv -Delimiter ";" -Encoding UTF8 -Path $users.csv
##[math]::Round(120/100)
##[math]::ceiling(120/100)
##
##