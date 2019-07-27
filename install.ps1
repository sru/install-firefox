# Find out OS architecture.
# `[Environment]::Is64BitOperatingSystem` works for newer PowerShell. ;(
If ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq '64-bit') {
	$os = 'win64'
}
else {
	$os = 'win'
}

# Download Firefox.
$installerUrl = "https://download.mozilla.org/?product=firefox-latest&os=$os&lang=en-US"
$installerPath = "$env:TEMP\firefox-setup.exe"
(New-Object System.Net.WebClient).DownloadFile($installerUrl, $installerPath)
Write-Output 'Downloaded Firefox setup.'

# Install Firefox.
# `/S` for silent installation (no GUI).
$installerProc = Start-Process -FilePath $installerPath -ArgumentList @('/S') -PassThru
$installerProc.WaitForExit()
Write-Output 'Installed Firefox.'


# TODO: Enable AutoConfig.
# $firefoxRoot = 'C:\Program Files\Mozilla Firefox'
# $autoConfigText = "pref('general.config.filename', 'firefox.cfg');`npref('general.config.obscure_value', 0);`npref('browser.startup.homepage', 'http://example.com');`n"
# $autoConfigPath = "$firefoxRoot\defaults\pref\autoconfig.js"
# [IO.File]::WriteAllText($autoConfigPath, $autoConfigText)
# Write-Output 'Enabled AutoConfig.'
