# Install Firefox

Install Firefox semi-automatically in 사지방.

## Rationale

The computers in 사지방 almost resets every reboot and every login.
There isn't any consistency on what gets reset and what does not.
Firefox is installed on some computers,
but, if installed, it is always old version.
I tweak Firefox preferences to ensure I don't leave any sensitive information after using Firefox.
This is just a way to automate installing Firefox to latest version and tweaking preferences.

## Installation

Run following in `cmd.exe`:

```cmd
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" ^
-NoProfile -InputFormat None -ExecutionPolicy Bypass -Command ^
"Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sru/install-firefox/master/install.ps1'))"
```

This is inspired from the installation direction of [Chocolatey](https://chocolatey.org/).

If right click is not working, you can paste by pressing `alt-space E P`.
