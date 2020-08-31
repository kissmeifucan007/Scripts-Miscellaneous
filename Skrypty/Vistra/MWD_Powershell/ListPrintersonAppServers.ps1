$servers = @"
LUBSRVAP001
POZSRVAP001
BUDSRVAP001
WROSRVAP001
BUCSRVAP001
SOFSRVAP001
KRASRVAP001
PRGSRVAP001
WAWSRVPRN001
PLWAPS01
"@

$serverList = $servers.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

# initialize empty table to store printer info 
$printers = @()

# iterate through chosen print servers
for ($i = 0; $i -lt $serverList.Count; $i++)
{   
    # list all printer ports on the server
    # this is done to match WSD ports of printers and get their IP addresses
    $ports = Get-PrinterPort -ComputerName $servers[$i].IP | Select @{label=’IpAddress’;expression={($_.DeviceURL -split "/")[2]}}, name
    
    # store printer list gathered from server in temporary variable
    # add IpAddress field (@{label ...}) to each entry in 'Select' and populate with empty string "" - to be filled in next steps
    # select only needed properties, in desired order
    $tempPrinters = get-printer -ComputerName $servers[$i].IP | Select 'Name',@{label=’IpAddress’;expression={""}},'PortName','ShareName','PrinterState','PrintProcessor','DriverName','ComputerName','Location','Comment','JobCount'
    
    # iterate through printer list extracted from current print server
    foreach ($printer in $tempPrinters) {
       # if port is a WSD port
       if ($printer.Portname -match "WSD-*"){ 
           # Match WSD port on port list with port on printer and get corresponding IP address from port list
           # expand-property to output string only and not an object    
           $printer.IpAddress = $ports | ? {$_.Name -eq $printer.Portname} |select -ExpandProperty IpAddress 
       }
       # if port starts with a digit (expected values are in #.#.#.# or #.#.#.#_# format)
       elseif ($printer.portname[0] -match "\d"){
           # select only IP Address by splitting portname on '_' and selecting first part
           $printer.IpAddress = $printer.PortName.split("_")[0]
       }

       # do not match other conditions

       # add printer info to printer list
       $printers += $printer
    }

    # Write progress bar based on number of print servers already processed
    Write-Progress -Activity "Getting printer info" -PercentComplete ($i/$Servers.count*100);
}

# display exported printes in Grid View
$printers | Out-GridView

# export printer list to CSV and override previous entry
$printers | export-csv -Path $outputCsvPath -Delimiter ";" -NoTypeInformation -Force

# open the created CSV file (should open in Excel if installed) 
start $outputCsvPath

