# Check for administrative privileges
function Test-ProcessAdmin {
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        return $false
    }
}

if (-not (Test-ProcessAdmin)) {
    Write-Host "You need to run this script as Administrator." -ForegroundColor Red
    exit
}

# Disable Windows 11 ads and suggestions
Write-Host "Disabling Windows 11 ads and suggestions..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Value 0 -PropertyType DWORD -Force

# Remove all entries from the Start Menu
Write-Host "Removing all entries from the Start Menu..."
Get-ChildItem "$env:APPDATA\Microsoft\Windows\Start Menu\Programs" | Remove-Item -Recurse -Force

# Remove Search, Window Management, and all icons from the taskbar
Write-Host "Customizing taskbar..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "MinWidth" -Value 56 -PropertyType DWORD -Force

# Restore the old right-click context menu
Write-Host "Restoring old right-click context menu..."
New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value "" -PropertyType String -Force

# Disable desktop icons
Write-Host "Disabling desktop icons..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 1 -PropertyType DWORD -Force

# Disable Widgets
Write-Host "Disabling Widgets..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -PropertyType DWORD -Force

# Set Mode to Dark
Write-Host "Setting Windows Mode to Dark..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -PropertyType DWORD -Force

# Disable OneDrive
Write-Host "Disabling OneDrive..."
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
Start-Process "C:\Windows\SysWOW64\OneDriveSetup.exe" "/uninstall" -NoNewWindow -Wait

# Disable All Analytics
Write-Host "Disabling Windows Analytics and Telemetry..."
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "AdvertisingId" -Value "00000000-0000-0000-0000-000000000000" -PropertyType String -Force

# Always display file extensions
Write-Host "Always displaying file extensions..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -PropertyType DWORD -Force

# Show hidden folders and files
Write-Host "Showing hidden folders and files..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -PropertyType DWORD -Force

# Show protected operating system files (not recommended for casual users)
Write-Host "Showing protected operating system files..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1 -PropertyType DWORD -Force

############## Remap Capslock to backspace
# Set Scancode Map in the registry
Write-Host "Setting Scancode Map for Keyboard Layout..."
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
$scancodeValue = @(
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x0E,0x00,0x3A,0x00,0x3A,0x00,0x46,0x00,0x00,0x00,0x00,0x00
)

# Create the key if it does not exist
If (!(Test-Path $registryPath)) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "Keyboard Layout" -Force
}

# Set the Scancode Map value
New-ItemProperty -Path $registryPath -Name "Scancode Map" -PropertyType Binary -Value $scancodeValue -Force
##############

# Install Chocolatey
Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Wait for Chocolatey to be installed
Start-Sleep -Seconds 30

# Install packages from a Chocolatey configuration file
Write-Host "Installing Chocolatey packages..."
choco install ./chocolatey_packages.config -y

# Set Firefox as the default browser
Write-Host "Setting Firefox as the default browser..."
$firefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
if (Test-Path $firefoxPath) {
    Start-Process $firefoxPath -ArgumentList "-setDefaultBrowser" -Wait
}

# Set default keyboard layout to Colemak
Write-Host "Setting default keyboard layout to Colemak..."
$colemakLayout = "0809:A0000409"
$regPath = "HKCU:\Keyboard Layout\Preload"
Set-ItemProperty -Path $regPath -Name "1" -Value $colemakLayout

# Set turn off screen and screensaver to never
Write-Host "Setting power options..."
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change screensaver-timeout 0
powercfg /change screensaver-policy 0
