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

# Create policies.json file.
$distributionPath = "${firefoxRoot}\distribution"
# Ensure the path exists.
New-Item -Path $distributionPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
$policiesJson = @'
{
	"policies": {
		"DisableSetDesktopBackground": true,
		"DisableMasterPasswordCreation": true,
		"DisableFirefoxAccounts": true,
		"DisableFormHistory": true,
		"DisablePocket": true,
		"DisableProfileImport": true,
		"DNSOverHTTPS": {
			"Enabled": true,
			"Locked": true
		},
		"DontCheckDefaultBrowser": true,
		"EnableTrackingProtection": {
			"Value": true,
			"Locked": true,
			"Cryptomining": true,
			"Fingerprinting": true
		},
		"Extensions": {
			"Install": [
				"https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
				"https://addons.mozilla.org/firefox/downloads/latest/https-everywhere/latest.xpi"
			]
		},
		"NoDefaultBookmarks": true,
		"OfferToSaveLogins": false,
		"RequestedLocales": ["en-US", "ko-KR"],
		"SanitizeOnShutdown": true
	}
}
'@
Set-Content -Path "${distributionPath}\policies.json" -Encoding ASCII -Value $policiesJson
Write-Output 'Created policies.json file.'

# Create default preferences.
$defaultPrefPath = "${firefoxRoot}\browser\defaults\preferences"
# Ensure the path exists.
New-Item -Path $distributionPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
$prefs = @'
defaultPref('browser.startup.homepage', 'about:blank');
defaultPref('browser.urlbar.trimURLS', false);
'@
Set-Content -Path "${defaultPrefPath}\config.js" -Encoding ASCII -Value $prefs
Write-Output 'Created default preferences.'

# Start Firefox.
Start-Process "${firefoxRoot}\firefox.exe"
Write-Output 'Started Firefox.'

Write-Output 'Done! Enjoy.'

# Close IE.
(Get-Process iexplore) | ForEach-Object { $_.CloseMainWindow() }

# Close the parent CMD window.
$parentProcessId = (Get-WmiObject -Class Win32_Process -Filter "ProcessId = '$PID'").ParentProcessId
$parentProcess = Get-Process -Id $parentProcessId
If ($parentProcess.ProcessName -match 'cmd|powershell') {
	$parentprocess.CloseMainWindow()
}
