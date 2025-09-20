#!/bin/bash
set -euo pipefail

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
  ollama \
  openjdk 

echo "Installing GUI applications (casks)..."
casks=(
  visual-studio-code iterm2 rectangle karabiner-elements zen-browser
  brave-browser waterfox unnaturalscrollwheels alt-tab stats notion
  obsidian affinity-photo raycast tempbox spotify calibre discord
  zotero audacity bitwarden bambu-studio chatgpt docker ente-auth
  freecad gitkraken jetbrains-toolbox libreoffice lm-studio rustdesk
  steam vlc yacreader font-fira-code
)
brew install --cask "${casks[@]}"

echo "Homebrew installations complete."