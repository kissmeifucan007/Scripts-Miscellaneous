$users = get-content .\users.json | ConvertFrom-Json

$parentFolder = 'C:\ZendeskGuideExport\TicketExport'


$i = 1
$articlesForImport = $articles #| select -First 25
$importData = foreach ($article in $articlesForImport){
    $percentComplete = ($i-1)/$articlesForImport.count*100
    Write-Progress -PercentComplete $percentComplete -Activity "Saving attachments" -Status "$percentComplete Complete:"
   $i++
   $topic = $sections | Where-Object {$_.id -eq $article.section_id} | select -expandProperty Name
   $author = $users  | select -expandProperty email | Where-Object {$_.id -eq $article.author_id}
   $labels = $article.label_names -join ","
   $time = Get-Date -Date ($article.created_at -replace "T"," " -replace "Z", "")
   [pscustomobject]@{
      'SolutionId' = $i
      'Subject' = $article.title
      'Topic Name' = $topic
      'Contents' = $article.body
      'Created On' = $time
      'Created by' = "mwojewoda@sii.pl"
      'Status' = 'Approved'
      'Public' = 'TRUE'
      'Keywords' = $labels
      'Last updated on' = $article.updated_at
      'No of Hits' = 0
   }
}

$importData | Export-Excel "07BSSExport.xlsx" -NoNumberConversion *
$importData | select -First 30 | Export-Excel "07Exportv1.xlsx" -NoNumberConversion * 
$attachments = import-csv .\attachments.csv -Delimiter ";"

$importFromSDPlus = Import-Excel .\SolutionsSDP.xlsx

$newPath = 'C:\ZendeskGuideExport\For Import'
$files = Get-ChildItem $newPath
$ZipFolder = 'C:\ZendeskGuideExport\Zip'
#New-Item $ZipFolder -ItemType Directory
$export = foreach ($article in $articlesForImport){
   $id = $importFromSDPlus | Where-Object {$_.subject -eq $article.name} | select -First 1 | select -ExpandProperty 'Solution ID' 
   $id =  $id.ToString()
   $filter = $article.id.ToString() + "*"
   $files = get-childItem $newPath -Filter $filter
   foreach ($file in $files){ 
        $attachmentId = $file.Name.Split('.')[1] 
        #Copy $file.FullName $ZipFolder -Force
        [pscustomobject]@{
               'Attachment Module' = 'Solutions'
               'Parent Id' = $id
               'Attachment Id' = $attachmentId.ToString()
               'File Name' = $file
               'File Size' = ''
         }
   }
}
Compress-Archive -Path (Get-ChildItem $newPath | select -ExpandProperty fullName)  -DestinationPath 'C:\ZendeskGuideExport\zip.zip' -Force
$exportAttachmentPath = 'ExportAttachment.csv'
$export | Export-Excel ExportAttachments.xlsx -NoNumberConversion *
$export | export-csv -Path $exportAttachmentPath -NoTypeInformation -Encoding UTF8 -Force -Delimiter ',' 
$content = get-content $exportAttachmentPath
$content = $content.Replace('"','')
$content | Out-File $exportAttachmentPath -Force
start ExportAttachments.xlsx


$attachmentExcelPath = 'C:\ZendeskGuideExport\Attachments_1.xlsx' 
$sdpAttachments = Import-Excel $attachmentExcelPath  

$attachmentURLBase = "/app/vistraclientsupport/api/v3/solutions/"

foreach ($article in $articlesForImport){
   $article.body = $article.body.Replace('Â ','')
   $regex = '(?<=img src=")(.*?)(?=")'
   $urls = $article.body | Select-String $regex -AllMatches | % {$_.matches.value} 
   foreach ($url in $urls){
       $attachment = $sdpAttachments |? {$_.'ServiceDesk Plus Module' -eq "Solutions"} |? {$_.'File Name'.split('./')[-3] -eq $url.Split("/")[-2]}
       $newUrl = $attachmentURLBase + $attachment.'Parent ID' + "_/uploads/" +  $attachment.'File Name'.split('/')[1] 
       $article.body = $article.body.Replace($url,$newUrl) 
   }
}
  
$string = "Was there a bypass set for bilnet address?<a href=`"https://itsupport.vistra.com/agent/tickets/344535`">https://ovgroup.zendesk.com/agent/tickets/344535</a>"
$string.Replace('(?<=.*href")(https://itsupport.vistra.com/.*)',"")
$string.Replace('.*https://itsupport.vistra.com/.*"','')

$imageTargetPathRegex = "/hc/article_attachments/\d+/image\d\d\d.\w\w\w"
$imageContentPathRegex = '(?<=href").*?/image\d\d\d.\w\w\w'
$Content -match $imageContentPathRegex



$regex = '(?<=img src=")(.*?)(?=")'

$i=1000
$importData = foreach ($article in $articlesForImport){
   $i++
   $topic = $sections | Where-Object {$_.id -eq $article.section_id} | select -expandProperty Name
   $author = $users  | select -expandProperty email | Where-Object {$_.id -eq $article.author_id}
   $labels = $article.label_names -join ","
   $time = Get-Date -Date ($article.created_at -replace "T"," " -replace "Z", "")
   [pscustomobject]@{
      'SolutionId' = $i
      'Subject' = $article.title
      'Topic Name' = $topic
      'Contents' = $article.body
      'Created On' = $time
      'Created by' = "mwojewoda@sii.pl"
      'Status' = 'Approved'
      'Public' = 'TRUE'
      'Keywords' = $labels
      'Last updated on' = $article.updated_at
      'No of Hits' = 0
   }
}

 

