# (C) 2012 Dr. Tobias Weltner, MVP PowerShell
# www.powertheshell.com
# you can freely use and distribute this code
# we only ask you to keep this comment including copyright and url
# as a sign of respect.



<#
.SYNOPSIS
Saves output to PDF
.DESCRIPTION
Accepts pipeline input and writes data to a multi-page PDF file.
Creation of PDF documents does not require any additional software. The command uses the open-source pdfsharp library.
Opening of PDF documents generated by this command does require an external PDF reader application.
.PARAMETER Path
Path to PDF file
.PARAMETER FontName
Font to use. Any valid and installed Windows truetype font can be specified. Default is "Consolas"
.PARAMETER FontSize
Size of font. Default is 10.
.PARAMETER Decoration
Regular, Italics, Bold
.PARAMETER Indent
Space between page and content. Default is 10.
.PARAMETER Open
When specified, the PDF file will be opened automatically after it is generated. This requires a PDF reader application to be installed.
.PARAMETER PassThru

.PARAMETER HideTableHeaders
Data will be displayed without table headers
.PARAMETER Wrap
When specified, long lines will be wrapped to prevent truncation
.PARAMETER Width
Number of characters per line
.PARAMETER MaxAutosizeWidth
Maximum width of document in characters. This is used in conjunction with -AutoSize to determine the best width to display the entire content without truncation.
.PARAMETER Property
Properties to display
.PARAMETER GroupBy
Name of property to use in grouping
.PARAMETER AutoSize
When specified, document width is determined automatically to show all content without truncation. Automatic width cannot be larger than -MaxAutoSizeWidth.
.PARAMETER Encoding
Encoding to use. Default is Unicode.
.PARAMETER IncludeHeader
Each line is decorated with a header line which can include the page number
.PARAMETER HeaderText
Text to use as header when -IncludeHeader is specified. 
Default is '- Page {0} -' Use {0} to insert page number.
.EXAMPLE
Get-Process | Out-PTSPDF -Path $env:temp\report.pdf -Open
Sends process list to $env:temp\report.pdf and opens the PDF file after it is generated.
This requires a PDF reader application to be installed.
The PDF uses the console width and layout.
.EXAMPLE
Get-Process | Out-PTSPDF -Path $env:temp\report.pdf -Open -Width 120
Sends process list to $env:temp\report.pdf and opens the PDF file after it is generated.
This requires a PDF reader application to be installed.
The PDF has a line width of 120 characters
.EXAMPLE
Get-Process | Out-PTSPDF -Path $env:temp\report.pdf -Open -AutoSize
Sends process list to $env:temp\report.pdf and opens the PDF file after it is generated.
This requires a PDF reader application to be installed.
The PDF uses automatic width to display entire content. The default maximum width is 10000 characters.
.EXAMPLE
Get-Process | Out-PTSPDF -Path $env:temp\report.pdf -Open -AutoSize -FontName 'Times New Roman' -FontSize 8
Sends process list to $env:temp\report.pdf and opens the PDF file after it is generated.
This requires a PDF reader application to be installed.
The PDF uses automatic width to display entire content. The default maximum width is 10000 characters.
The PDF uses serif font "Times New Roman" with size 8.
Note that the use of non-fixed-width fonts causes misalignment of columns
.EXAMPLE
Get-Service | Sort-Object Status, Name | Out-PTSPDF -Path $env:temp\report.pdf -Open -AutoSize -Property Name, DisplayName, ServiceType -GroupBy Status -FontSize 7
Sends list of services to $env:temp\report.pdf and opens the PDF file after it is generated.
This requires a PDF reader application to be installed.
Displays the columns selected by -Property and groups results by property "Status"
.EXAMPLE
Get-WmiObject -Class win32_service | Sort-Object StartMode, DisplayName | Out-PTSPDF -Path $env:temp\report.pdf -Open -AutoSize -Property DisplayName, State, ExitCode, PathName -GroupBy StartMode -FontSize 6 -IncludeHeader -HeaderText 'List of Services - Page {0}' 
Sends list of services to $env:temp\report.pdf and opens the PDF file after it is generated.
This requires a PDF reader application to be installed.
Displays the columns selected by -Property and groups results by property "StartMode"
Displays a header text on each page including the page number
#>

Function Out-PTSPDF
{
  [CmdletBinding()]

  param
  (
    [Parameter(Mandatory=$true, Position=0)]
    [String]
    $Path,

    [String]
    $FontName = 'Consolas',

    [Byte]
    $FontSize = 10,

    [String]
    $Decoration = 'Regular',

    [Int]
    $Indent = 10,

    [Switch]
    $Open,

    [Switch]
    $PassThru,

    [switch]
    ${HideTableHeaders},

    [switch]
    ${Wrap},

    [Int]
    $Width = 100,

    [Int]
    $MaxAutoSizeWidth = 1000,

    [Parameter(Position=1)]
    [System.Object[]]
    ${Property},

    [System.Object]
    ${GroupBy},

    [string]
    ${View},

    [switch]
    ${ShowError},

    [switch]
    ${DisplayError},

    [switch]
    ${Force},

    [ValidateSet('CoreOnly','EnumOnly','Both')]
    [string]
    ${Expand},

    [Parameter(ValueFromPipeline=$true)]
    [psobject]
    ${InputObject},

    [Switch]
    $AutoSize,

    $Encoding='Unicode',

    [Switch]
    $IncludeHeader,

    $HeaderText = '- Page {0} -',

    $FontEmbedded = 'Always'
  )

  Begin
  {
    Function Add-Header
    {
      if ($IncludeHeader)
      {
        $gfx.DrawString(
          ($HeaderText -f $PageCount),
          $font,
          [PdfSharp.Drawing.XBrushes]::Black,
          (New-Object PdfSharp.Drawing.XRect($indent, $linecount, $page.Width, 0 )), #$page.Height) ),
          [PdfSharp.Drawing.XStringFormats]::Center)
        $script:linecount += ($Increment * 3)
      }
    }

    Function Add-Line
    {
      param
      (
        $text
      )

      Write-Progress -Activity "Creating File $Path" -Status "Writing Page $PageCount"

      ForEach ($line in ($text -split '\n'))
      {
        if ($AutoSize)
        {
          $size = $gfx.MeasureString($line, $font)

          if (($size.width + 2*$indent) -gt $page.Width)
          {
            $page.Width = $size.Width + (2*$indent)
          }
        }

        $gfx.DrawString(
          $line,
          $font,
          [PdfSharp.Drawing.XBrushes]::Black,
          (New-Object PdfSharp.Drawing.XRect($indent, $linecount, $page.Width, 0 )), #$page.Height) ),
          [PdfSharp.Drawing.XStringFormats]::Default)

        $script:linecount += $Increment

        if ($linecount -gt ($page.Height.Value-$fontsize))
        {
          $script:linecount = $Increment
          $script:page = $document.AddPage()
          $script:gfx = [PdfSharp.Drawing.XGraphics]::FromPdfPage($page)
          $script:pagecount++
          Write-Progress -Activity "Creating File $Path" -Status "Writing Page $PageCount"
          Add-Header
        }
      }
    }

    $isPDF =  [system.io.path]::GetExtension($Path) -eq '.pdf'

    if ($isPDF)
    {
      Add-Type -Path $PSScriptRoot\binaries\pdfsharp-wpf.dll
      $document = New-Object PdfSharp.Pdf.PdfDocument
      $script:page = $document.AddPage()
      $script:gfx = [PdfSharp.Drawing.XGraphics]::FromPdfPage($page)
      $options = New-Object PdfSharp.Drawing.XPdfFontOptions([PdfSharp.Pdf.PdfFontEncoding]$Encoding, [PdfSharp.Pdf.PdfFontEmbedding]$FontEmbedded)
      $font = New-Object PdfSharp.Drawing.XFont($FontName, $FontSize, [PdfSharp.Drawing.XFontStyle]$Decoration, $options)
      $script:PageCount = 1
      $script:linecount = $increment = [Int]($fontsize * 1.2)
      Add-Header
    }
    else
    {
      $null = New-Item -Path $Path -Force -ItemType File
    }

    $tmp = @()

    try {
      $outBuffer = $null
      $null = $psBoundParameters.Remove('Width')
      $null = $psBoundParameters.Remove('Path')
      $null = $psBoundParameters.Remove('FontName')
      $null = $psBoundParameters.Remove('FontSize')
      $null = $psBoundParameters.Remove('Indent')
      $null = $psBoundParameters.Remove('Decoration')
      $null = $psBoundParameters.Remove('Open')
      $null = $psBoundParameters.Remove('Passthru')
      $null = $psBoundParameters.Remove('MaxAutosizeWidth')
      $null = $psBoundParameters.Remove('Encoding')
      $null = $psBoundParameters.Remove('IncludeHeader')
      $null = $psBoundParameters.Remove('HeaderText')
      $null = $psBoundParameters.Remove('FontEmbedded')

      if ($AutoSize)
      {
        $Width = $MaxAutoSizeWidth
      }

      if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
      {
        $PSBoundParameters['OutBuffer'] = 1
      }

      $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Format-Table', [System.Management.Automation.CommandTypes]::Cmdlet)

      if ($AutoSize)
      {
        $collector = New-Object System.Collections.ArrayList
        $scriptCmd = {& $wrappedCmd @PSBoundParameters | Out-String -Stream -Width $Width | Foreach-Object { $null = $collector.Add( $_);

            if ($PassThru)
            {
              $_
            }
          } }
      }
      else
      {
        $scriptCmd = {& $wrappedCmd @PSBoundParameters | Out-String -Stream -Width $Width | Foreach-Object { $tmp += $_;

            if ($PassThru)
            {
              $_
            }
          } }
      }

      $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
      $steppablePipeline.Begin($PSCmdlet)
    } catch {
      throw
    }
  }

  Process
  {
    try {
      $steppablePipeline.Process($_)
    } catch {
      throw
    }

    if ($AutoSize -eq $false)
    {
      if ($isPDF)
      {
        Add-Line $tmp
      }
      else
      {
        $tmp | Add-Content -Path $path -Encoding $Encoding
      }

      $tmp = @()
    }
  }

  End
  {
    try {
      $steppablePipeline.End()
    } catch {
      throw
    }

    if ($AutoSize)
    {
      if ($isPDF)
      {
        ForEach ($line in $collector)
        {
          Add-Line $line
        }
      }
      else
      {
        $collector | Add-Content -Path $path -Encoding $Encoding
      }
    }

    if ($isPDF)
    {
      $document.Save( $Path )
    }

    if ($Open)
    {
      Invoke-Item $Path
    }
  }
}
