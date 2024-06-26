# Function to check if the script is running as administrator
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Host "❌ This script must be run as an administrator." -ForegroundColor Red
    exit
}

Write-Host "🚀 Starting the installation process..."

# Install Chocolatey if not already installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "🍫🍫🍫 Please install chocolatey to continue 🍫🍫🍫"
    exit
} else {
    Write-Host "✅ Chocolatey is installed."
}

# Check if oh-my-posh is already installed using Chocolatey
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "✅ oh-my-posh is already installed."
    # TODO update oh-my-posh using Chocolatey
} else {
    # Install oh-my-posh using Chocolatey
    Write-Host "🎨 Installing oh-my-posh..."
    choco install oh-my-posh -y
}

# Install Caskaydia Cove Nerd Font using Chocolatey
# Write-Host "🔤 Installing Caskaydia Cove Nerd Font via Chocolatey... 🍫"
# choco install caskaydiacove-nerd-font -y

# Set oh-my-posh font to Caskaydia Cove Nerd Font
# Write-Host "🔧 Configuring oh-my-posh theme with Caskaydia Cove Nerd Font..."
# Add-Content -Path $profilePath -Value 'Set-PoshPrompt -Theme https://github.com/thiemohaller/public-dotfiles/raw/main/ohmyposh/zen-omp.toml -Font CaskaydiaCove NF'

# Load configuration file from GitHub
Write-Host "🌐 Downloading configuration file from GitHub..."
$configUrl = "https://github.com/thiemohaller/public-dotfiles/raw/main/ohmyposh/zen_windows.toml"
$configPath = "$env:USERPROFILE\Documents\ohmyposh\zen_windows.toml"

# Check if the directory exists, if not create it
$directory = Split-Path -Parent $configPath
if (-not (Test-Path $directory)) {
    New-Item -ItemType Directory -Path $directory | Out-Null
    Write-Host "✅ Created directory: $directory"
} else {
    Write-Host "✅ Directory already exists: $directory"
}

Invoke-WebRequest -Uri $configUrl -OutFile $configPath

# Check if the file exists
if (Test-Path $configPath) {
    Write-Host "✅ Configuration file downloaded to $configPath"
} else {
    Write-Host "❌ Failed to download the configuration file."
}

# use the configuration file
Write-Host "🔧 Initializing oh-my-posh with the downloaded configuration..."
oh-my-posh init pwsh --config "$configPath" | Invoke-Expression

# Install terminal icons
Write-Host "🔧 Installing terminal icons..."
Install-Module -Name Terminal-Icons -Repository PSGallery
# Add Terminal-Icons to profile
Write-Host "🔧 Adding Terminal-Icons to profile..."
Import-Module -Name Terminal-Icons

# Reload profile
Write-Host "🔄 Reloading PowerShell profile..."
. $PROFILE

Write-Host "✅ Installation and configuration completed successfully!"
Write-Host "🐬🐬🐬 So long and thanks for all the fish! 🐬🐬🐬"
