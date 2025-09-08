#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-.}"
[[ -d "$DIR" ]] || { echo "Usage: $0 <directory-with-plists>"; exit 1; }

echo "Applying all .plist files in: $DIR"
sudo -v

shopt -s nullglob
for FILE in "$DIR"/*.plist; do
  BASE=$(basename "$FILE")
  echo "→ $BASE"

  case "$BASE" in
    # USER domains
    com.apple.AppleMultitouchTrackpad.plist)
      defaults import com.apple.AppleMultitouchTrackpad "$FILE" ;;
    com.apple.driver.AppleBluetoothMultitouch.trackpad.plist)
      defaults import com.apple.driver.AppleBluetoothMultitouch.trackpad "$FILE" ;;
    NSGlobalDomain.currenthost.plist)
      defaults -currentHost import NSGlobalDomain "$FILE" ;;
    NSGlobalDomain.plist)
      defaults import NSGlobalDomain "$FILE" ;;
    com.apple.HIToolbox.plist)
      defaults import com.apple.HIToolbox "$FILE" ;;
    com.apple.symbolichotkeys.plist)
      defaults import com.apple.symbolichotkeys "$FILE" ;;
    com.apple.finder.plist)
      defaults import com.apple.finder "$FILE" ;;
    com.apple.dock.plist)
      defaults import com.apple.dock "$FILE" ;;
    com.apple.screencapture.plist)
      defaults import com.apple.screencapture "$FILE" ;;
    com.apple.spaces.plist)
      defaults import com.apple.spaces "$FILE" ;;
    com.apple.universalaccess.plist)
      defaults import com.apple.universalaccess "$FILE" ;;

    # SYSTEM domains
    system.com.apple.AppleMultitouchTrackpad.plist)
      sudo defaults import /Library/Preferences/com.apple.AppleMultitouchTrackpad "$FILE" ;;
    system.GlobalPreferences.plist)
      sudo defaults import /Library/Preferences/.GlobalPreferences "$FILE" ;;
    system.com.apple.HIToolbox.plist)
      sudo defaults import /Library/Preferences/com.apple.HIToolbox "$FILE" ;;

    # Unknown => skip safely
    *)
      echo "   (skipping unknown plist name pattern)" ;;
  esac
done
shopt -u nullglob

echo "Refreshing services…"
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
killall cfprefsd 2>/dev/null || true

# Nudge tap-to-click / natural scrolling (helps on some versions)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true || true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true || true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 || true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 || true

echo "Done. Some prefs may need a log out/in."
