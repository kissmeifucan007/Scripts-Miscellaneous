# source:  https://tech.mavericksevmont.com/blog/powershell-selenium-automate-web-browser-interactions-part-i/

$credential = Get-Credential

$YourURL = "http://10.20.30.1" # Website we'll log to
# Invoke Selenium into our script!

$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver # Creates an instance of this class to control Selenium and stores it in an easy to handle variable


$ChromeDriver.Navigate().GoToURL($YourURL)
$pass = $credential | ConvertFrom-SecureString

$ChromeDriver.FindElementByName("USERNAME").SendKeys($credential.UserName)
$ChromeDriver.FindElementByName("PASSWORD_T").SendKeys("Pr1nt3r")
$ChromeDriver.FindElementByName("LoginButton").Click()
