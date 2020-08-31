import-module activedirectory
#Create excel COM object
$excel = New-Object -ComObject excel.application

#Make Visible
$excel.Visible = $True
$excel.DisplayAlerts = $False

#Add a workbook
$workbook = $excel.Workbooks.add()

#Remove other worksheets
1..2|foreach{
    $Workbook.worksheets.item(2).Delete()}
#Connect to first worksheet to rename and make active
$timer = (Get-Date -Format yyyy-MM-dd-HHmm)
$filename = "C:\Scripts\" + $timer + "-RemoteAccessReview.xlsx"

#Connect to first worksheet to rename and make active
$serverInfoSheet = $workbook.Worksheets.Add()
$serverInfoSheet.Activate() | Out-Null

#Create a Title for the first worksheet
$row = 1
$Column = 1
$serverInfoSheet.Cells.Item($row,$column)= 'Remote Access Review'

$range = $serverInfoSheet.Range("a1","D2")
$range.Merge() | Out-Null
$range.VerticalAlignment = -4160

#Give it a nice Style so it stands out
$range.Style = 'Title'

#Increment row for next set of data
$row++;$row++

#Save the initial row so it can be used later to create a border
$initalRow = $row

#Create a header for Disk Space Report; set each cell to Bold and add a background color
$serverInfoSheet.Cells.Item($row,$column)= 'Display Name'
$serverInfoSheet.Cells.Item($row,$column).Interior.ColorIndex =48
$serverInfoSheet.Cells.Item($row,$column).Font.Bold=$True
$Column++
$serverInfoSheet.Cells.Item($row,$column)= 'Title'
$serverInfoSheet.Cells.Item($row,$column).Interior.ColorIndex =48
$serverInfoSheet.Cells.Item($row,$column).Font.Bold=$True
$Column++
$serverInfoSheet.Cells.Item($row,$column)= 'Department'
$serverInfoSheet.Cells.Item($row,$column).Interior.ColorIndex =48
$serverInfoSheet.Cells.Item($row,$column).Font.Bold=$True
$Column++
$serverInfoSheet.Cells.Item($row,$column)= 'Remote Access Enabled'
$serverInfoSheet.Cells.Item($row,$column).Interior.ColorIndex =48
$serverInfoSheet.Cells.Item($row,$column).Font.Bold=$True


#Set up a header filter
$headerRange = $serverInfoSheet.Range("a3","D3")
$headerRange.AutoFilter() | Out-Null

#Increment Row and reset Column back to first column
$row++
$Column = 1

#Get Users in OU
$members = Get-ADGroupMember -Identity "Security - Global Citrix token users" -Recursive 
$memberNames = $members.SamAccountName
#Process each user in the collection and write to spreadsheet
ForEach ($member in $memberNames) {
    $memberInfo =Get-ADUser -Identity $member -Properties Name, Title, Department
    $serverInfoSheet.Cells.Item($row,$column)= $memberInfo.Name
    $Column++
    $serverInfoSheet.Cells.Item($row,$column)= $memberInfo.Title
    $Column++
    $serverInfoSheet.Cells.Item($row,$column)= $memberInfo.Department
    $Column++
    $serverInfoSheet.Cells.Item($row,$column)= "True"
    $Column++

 
    $Column = 1
    $row++
}

#Add a border for data cells
$row--
$dataRange = $serverInfoSheet.Range(("A{0}"  -f $initalRow),("D{0}"  -f $row))
7..12 | ForEach {
    $dataRange.Borders.Item($_).LineStyle = 1
    $dataRange.Borders.Item($_).Weight = 2
}

#Auto fit everything so it looks better
$usedRange = $serverInfoSheet.UsedRange													
$usedRange.EntireColumn.AutoFit()| Out-Null
$usedRange.EntireRow.AutoFit()| Out-Null



$serverInfoSheet.Name =  "Remote Access Review"

#Quit the application
$workbook.saveas($filename)
$excel.quit()
#Release COM Object
[System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$excel)|out-null
Send-MailMessage -smtpserver 10.104.10.30 -From "jin.wang@vistra.com" -To "jin.wang@vistra.com","Maro.Secretario@vistra.com" -Subject "Remote Access Review " -Body "Remote Access Review by $timer " -attachment $filename