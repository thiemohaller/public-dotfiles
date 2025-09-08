#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"
[[ -z "$FILE" ]] && { echo "Usage: $0 <plist-file>"; exit 1; }

BASENAME=$(basename "$FILE")

echo "Applying $FILE → $BASENAME"

case "$BASENAME" in
    com.apple.AppleMultitouchTrackpad.plist)
        defaults import com.apple.AppleMultitouchTrackpad "$FILE"
        ;;
    com.apple.driver.AppleBluetoothMultitouch.trackpad.plist)
        defaults import com.apple.driver.AppleBluetoothMultitouch.trackpad "$FILE"
        ;;
    NSGlobalDomain.currenthost.plist)
        defaults -currentHost import NSGlobalDomain "$FILE"
        ;;
    com.apple.HIToolbox.plist)
        defaults import com.apple.HIToolbox "$FILE"
        ;;
    NSGlobalDomain.plist)
        defaults import NSGlobalDomain "$FILE"
        ;;
    com.apple.symbolichotkeys.plist)
        defaults import com.apple.symbolichotkeys "$FILE"
        ;;
    com.apple.dock.plist)
        defaults import com.apple.dock "$FILE"
        ;;
    com.apple.finder.plist)
        defaults import com.apple.finder "$FILE"
        ;;
    com.apple.screencapture.plist)
        defaults import com.apple.screencapture "$FILE"
        ;;
    com.apple.spaces.plist)
        defaults import com.apple.spaces "$FILE"
        ;;
    com.apple.universalaccess.plist)
        defaults import com.apple.universalaccess "$FILE"
        ;;
    system.com.apple.AppleMultitouchTrackpad.plist)
        sudo defaults import /Library/Preferences/com.apple.AppleMultitouchTrackpad "$FILE"
        ;;
    system.GlobalPreferences.plist)
        sudo defaults import /Library/Preferences/.GlobalPreferences "$FILE"
        ;;
    system.com.apple.HIToolbox.plist)
        sudo defaults import /Library/Preferences/com.apple.HIToolbox "$FILE"
        ;;
    *)
        echo "Unknown plist file: $FILE"
        exit 1
        ;;
esac

echo "Refreshing affected services…"
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
killall cfprefsd 2>/dev/null || true

echo "Applied $FILE. Some prefs may need log out/in."
