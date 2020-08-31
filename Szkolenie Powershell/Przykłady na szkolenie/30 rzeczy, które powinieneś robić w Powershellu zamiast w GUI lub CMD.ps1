# Źródło: Orin Thomas: 30 common tasks you perform using the GUI that you can do faster in Windows PowerShell
# slajdy i film: https://channel9.msdn.com/events/TechEd/2014/DCI316?term=30%20common%20tasks%20you%20perform%20using%20the%20GUI&lang-en=true

# 1. ipconfig /all

Get-NetIPConfiguration

# 2. Nazwy kart sieciowych i sprawdzanie, która jest w użyciu

Get-NetAdapter
Get-NetAdapterStatistics 

# 3. Konfiguracja adresu IP

New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.16.0.20 -PrefixLength 24 -DefaultGateway 172.16.0.1

# 4. I adresu serwera DNS

Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 172.16.0.10 

# 5. ping i sprawdzanie połączenia z siecią

Test-NetConnection # i nie potrzeba więcej - domyślnie odpytuje internetbeacon.msedge.net

Test-NetConnection 8.8.8.8

# 5a Jest tez Test-Connection
# Tu omówienie porównania obu komend  :https://4sysops.com/archives/test-netconnection-vs-test-connection-testing-a-network-connection-with-powershell/
# To polecenie zwraca mniej informacji, i ma mniej dostępnych opcji. Zwraca tyle co ping.

Test-Connection 8.8.8.8

# 6. Tracert / traceroute

Test-NetConnection www.bing.com –Traceroute

# 7. Testowanie otwartych portów

Test-NetConnection www.bing.com –Port 80
Test-NetConnection smtp.com –Port 25

# 8. Lista usług z wyszukiwaniem

Get-Service | Out-Gridview 

# lub odfiltrowanie zatrzymanych usług: 

Get-Service | Where-Object {$_.Status –eq "Stopped"}


# 9. Ponowne uruchomienie usługi
 
Restart-Service 

Get-Service | Out-Gridview -PassThru -Title "Wybierz usługi do ponownego uruchomienia i kliknij 'OK'" | Restart-Service 

# 10. Zatrzymywanie, uruchamiani i konfiguracja usług

Stop-Service
Start-Service
Set-Service

# 11. Zmień nazwę komputera

Rename-Computer 'NowaNazwaKomputera'

# 12. Restart komputera

Restart-Computer

# 13. Wyłączenie komputera

Shutdown-Computer

# =============================== Domena Active Directory =====================================

# Polecenia poniżej wymagają na Windows 10 doinstalowania paczki RSAT (Remote Server Administration Tools)
# Źródło instalacji: https://www.microsoft.com/pl-pl/download/details.aspx?id=45520

# 14. Dodanie komputera do domeny

Add-Computer -DomainName example.com

# 15. Dodanie ról i funkcji Windows (Roles and Features)

Install-WindowsFeature -IncludeAllSubfeature -IncludeManagementTools File-Services

# 15.a Framework .NET

Install-WindowsFeature Net-Framework-Core -source d:\sources\sxs

# 16. Naprawienie relacji zaufania komputera z Domeną AD

test-computersecurechannel -credential (get-credential) -Repair

# 17. UWAGA! tylko do testów - wyłączenie zapory sieciowej
# źródło: https://www.dell.com/support/article/pl-pl/sln156432/windows-server-prawid%C5%82owy-spos%C3%B3b-wy%C5%82%C4%85czania-zapory-systemu-windows-w-systemie-server-2008-i-nowszych-wersjach?lang=pl

# Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 18. Ustawianie reguł zapory (firewall)

New-NetFirewallRule -DisplayName "Allow Inbound Port 80" -Direction Inbound –LocalPort 80 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "Block Outbound Port 80" -Direction Outbound –LocalPort 80 -Protocol TCP -Action Block

# ========================================== Maszyny wirtualne (VM) w Hyper-V ===================================================
# Źródło dodatkowe: 20 Better Ways to Perform Server Administration Using PowersShell
# online: https://channel9.msdn.com/Events/Ignite/Microsoft-Ignite-New-Zealand-2015/M339
# Materiał powtarza w większości treść 30 things..., ale uzupełnia

# Powershell Direct - pozwala łączyć się z Maszyną wirtualną z poziomu hosta maszyn, bez wymaganej łaczności sieciowej.
# Wymaga Windows 10 lub Windows Serwer 2016

# 19.0 Łączenie z maszyną wirtualną przez Powershell Direct i wykonanie na niej polecenia

Enter-PSSession –VMName VMName 
Invoke-Command –VMName VMName –ScriptBlock {Get-Process}

# albo

$skrypt = {Get-Process}
$sesja  =  

# 19. Utworzenie maszyny wirtualnej 

New-VM -MemoryStartupBytes 2048MB -Name WIN10TEST -Path "d:\SYD-VM" -VHDPath  "d:\SYD-VM\prep-disk.vhdx"

# lub

$vmProperties = @{
   MemoryStartupBytes = 2048MB
   Name               = "WIN10TEST"
   Path               = "d:\SYD-VM"
   VHDPath            = "d:\SYD-VM\prep-disk.vhdx"
}
New-VM @vmProperties

# 20. Przypisanie sieci do maszyny wirtualnej

GET-VM –name SYD* | GET-VMNetworkAdapter | Connect-VMNetworkAdapter –Switchname 'Private Network' 

# 21. Utworzenie Checkpointów / Snapshotów (to to samo) maszyn wirtualnych

Get-VM | CheckPoint-VM

# 22. Reset hasła w AD

$noweHasło = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText –Force
Set-ADAccountPassword nazwaUżytkownika -NewPassword $noweHasło –Reset

# lub z wymuszeniem zmiany przy logowaniu

Set-ADAccountPassword nazwaUżytkownika -NewPassword $noweHasło -Reset -PassThru | Set-ADuser -ChangePasswordAtLogon $True

# oraz bez wpisywania hasła 'czystym textem' (no plaintext)
# Źródło: https://devblogs.microsoft.com/scripting/decrypt-powershell-secure-string-password/

$credential = get-credential 
Set-ADAccountPasswor -identity $credential.UserName -NewPassword ($credential.GetNetworkCredential().Password) –Reset

# 22a. Stwórz nowego użytkownika w AD

New-ADUser –Name Don.Funk –AccountPassword $noweHasło  # $noweHasło musi być typu SecureString

# 22.b Stwórz nową grupę w AD

New-ADGroup -Name "Aucklanders" -SamAccountName Aucklanders -GroupCategory Security -GroupScope Global -Path "CN=Users,DC=example.com,DC=Internal"

# 23. Zlokalizowanie ról FSMO w domenie/lesie AD. Lokalizacja "głównego" kontrolera domeny
# Polecenia w wersji od Dr Scripto: https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-get-list-of-fsmo-role-holders/ 

Get-ADDomain | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator
Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster

Get-ADDomainController -Filter * |
   Select-Object Name, Domain, Forest, OperationMasterRoles |
   Where-Object {$_.OperationMasterRoles} |
   Format-Table -AutoSize

# 24. Przejęcie (przeniesienie) roli FSMO - wymuszenie w wypadku awarii 'głównego' kontrolera

Move-ADDirectoryServerOperationMasterRole -Identity NEW-DC -OperationMasterRole RIDMaster,InfrastructureMaster,DomainNamingMaster -Force

# 25. Zezwolenie na połączenia RDP

Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# 26. Zaktualizuj komputer

Get-Hotfix

# 27.  Data i strefa czasowa

Set-date "12/12/2014 10:30 PM"

(Get-WmiObject win32_timezone).caption 
TZUTIL /s "AUS Eastern Standard Time"

# 28. Znajdź użytkowników, którym nie wygasa hasło w AD

Search-ADAccount –PasswordNeverExpires | out-gridview 

# 28a. Znajdź użytkowników, którzy nie logowali się od 90 dni

Search-AdAccount –accountinactive –timespan 90.00:00:00

# albo

$czasWDniach = New-TimeSpan -Days 90
Search-AdAccount –accountinactive –timespan $czasWDniach

# 29. Znajdź zablokowane oraz wyłaczone konta użytkowników AD (locked, disabled)

Search-AdAccount –Lockedout | out-gridview
Search-AdAccount –AccountDisabled | out-gridview


# ========================= DNS ======================================
# Nowa strefa DNS -  DNS Primary Zone

Add-DnsServerPrimaryZone -Name 	"westisland.example.com.internal" -ReplicationScope 	"Forest" -PassThru 

# Nowy wpis DNS
Add-DnsServerResourceRecordA -Name "wellington" -ZoneName "example.com.internal" -AllowUpdateAny -IPv4Address "172.18.99.23" -TimeToLive 01:00:00 

# ========================= DHCP =====================================

# Nowa rezerwacja DHCP

Add-DhcpServerv4Reservation -ComputerName domaincontrol.example.com.internal -ScopeId 172.16.0.0 -IPAddress 172.16.0.200 -ClientId F0-DE-F1-7A-00-5E -Description "Reservation for Printer"

# albo

$DHCPreservation = @{
   ComputerName = "domaincontrol.example.com.internal"
   ScopeId      =  '172.16.0.0' 
   IPAddress    =  '172.16.0.200' 
   ClientId     =  'F0-DE-F1-7A-00-5E' 
   Description  =  "Reservation for Printer"
}
Add-DhcpServerv4Reservation @$DHCPreservation

# Nowy zakres DHCP - DNS (scope setting - DNS)

Set-DhcpServerv4OptionValue -ComputerName domaincontrol.example.com.internal -ScopeId 172.16.0.0 -OptionId 006 -Value "172.16.0.10"

#Nowy zakres DHCP - Bra,a (Gatway)

Set-DhcpServerv4OptionValue -ComputerName domaincontrol.example.com.internal -ScopeId 172.16.0.0 -OptionId 003 -Value "172.16.0.1"

# ========================= SMB =========================================

# Nowy udział sieciowy

New-SmbShare –Name SharedFolder –Path "C:\SharedFolder" -FullAccess example.com\Administrator -ReadAccess example.com\Don.Funk
