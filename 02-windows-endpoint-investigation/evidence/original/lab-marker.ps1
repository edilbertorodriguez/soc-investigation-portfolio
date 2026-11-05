$utc = (Get-Date).ToUniversalTime().ToString("o")
"LAB-WIN-002 execution: $utc" | Add-Content "$PSScriptRoot\run-marker.txt"
whoami.exe | Add-Content "$PSScriptRoot\run-marker.txt"
