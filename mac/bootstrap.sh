#!/usr/bin/env bash
set -euo pipefail

# Config Setup
REPO_URL="https://github.com/thiemohaller/public-dotfiles.git"
REPO_BRANCH="main"
SETUP_PATH="mac/setup.sh"

# ===
WORKDIR="$(mktemp -d)"
ARTIFACTS_TO_DELETE=()
cleanup() { rm -rf "$WORKDIR" >/dev/null 2>&1 || true; }
trap cleanup EXIT

echo "Fetching repo..."
REPO_DIR=""

if command -v git >/dev/null 2>&1; then
  git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" "$WORKDIR/repo"
  REPO_DIR="$WORKDIR/repo"
else
  echo "git not found; falling back to tarball."
  # GitHub-only tarball URL; adjust if not GitHub
  TAR_URL="${REPO_URL%.git}/archive/refs/heads/${REPO_BRANCH}.tar.gz"
  curl -fsSL "$TAR_URL" -o "$WORKDIR/repo.tar.gz"
  tar -xzf "$WORKDIR/repo.tar.gz" -C "$WORKDIR"
  REPO_DIR="$(find "$WORKDIR" -maxdepth 1 -type d -name "*-${REPO_BRANCH}" | head -n1)"
  ARTIFACTS_TO_DELETE+=("$WORKDIR/repo.tar.gz")
fi

# Run setup
cd "$REPO_DIR"
if [[ ! -f "$SETUP_PATH" ]]; then
  echo "Error: $SETUP_PATH not found in repo." >&2
  exit 1
fi
chmod +x "$SETUP_PATH"
bash "$SETUP_PATH"

# Prompt for cleanup
read -r -p "Clean up the downloaded repo files? [y/N]: " ANSW
case "${ANSW:-}" in
  y|Y)
    cd ~
    rm -rf "$REPO_DIR" "${ARTIFACTS_TO_DELETE[@]}" || true
    echo "Cleaned."
    ;;
  *) echo "Left files at: $REPO_DIR" ;;
esac
