# Splatting to technika przekazywania parametrów w jednej zmiennej - kolekcji parametrów
# jej użycie zwiększa czytelność kodu - rozbija długie linie z wieloma parametrami

# Przykład bez użycia splattingu

Get-Process -Verbose -Name "Explorer" -ErrorAction SilentlyContinue -ErrorVariable $errorVariable | Select-Object ProcessName,ID,CPU

# Przykład ze splattingiem

$getProcessSplatt = @{
    Name = "Explorer"
    Verbose = $true
    ErrorAction = 'SilentlyContinue'
    ErrorVariable = $errorVariable
 }
 Get-Process @getProcessSplatt | Select-Object ProcessName,ID,CPU

# Moja funkcja ułatwiająca użycie Splattingu dla dowolnej innej funkcji
# !UWAGA! Rezultatem działania funkcji jest kod, skopiowany do pamięci podręcznej
function Get-CommandSplattingCode{
    Param(
        [string]$commandName
    )
    $Parameters = (Get-Command $commandName).Parameters.Keys
    $Result =  "`$"+$commandName.Replace("-","")+'Splatt = @{'
    foreach ($Parameter in $Parameters) {
       $Result += "`r`n   "+$Parameter+' = '+ (Get-Command $commandName).Parameters[$Parameter].ParameterType
    }
    $Result += "`r`n}"
    $Result | clip
 }

 # Przykład użycia:

 # Uruchomienie komendy
 Get-CommandSplattingCode Get-Process

 # Wynikowy kod z pamięci podręcznej
 # Po znakach '=' określony jest oczekiwany typ wartości
 # Można linie dotyczące dowolnych niewymaganych pól
 # Trzeba wprowadzić wartości po '=' (zastąpić 'switch', int[] itp. docelowymi wartościami)
 # Poprawiony kod powinien wyglądać np. jak w przykładzie powyżej
 $GetProcessSplatt = @{
    Name = string[]
    IncludeUserName = switch
    Id = int[]
    InputObject = System.Diagnostics.Process[]
    Module = switch
    FileVersionInfo = switch
    Verbose = switch
    Debug = switch
    ErrorAction = System.Management.Automation.ActionPreference
    WarningAction = System.Management.Automation.ActionPreference
    InformationAction = System.Management.Automation.ActionPreference
    ErrorVariable = string
    WarningVariable = string
    InformationVariable = string
    OutVariable = string
    OutBuffer = int
    PipelineVariable = string
 }

# Zaawansowane użycie - uwagi
# Czasem wartość parametru w splatting należy wpisać w specyficzny sposób
# <switch> przyjmuje wartości : $true, $false
# <int[]> przyjmuje tabelę wartości np.:  @(4,5,6)
# <ScriptBlock> przyjmuje kod np.: {Test-Connaction 8.8.8.8}
# Źródło: https://social.technet.microsoft.com/Forums/lync/en-US/64b74505-8f89-47be-a00a-677e13c5f28b/getaduser-splatting-error?forum=winserverpowershell

# Przykład dla Get-AdUser
$GetADUserParameters = @{
    Identity = "username"
    Properties = @("employeeid", "manager", "notes")
}
Get-ADUser @GetADUserParameters

# Przykład dla Invoke Command
$InvokeCommandSplatt = @{
    ScriptBlock = {
        Test-Connection 8.8.8.8
    }
 }

Invoke-Command @InvokeCommandSplatt
