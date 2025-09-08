#!/usr/bin/env bash
set -euo pipefail

# Export selected preference domains to .plist files in current directory
echo "Exporting prefs into $(pwd)"

# Trackpad
defaults export com.apple.AppleMultitouchTrackpad ./com.apple.AppleMultitouchTrackpad.plist || true
defaults export com.apple.driver.AppleBluetoothMultitouch.trackpad ./com.apple.driver.AppleBluetoothMultitouch.trackpad.plist || true
defaults -currentHost export NSGlobalDomain ./NSGlobalDomain.currenthost.plist || true

# Keyboard
defaults export com.apple.HIToolbox ./com.apple.HIToolbox.plist || true
defaults export NSGlobalDomain ./NSGlobalDomain.plist || true
defaults export com.apple.symbolichotkeys ./com.apple.symbolichotkeys.plist || true

# Dock, Finder, Screenshots, Mission Control, Accessibility
defaults export com.apple.dock ./com.apple.dock.plist || true
defaults export com.apple.finder ./com.apple.finder.plist || true
defaults export com.apple.screencapture ./com.apple.screencapture.plist || true
defaults export com.apple.spaces ./com.apple.spaces.plist || true
defaults export com.apple.universalaccess ./com.apple.universalaccess.plist || true

# System-wide (needs sudo)
echo "Exporting system-wide prefs (requires sudo)…"
sudo -v
sudo defaults export /Library/Preferences/com.apple.AppleMultitouchTrackpad ./system.com.apple.AppleMultitouchTrackpad.plist || true
sudo defaults export /Library/Preferences/.GlobalPreferences ./system.GlobalPreferences.plist || true
sudo defaults export /Library/Preferences/com.apple.HIToolbox ./system.com.apple.HIToolbox.plist || true

echo "Done. Files written to $(pwd)"
