# macOS Preference Export/Import

Scripts to export and reapply key macOS settings (trackpad, keyboard, Finder, Dock, etc.).  
Works per-domain using `defaults`; includes system (login window) input/trackpad settings.

## Files

- `export_mac_prefs.sh` — writes a set of `.plist` files to the current directory.
- `apply_mac_prefs.sh` — imports **all** `.plist` files it recognizes from a directory.

## Usage

### 1 Export on the source Mac

```bash
chmod +x export_mac_prefs.sh apply_mac_prefs.sh
./export_mac_prefs.sh
# Plists appear in the current directory
```

### 2 Transfer the .plist files

Copy the files to your new Mac (AirDrop, USB, git, etc.).

### 3 Apply on the target Mac

#### Run inside the directory containing the .plist files

```bash
./apply_mac_prefs.sh .
```

The apply script:
 • Detects known plist names and imports them to the right domains.
 • Automatically handles -currentHost imports and system-wide domains (prompts for sudo).
 • Restarts relevant services (Dock, Finder, SystemUIServer).

What’s covered
 • Trackpad (tap to click, gestures, right-click)
 • Scrolling direction (via NSGlobalDomain)
 • Keyboard input sources & repeat settings (com.apple.HIToolbox, NSGlobalDomain)
 • Finder preferences (com.apple.finder)
 • Dock, screenshots, Mission Control, accessibility tweaks

Not covered / caveats
 • Display scaling, Night Shift, and monitor layouts (hardware-specific, not reliably portable)
 • Security/Privacy items (FileVault, Full Disk Access, Touch ID)
 • Spotlight indexing and Finder tags (tags are stored in file metadata)
 • Some settings may require log out/in to take effect
