# Migrating Zen Browser Profile on macOS

Zen Browser (like Firefox) stores its setup in a **profile folder**, not in macOS defaults.  
Migrating the profile ensures sidebar customizations, toolbar layout, extensions, and advanced settings are preserved.

---

## 1. Locate Your Profile
Profiles are stored under:

```bash
\~/Library/Application Support/zen/Profiles/
```

You will see one or more folders named like:

```bash
abcdefgh.default
```

(`abcdefgh` is a random string).

---

## 2. Backup / Export
1. Quit Zen Browser completely.
2. Copy your profile folder to a safe place:

```bash
cp -R ~/Library/Application\ Support/zen/Profiles/*.default ~/zen-profile-backup
````

This copies all preferences, extensions, and UI customizations.

---

## 3. Restore / Import on Another Mac

1. Install Zen Browser on the new Mac and run it once to generate a profile folder.
2. Quit Zen Browser.
3. Copy your backup contents into the new profile folder:

```bash
cp -R ~/zen-profile-backup/* ~/Library/Application\ Support/zen/Profiles/<newprofile>.default/
```

Replace `<newprofile>.default` with the actual folder name created on the new Mac.

---

## 4. What Transfers

* ✅ Toolbar layout & sidebar customization
* ✅ Extensions and their settings
* ✅ All `about:config` tweaks
* ✅ Search engines, handlers, etc.

## 5. What Does Not Transfer

* ❌ Saved logins & passwords (encrypted with your macOS Keychain)
* ❌ Cache and session data (safe to exclude anyway)

---

## 6. Tips

* To selectively restore only settings, focus on these files:

  * `prefs.js` → all preferences
  * `xulstore.json` → window/sidebar layout
  * `extensions/` → installed add-ons
  * `chrome/` → custom CSS (if you use it)

* For automation, you can wrap the copy commands in your setup scripts.

```
