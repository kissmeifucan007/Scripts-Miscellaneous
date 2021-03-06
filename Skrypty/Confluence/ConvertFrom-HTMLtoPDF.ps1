function ConvertFrom-HTMLtoPDF

<#
	.SYNOPSIS
		This Function converts HTML code to a PDF File.
	
	.DESCRIPTION
		This function, using the iTextSharp Library, reads HTML input and outputs it to a PDF File.
	
	.PARAMETER Destination
		This is where you input the path to wich you want the PDF File to be saved.
	
	.PARAMETER Source
		This is Where the HTML Source code must be set in order for it to be converted to a PDF File
	
	.EXAMPLE
		PS C:\> ConvertFrom-HTMLtoPDF -Source $HTMLCode -Destination "$env:Userprofile\Desktop\Teste2.pdf" -Verbose

#>

{
	[CmdletBinding(ConfirmImpact = 'Low')]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $false,
				   Position = 0,
				   HelpMessage = 'Input the HTML Code Here')]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		
		$Source,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $false,
				   Position = 1,
				   HelpMessage = 'Input the Destination Path to save the PDF file.')]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[string]
		$Destination
	)
	
	Begin
	{
		$currentpath = (Get-Location).Path
		
		$binaryPath = Split-Path -Path $MyInvocation.ScriptName
		
		Set-Location -Path $binaryPath
		
		Write-Verbose -Message 'Trying to Load the required assemblies'
		
		Write-Verbose -Message "Loading assemblies from $binaryPath..."
		try
		{
			Write-Verbose -Message 'Trying to load the iTextSharp assembly'
			$itextsharploadstatus = $true
			Add-Type -Path '.\bin\itextsharp.dll' -ErrorAction 'Stop'
			
		}
		
		catch
		{
			$itextsharploadstatus = $false
			
			Write-Error -Message 'Error loading the iTextSharp Assembly'
			
			break
		}
		if ($itextsharploadstatus)
		{
			Write-Verbose -Message 'Sucessfully loaded the iTextSharp Assembly'
		}
		
		try
		{
            Write-Verbose -Message 'Trying to load the XMLWorker assembly'
			$xmlworkerloadstatus = $true
			Add-Type -Path '.\bin\itextsharp.xmlworker.dll' -ErrorAction 'Stop'
			
		}
		
		catch
		{
			$xmlworkerloadstatus = $false
			
			Write-Error -Message 'Error loading the XMLWorker Assembly'
			
			break
		}
		if ($xmlworkerloadstatus)
		{
			Write-Verbose -Message 'Sucessfully loaded the XMLWorker Assembly'
		}
		
		[String]$HTMLCode = $Source
		
		Set-Location -Path $currentpath
	}
	Process
	{
		
		Write-Verbose -Message "Creating the Document object"
		
		$PDFDocument = New-Object iTextSharp.text.Document
		
		Write-Verbose -Message "Loading the reader"
		
		$reader = New-Object System.IO.StringReader($HTMLCode)
		
		Write-Verbose -Message "Defining the PDF Page Size"
		
		$PDFDocument.SetPageSize([iTextSharp.text.PageSize]::A4) | Out-Null
		
		Write-Verbose -Message "Creating the FileStream"
		
		$Stream = [IO.File]::OpenWrite($Destination)
		
		Write-Verbose -Message "Defining the Writer Object"
		
		$Writer = [itextsharp.text.pdf.PdfWriter]::GetInstance($PDFDocument, $Stream)
		
		Write-Verbose -Message "Defining the Initial Lead of the Document, BUGFix"
		
		$Writer.InitialLeading = '12.5'
		
		Write-Verbose -Message "Opening the document to input the HTML Code"
		
		$PDFDocument.Open()
		
		Write-Verbose -Message "Trying to parse the HTML into the opened document"
		Try
		{
			$htmlparsestatus = $true
			
			[iTextSharp.tool.xml.XMLWorkerHelper]::GetInstance().ParseXHtml($writer, $PDFDocument, $reader)
		}
		Catch [System.Exception]
		{
			
			$htmlparsestatus = $false
			
			Write-Error -Message "Error parsing the HTML code"
			
			break
			
		}
		
	}
	End
	{
        if ($htmlparsestatus)
		        {

			        Write-Verbose -Message "Sucessfully Created the PDF File"
		
		            Write-Verbose -Message "Closing the Document"
		
		            $PDFDocument.close()
		
		            Write-Verbose -Message "Disposing the file so it can me moved or deleted"
		
		            $PDFDocument.Dispose()
		
		            Write-Verbose -Message "Sucessfully finished the operation"

		        }
		
	}
}

[String]$HTMLCode = Get-Service | select name,Displayname,status,dep* | ConvertTo-Html -As Table
ConvertFrom-HTMLtoPDF -Source $HTMLCode -Destination "$env:userprofile\Desktop\Test.pdf" -Verbose