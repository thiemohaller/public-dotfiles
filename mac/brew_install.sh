#!/bin/bash

set -euo pipefail

# Separate script for Homebrew package and cask installations so it can be run independently.
# Usage: ./brew_install.sh
# Optionally set BREW_NO_UPDATE=1 to skip 'brew update'.

if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Install it first (run mac/setup.sh or visit https://brew.sh)." >&2
  exit 1
fi

if [[ "${BREW_NO_UPDATE:-0}" != "1" ]]; then
  echo "Updating Homebrew..."
  brew update
else
  echo "Skipping 'brew update' due to BREW_NO_UPDATE=1"
fi

echo "Installing CLI tools..."
brew install \
  git \
  font-fira-code \
  ollama

echo "Installing GUI applications (casks)..."
brew install --cask \
  visual-studio-code \
  iterm2 \
  rectangle \
  karabiner-elements \
  zen \
  brave-browser \
  waterfox \
  unnaturalscrollwheels \
  alt-tab \
  stats \
  notion \
  obsidian \
  affinity-photo \
  raycast \
  tempbox \
  spotify \ 
  calibre \
  discord \
  zotero \
  audacity \
  bitwarden \
  bambu-studio \
  chatgpt \
  docker \
  ente-auth \
  freecad \
  gitkraken \
  jetbrains-toolbox \
  libreoffice \
  lm-studio \
  rustdesk \ 
  steam \
  unnaturalscrollwheels \
  vlc \
  yacreader

echo "Homebrew installations complete."
