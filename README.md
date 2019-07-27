# Install Firefox

Install Firefox semi-automatically in 사지방.

# Installation

Run following in `cmd.exe`:

```
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sru/install-firefox/master/install.ps1'))"
```

This is inspired from the installation direction of [Chocolatey](https://chocolatey.org/).

If right click is not working, you can paste by pressing `alt-space E P`.
