# Get login string. If no parameters (email and token) are entered, ask for values.
function New-ZendeskLogonString() {
    Param(
        # Zendesk support user email address
        [String]$email ="",
        # API token from Zendesk from https://ovgroup.zendesk.com/agent/admin/api/settings (+ to create new)
        [String]$token  =""
    )
    if (($email -eq "")-and ($token -eq "")){
        $Credentials = get-credential -Message "Enter Zendesk e-mail and API token as password"
    }
    else{
        $SecureToken = ConvertTo-SecureString -String $token -AsPlainText -Force
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $SecureToken
    }

    return $Credentials.GetNetworkCredential().UserName + "/token:" + $Credentials.GetNetworkCredential().password
}

function Get-ZendeskData {
    [cmdletbinding(
        DefaultParameterSetName = 'Unrelated'
    )]
    Param(
        [Parameter(
            ParameterSetName = 'Unrelated',
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Articles',
            Mandatory
        )]
        [Parameter(
            Position = 0
        )]
        [String]$Logon,

        [Parameter(
            ParameterSetName = 'Unrelated',
            Mandatory
        )]
        [Parameter(
            ParameterSetName = 'Articles'
        )]
        [Parameter(
            Position = 1
        )]
        [ValidateSet("articles", "labels", "categories", "sections", "users")]
        [string]$TableName,

        [Parameter(
            ParameterSetName = 'Articles',
            Mandatory
        )]
        [Parameter(
            Position = 2
        )]
        [ValidateSet("article attachments", "article comments")]
        [string]$RelatedTableName,

        [Parameter(
            ParameterSetName = 'Articles',
            Mandatory
        )]
        [Parameter(
            Position = 3
        )]
        [int64]$Id

    )
    $itemsPerPage = 100

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = New-WebRequestHeader -Logon $logon
    #https://ovgroup.zendesk.com/api/v2
    $urlBase = "https://ovgroup.zendesk.com/api/v2/"
    $helpCenterUrl = "help_center/"

    switch ($PSCmdlet.ParameterSetName) {
        Unrelated {
            Switch ($tableName) {
                Users { $url = $urlBase + "$tableName.json" ; Break }
                Labels { $url = $urlBase + $helpCenterUrl + "articles/" + "$tableName.json"; Break }
                Default { $url = $urlBase + $helpCenterUrl + "$tableName.json"; Break }
            }
        }
        Articles {
            Switch ($RelatedTableName) {
                'article attachments' { $url = $urlBase + $helpCenterUrl + "articles/" + $Id + "/attachments.json"; Break }
                'article comments' { $url = $urlBase + $helpCenterUrl + "articles/" + $Id + "/comments.json"; Break }
            }

        }
    }

    $url = $url.Replace(" ", "")
    $url += "?per_page=$itemsPerPage"

    $nextPage = $url
    $data = @()
    do {
        $page = Invoke-WebRequest -uri $nextPage -Headers $headers
        $json = $page.Content | ConvertFrom-Json
        try {
            $nextPage = $json.next_page
        }
        catch { }
        Switch ($PSCmdlet.ParameterSetName) {
            Unrelated { $data += $json | Select-Object -ExpandProperty $tableName; Break }
            Articles { $data += $json  ; Break }
        }
        $i++
    }while (($null -ne $nextPage) -and ($nextPage -ne ""))
    $data
}


function New-WebRequestHeader() {
    Param(
        [Parameter(Mandatory)]
        [String] $Logon
    )
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($logon)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $headers = @{ Authorization = $basicAuthValue }
    $headers
}

# This function works for Support part only
# Address for bss: https://vistrabss.zendesk.com/api/v2/ needs to be changed,
# Alternatively function parameter needs to be modified
function Get-Tickets {
    [cmdletbinding()]
    Param(
        [String]$Logon,
        [String]$Status
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = New-WebRequestHeader -Logon $logon

    $data = @()
    foreach ($status in $statuses) {
    $url = "https://ovgroup.zendesk.com/api/v2/search.json?query=type:ticket%20status:$status"
    $i=0
    $nextPage = $url

    do {
        $page = Invoke-WebRequest -uri $nextPage -Headers $headers
        $json = $page.Content | ConvertFrom-Json
        try {
            $nextPage = $json.next_page
        }
        catch { }
        $data += $json | Select-Object -ExpandProperty "results"
        $i++
    }while (($null -ne $nextPage) -and ($nextPage -ne ""))
}
    $data
}

function Get-Ticket {
    [cmdletbinding()]
    Param(
        [String]$Logon,
        [String]$id
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = New-WebRequestHeader -Logon $logon

    $data = @()
    $url = "https://ovgroup.zendesk.com/api/v2/tickets/$id.json"

   $page = Invoke-WebRequest -uri $url -Headers $headers
   $json = $page.Content | ConvertFrom-Json
   $data += $json | Select-Object -ExpandProperty "ticket"
   $data
}

function Get-Comments {
    [cmdletbinding()]
    Param(
        [String]$Logon,
        [String]$id
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = New-WebRequestHeader -Logon $logon

    $data = @()
    $url = "https://ovgroup.zendesk.com/api/v2/tickets/$id/comments.json"

   $page = Invoke-WebRequest -uri $url -Headers $headers
   $json = $page.Content | ConvertFrom-Json
   $data += $json | Select-Object -ExpandProperty "comments"
   $data
}

function Get-Attachments {
    [cmdletbinding()]
    Param(
        [String]$Logon,
        $Comment,
        [String]$ParentFolderPath
    )
    $attachmentFolderPath = Join-Path $ParentFolderPath "Attachments"
    If (-not (test-path $attachmentFolderPath)){
       New-Item -Path $attachmentFolderPath -ItemType Directory |out-null
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = New-WebRequestHeader -Logon $logon
    $i = 0
    foreach ($attachment in $comment.attachments) {
        $percentComplete = $i/$comment.attachments.count*100
     #   Write-Progress -PercentComplete $percentComplete -Activity "Saving attachments" -Status "$percentComplete Complete:"
        $url = $attachment.content_url
        $outputPath = Join-Path $ParentFolderPath ($comment.ticket_id+"."+$comment.id+"."+$attachment.id + "." +$attachment.file_name)
        Invoke-WebRequest -uri $url -Headers $headers -OutFile $outputPath
        $i++
    }
}

$logon = New-ZendeskLogonString


$ParentFolderPath = "C:\ZendeskGuideExport\TicketExport"

$tickets =  @()
$comments = @()
$i = 0
foreach ($id in $ticketIDs){
   $progress = $i/$ticketIDs.count *100
   Write-Progress -Activity Updating -Status 'Progress: $progress' -PercentComplete ($progress)
   $tickets+= Get-Ticket -Logon $logon -id $id
   $comments += get-comments -logon $logon -id $id | select *, @{n="Ticket_id";e={$id}}
   $i++
}
$ticketsFile = Join-Path $ParentFolderPath "tickets.json"
$commentsFile =  Join-Path $ParentFolderPath "comments.json"
$tickets | ConvertTo-Json | Out-File $ticketsFile
$comments | ConvertTo-Json | Out-File $commentsFile

$i = 0
foreach ($comment in $comments){
    $progress = $i/$comments.count *100
    Write-Progress -Activity Updating -Status "Progress: $progress" -PercentComplete ($progress)
    Get-Attachments -Logon $Logon -Comment $comment -parentFolderPath $ParentFolderPath
    $i++
}

$HelpCenterTabels = @("articles", "labels", "categories", "sections", "users")

# Export table contents to CSV files
foreach ($table in $HelpCenterTabels) {
    try {
        if (Get-Variable $table){
           Remove-Variable -Name $table
        }
    }
    catch{}

    New-Variable -Name $table -Value  (Get-ZendeskData -Logon $logon -TableName $table)
    Get-Variable -Name $table  |
       Select-Object -ExpandProperty Value |
       Export-Csv -Path (Join-Path -Path $ParentFolderPath -ChildPath "$table.csv") -Encoding utf8 -Delimiter ";" -Force
}

$users = Get-ZendeskData -logon $logon -tableName "users"
$users | ConvertTo-Json  | out-file 'users.json'

# Export commentand attachment info to CSV files
Remove-item -path (Join-Path $ParentFolderPath "attachments.csv")
Remove-item -path (Join-Path $ParentFolderPath "comments.csv")
foreach ($article in $articles) {
    $comments = Get-ZendeskData -Logon $logon -TableName Articles -RelatedTableName "Article Comments" -Id $article.id |
        Select-Object -ExpandProperty "comments"
    $comments | Export-Csv -Path (Join-Path -Path $ParentFolderPath -ChildPath "comments.csv") -Encoding utf8 -Delimiter ";" -Append

    $attachments = Get-ZendeskData -Logon $logon -TableName Articles -RelatedTableName "Article Attachments" -Id $article.id |
          Select-Object -ExpandProperty "article_attachments"
    $attachments | Export-Csv -Path (Join-Path -Path $ParentFolderPath -ChildPath "attachments.csv") -Encoding utf8 -Delimiter ";" -Append
}

#Export attachment files
#Takes more than 20 min. Includes progress bar
$headers = New-WebRequestHeader -Logon $logon
$i = 0
foreach ($attachment in $attachments) {
    $percentComplete = $i/$attachments.count*100
    Write-Progress -PercentComplete $percentComplete -Activity "Saving attachments" -Status "$percentComplete Complete:"
    $url = $attachment.content_url
    $outputPath = Join-Path $ParentFolderPath $attachment.article_id
    $outputPath = Join-Path $outputPath $attachment.id
    New-Item -Path $outputPath -ItemType Directory
    $outputPath = Join-Path $outputPath $attachment.file_name
    Invoke-WebRequest -uri $url -Headers $headers -OutFile $outputPath
    $i++
}

get-childitem $ParentFolderPath -Filter *.json | %{
  get-content $_ | ConvertFrom-Json | Export-Excel -Path (join-path $parentFolderPath ($_.Basename+".xlsx")) -noNumberConversion *
}
