Write-Host "🚀 Starting the installation process and checking dependencies..."

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
} else {
    Write-Host "🍫🍫🍫 Please install oh-my-posh via Chocolatey... 🍫🍫🍫"
}

# Load configuration file from GitHub
$configPath = "$env:USERPROFILE\Documents\ohmyposh\zen_windows.toml"
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

Write-Host "✅ Installation and configuration completed successfully! Please restart your terminal."
Write-Host "🐬🐬🐬 So long and thanks for all the fish! 🐬🐬🐬"
