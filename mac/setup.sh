#!/bin/bash

set -euo pipefail

# Determine script directory early for later path references
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Running Homebrew package install script..."
bash "$SCRIPT_DIR/brew_install.sh"

# Install Oh My Zsh if not present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Copy .zshrc from repo (expects it one level up in ohmyzsh directory)
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
echo "Installing custom .zshrc..."
if [[ -f "$REPO_ROOT/ohmyzsh/.zshrc" ]]; then
  cp "$REPO_ROOT/ohmyzsh/.zshrc" ~/.zshrc
  echo ".zshrc installed."
else
  echo "No .zshrc found in $REPO_ROOT/ohmyzsh, skipping."
fi

# Update Dock
echo "Updating Dock..."
if [[ -f "$SCRIPT_DIR/Dock.plist" ]]; then
  cp "$SCRIPT_DIR/Dock.plist" ~/Library/Preferences/com.apple.dock.plist
  killall Dock || true
  echo "Dock layout applied."
else
  echo "No Dock.plist found in script directory, skipping Dock update."
fi

echo "Setup complete! Open Karabiner-Elements -> Complex Modifications -> Add Rule to enable 'Caps Lock to Backspace'."
echo "So long and thanks for all the fish!"
