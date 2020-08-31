$basePath = "C:\CEE scripts\ZendeskImport\From Bart\"
$htmlFilePath = Join-Path $basePath "Guernsey Infrastructure Documentation.htm"
$NewImageUrlsFilePath = Join-Path $basePath "Images.html"
$Content = Get-Content $htmlFilePath
$imagePaths = Get-Content $NewImageUrlsFilePath
$processedFilePath = Join-Path $basePath "processed.html"

$removeTopRegex = "<html>.*<body.*?>"
$removeBottomRegex = "</body>.*</html>"

$currentImage = "image001"

$imageTargetPathRegex = "/hc/article_attachments/\d+/image\d\d\d.\w\w\w"
$imageContentPathRegex = '(?<=src=").*?/image\d\d\d.\w\w\w'
$Content -match $imageContentPathRegex


$Content = $Content -replace $removeTopRegex
$Content = $Content -replace $removeBottomRegex

$SourceMatches = Select-String $imageContentPathRegex -input $Content -AllMatches | Foreach {$_.matches} | select -ExpandProperty value
$TargetMatches = Select-String $imageTargetPathRegex  -input $imagePaths -AllMatches | Foreach {$_.matches} | select -ExpandProperty value

foreach ($match in $SourceMatches){
   $length = $match.Length -1
   $imageId  = $match.Substring($length-11,12)
   $imageIdRegex = "*" + $imageId 
   $tagToReplace = foreach ($targetMatch in $TargetMatches){
      if ($targetMatch -like "*$imageid"){
         $targetMatch
      }
   }
   $content = $Content.Replace($match,$tagToReplace)
}

$Content | Out-File $processedFilePath
start $processedFilePath