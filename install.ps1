# Find out OS architecture.
# `[Environment]::Is64BitOperatingSystem` works for newer PowerShell. ;(
If ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq '64-bit') {
	$os = 'win64'
}
else {
	$os = 'win'
}

$webClient = New-Object System.Net.WebClient

# Download Firefox.
$installerUrl = "https://download.mozilla.org/?product=firefox-latest&os=$os&lang=en-US"
$installerPath = "$env:TEMP\firefox-setup.exe"
$webClient.DownloadFile($installerUrl, $installerPath)
Write-Output 'Downloaded Firefox setup.'

# Install Firefox.
# `/S` for silent installation (no GUI).
$installerProc = Start-Process -FilePath $installerPath -ArgumentList @('/S') -PassThru
$installerProc.WaitForExit()
Write-Output 'Installed Firefox.'

$firefoxRoot = 'C:\Program Files\Mozilla Firefox'

# Enable AutoConfig.
$autoConfigUrl = 'https://raw.githubusercontent.com/sru/install-firefox/master/autoconfig.js'
$autoConfigPath = "$firefoxRoot\defaults\pref\autoconfig.js"
$webClient.DownloadFile($autoConfigUrl, $autoConfigPath)
Write-Output 'Enabled AutoConfig.'

# Download configuration.
$configUrl = 'https://raw.githubusercontent.com/sru/install-firefox/master/config.js'
$configPath = "$firefoxRoot\config.js"
$webClient.DownloadFile($configUrl, $configPath)
Write-Output 'Downloaded configuration.'

# Start Firefox.
Start-Process "$firefoxRoot\firefox.exe"
