#!/bin/bash

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update brew
brew update

# CLI tools
brew install \
  git

# GUI apps
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
  private-internet-access \
  raycast \
  tempbox \
  spotify

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

# Copy .zshrc from repo
echo "Installing custom .zshrc..."
if [[ -f "$SCRIPT_DIR/ohmyzsh/.zshrc" ]]; then
  cp "$SCRIPT_DIR/ohmyzsh/.zshrc" ~/.zshrc
  echo ".zshrc installed."
else
  echo "No .zshrc found in $SCRIPT_DIR/configs, skipping."
fi

# Update Dock
echo "Updating Dock..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ -f "$SCRIPT_DIR/Dock.plist" ]]; then
  cp "$SCRIPT_DIR/Dock.plist" ~/Library/Preferences/com.apple.dock.plist
  killall Dock || true
  echo "Dock layout applied."
else
  echo "No Dock.plist found in script directory, skipping Dock update."
fi

# Karabiner config: Caps Lock -> Delete (backspace)
echo "Configuring Karabiner"
mkdir -p ~/.config/karabiner/assets/complex_modifications
cat > ~/.config/karabiner/assets/complex_modifications/capslock_to_backspace.json <<'EOF'
{
  "title": "Caps Lock to Backspace",
  "rules": [
    {
      "description": "Change caps_lock to backspace",
      "manipulators": [
        {
          "from": { "key_code": "caps_lock" },
          "to":   [ { "key_code": "delete_or_backspace" } ],
          "type": "basic"
        }
      ]
    }
  ]
}
EOF

echo "Setup complete! Open Karabiner-Elements -> Complex Modifications -> Add Rule to enable 'Caps Lock to Backspace'."
echo "So long and thanks for all the fish!"
