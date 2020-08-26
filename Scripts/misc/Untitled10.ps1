$Request = Invoke-WebRequest -Uri  "https://www.pracuj.pl/praca/it%20-%20administracja;cc,5015?rd=30" 
$content = $Request.Content

$regex ='(?ms).*?<div class="primary-title-and-description">.*?<h1>(.+?)</h1>.+'

$text -match $regex > $null
$matches[1].trim()

function Get-MarkupTag {
           
    #.Synopsis
    #   Extracts out a markup language (HTML or XML) tag from within a document
    #.Description
    #   Extracts out a markup language (HTML or XML) tag from within a document.
    #   Returns the tag, the text within the tag, and, if possible, the tag converted
    #   to XML
    #.Parameter tag 
    #   The tag to extract, e.g. "a", "div"
    #.Parameter html
    #   The text to extract the tag from
    #.Example
    #   # Download the Microsoft front page and extract out links and div tags
    #   $microsoft = (New-Object Net.Webclient).DownloadString("http://www.microsoft.com/")
    #   "a", "div" | Get-MarkupTag -html $microsoft
    #.Example
    #   # Extract the rows from ConvertTo-HTML
    #   $text = Get-ChildItem | Select Name, LastWriteTime | ConvertTo-HTML | Out-String 
    #   Get-MarkupTag "tr" $text
    param(
        [Parameter(ValueFromPipeline=$true,Position=0)]$tag,
        [Parameter(Position=1)][string]$html)
begin {
    
        $replacements = @{
            "<BR>" = "<BR />"
            "<HR>" = "<HR />"
            "&nbsp;" = " "
            '&macr;'='¯'
            '&ETH;'='Ð'
            '&para;'='¶'
            '&yen;'='¥'
            '&ordm;'='º'
            '&sup1;'='¹'
            '&ordf;'='ª'
            '&shy;'='­'
            '&sup2;'='²'
            '&Ccedil;'='Ç'
            '&Icirc;'='Î'
            '&curren;'='¤'
            '&frac12;'='½'
            '&sect;'='§'
            '&Acirc;'='â'
            '&Ucirc;'='Û'
            '&plusmn;'='±'
            '&reg;'='®'
            '&acute;'='´'
            '&Otilde;'='Õ'
            '&brvbar;'='¦'
            '&pound;'='£'
            '&Iacute;'='Í'
            '&middot;'='·'
            '&Ocirc;'='Ô'
            '&frac14;'='¼'
            '&uml;'='¨'
            '&Oacute;'='Ó'
            '&deg;'='°'
            '&Yacute;'='Ý'
            '&Agrave;'='À'
            '&Ouml;'='Ö'
            '&quot;'='"'
            '&Atilde;'='Ã'
            '&THORN;'='Þ'
            '&frac34;'='¾'
            '&iquest;'='¿'
            '&times;'='×'
            '&Oslash;'='Ø'
            '&divide;'='÷'
            '&iexcl;'='¡'
            '&sup3;'='³'
            '&Iuml;'='Ï'
            '&cent;'='¢'
            '&copy;'='©'
            '&Auml;'='Ä'
            '&Ograve;'='Ò'
            '&Aring;'='Å'
            '&Egrave;'='È'
            '&Uuml;'='Ü'
            '&Aacute;'='Á'
            '&Igrave;'='Ì'
            '&Ntilde;'='Ñ'
            '&Ecirc;'='Ê'
            '&cedil;'='¸'
            '&Ugrave;'='Ù'
            '&szlig;'='ß'
            '&raquo;'='»'
            '&euml;'='ë'
            '&Eacute;'='É'
            '&micro;'='µ'
            '&not;'='¬'
            '&Uacute;'='Ú'
            '&AElig;'='Æ'
            '&euro;'= "€"        
        }
    
}
process {

        foreach ($r in $replacements.GetEnumerator()) {
            $l = 0 
            do {
                $l = $html.IndexOf($r.Key, $l, [StringComparison]"CurrentCultureIgnoreCase")
                if ($l -ne -1) {
                    $html = $html.Remove($l, $r.Key.Length)
                    $html = $html.Insert($l, $r.Value)
                }
            } while ($l -ne -1)         
        }
     
        $r = New-Object Text.RegularExpressions.Regex ('</' + $tag + '>'), ("Singleline", "IgnoreCase")
        $endTags = @($r.Matches($html))
        $r = New-Object Text.RegularExpressions.Regex ('<' + $tag + '[^>]*>'), ("Singleline", "IgnoreCase")
        $startTags = @($r.Matches($html))
        $tagText = @()
        if ($startTags.Count -eq $endTags.Count) {
            $allTags = $startTags + $endTags | Sort-Object Index   
            $startTags = New-Object Collections.Stack
            foreach($t in $allTags) {
                if (-not $t) { continue } 
                if ($t.Value -like "<$tag*") {
                    $startTags.Push($t)
                } else {
                    $start = $startTags.Pop()
                    $tagText+=($html.Substring($start.Index, $t.Index + $t.Length - $start.Index))
                }
            }
        } else {
            # Unbalanced document, use start tags only and make sure that the tag is self-enclosed
            $startTags | Foreach-Object {
                $t = "$($_.Value)"
                if ($t -notlike "*/>") {
                    $t = $t.Insert($t.Length - 1, "/")
                }
                $tagText+=$t
            } 
        }
        foreach ($t in $tagText) {
            if (-not $t) {continue }
            # Correct HTML which doesn't quote the attributes so it can be coerced into XML
            $inTag = $false
            for ($i = 0; $i -lt $t.Length; $i++) {
                if ($t[$i] -eq "<") {
                    $inTag = $true
                } else {
                    if ($t[$i] -eq ">") {
                        $inTag = $false
                    }
                }
                if ($inTag -and ($t[$i] -eq "=")) {
                    if ($t[$i + 1] -notmatch '[''|"]') {
                        $endQuoteSpot = $t.IndexOfAny(" >", $i + 1)
                        # Find the end of the attribute, then quote
                        $t = $t.Insert($i + 1, "'")
                        $t = $t.Insert($endQuoteSpot + 1, "'")                    
                        $i = $endQuoteSpot
                    } else {
                        # Make sure the quotes are correctly formatted, otherwise,
                        # end the quotes manually
                        $whichQuote = "$($Matches.Values)"
                        $endQuoteSpot = $t.IndexOf($whichQuote, $i + 2)
                        $i = $endQuoteSpot
                    }
                }
            }        
            $t | Select-Object @{
                Name='Tag'
                Expression={$_}
            }, @{
                Name='Xml'
                Expression= {
                    ([xml]$t).$tag      
                    trap {
                        Write-Verbose ($_ | Out-String) 
                        continue
                    }
                }
            }    
        }
    
}

}

$scripts = Get-MarkupTag -html $content -tag "script" 

$replace = @"
<script>
        window.__INITIAL_STATE__ = 
"@
$split = "var __RAWURL"
$json = ($scripts[6] -replace $replace -split $split)[0] 
cls
$json | ConvertFrom-Json