# Find out OS architecture.
# `[Environment]::Is64BitOperatingSystem` works for newer PowerShell. :'(
If ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq '64-bit') {
	$os = 'win64'
}
else {
	$os = 'win'
}

$webClient = New-Object System.Net.WebClient

# Download Firefox.
$installerUrl = "https://download.mozilla.org/?product=firefox-latest&os=${os}&lang=en-US"
$installerPath = "${env:TEMP}\firefox-setup.exe"
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
$autoConfigPath = "${firefoxRoot}\defaults\pref\autoconfig.js"
$webClient.DownloadFile($autoConfigUrl, $autoConfigPath)
Write-Output 'Enabled AutoConfig.'

# Download configuration.
$configUrl = 'https://raw.githubusercontent.com/sru/install-firefox/master/config.js'
$configPath = "${firefoxRoot}\config.js"
$webClient.DownloadFile($configUrl, $configPath)
Write-Output 'Downloaded configuration.'

# Download addons.

$addons = @(
	@{
		Name = 'ublock-origin';
		AccountId = '11423598';
		AddonId = 'uBlock0@raymondhill.net'
	},
	@{
		Name = 'privacy-badger17';
		AccountId = '5474073';
		AddonId = 'jid1-MnnxcxisBPnSXQ@jetpack'
	},
	@{
		Name = 'https-everywhere';
		AccountId = '5474073';
		AddonId = 'https-everywhere@eff.org'
	}
)

$addonUrl = 'https://addons.mozilla.org/en-US/firefox/addon/{0}/'

# The latest addon URL is found on https://stackoverflow.com/a/55593381.
# {0} is the addon name, the last part of the path of URL to the addon page.
# {1} is the account ID, the last part of the path of the URL on user link on the addon page.
$addonDownloadUrl = 'https://addons.mozilla.org/firefox/downloads/latest/{0}/addon-{1}-latest.xpi'

# https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Distribution_options/Sideloading_add-ons
$addonPath = "${env:APPDATA}\Mozilla\Extensions\{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"

# Ensure the addon path exists.
New-Item -Path $addonPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

ForEach ($addon in $addons) {
	Write-Output "Downloading addon `"$($addonUrl -f $addon.Name)`"."
	$webClient.DownloadFile(
		($addonDownloadUrl -f $addon.Name, $addon.AccountId),
		"${addonPath}\$($addon.AddonId).xpi"
	)
}

Write-Output 'Downloaded addons.'

# Start Firefox.
Start-Process "${firefoxRoot}\firefox.exe"
Write-Output 'Started Firefox.'

Write-Output 'Done! Enjoy.'

# Close the parent CMD window.
$parentProcessId = (Get-WmiObject -Class Win32_Process -Filter "ProcessId = '$PID'").ParentProcessId
$parentProcess = Get-process -Id $parentProcessId
If ($parentProcess.ProcessName -eq 'cmd')) {
	$parentprocess.CloseMainWindow()
}
