# Źródło : Powershell Notes for Professionals
# Domyślnie nie można uruchamiać własnych, niepodpisanych cyfrowo skryptów

# Aby zezwolić na ich uruchamiania uruchom powershell'a jako administrator i wywołaj:

Set-ExecutionPolicy RemoteSigned

# Od teraz tylko "zdalne" skrypty będą wymagały podpisu

# Zamiast tego można "jednorazowo" skorzystać z przełącznika ExecutionPolicy:

powershell.exe -ExecutionPolicy Bypass -File "c:\MyScript.ps1"

# !UWAGA! Często sugerowanym ustawieniem ExecutionPolicy jest 'Unrestricted'
# To ustawienie znacznie obniża poziom bezpieczeństwa. 'RemoteSigned' wystarcza w większości przypadków.

