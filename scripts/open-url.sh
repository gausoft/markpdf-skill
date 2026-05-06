#!/usr/bin/env bash
# open-url.sh — OS-aware URL opener for the MarkPDF skill.
#
# Usage:
#   bash scripts/open-url.sh "https://markpdf.app/d/abc123"
#
# Detects the host OS and runs the right command:
#   - macOS    → open
#   - Linux    → xdg-open (GNOME/KDE/etc.)
#   - WSL      → wslview, fallback cmd.exe
#   - Windows  → start (cmd) or Start-Process (PowerShell)
#
# Exits 0 on success OR if no opener is available (so the agent doesn't
# error out in headless environments). The agent should always present
# the URL in the reply too — auto-open is a UX bonus, not a requirement.

set -u

URL="${1:-}"
if [ -z "$URL" ]; then
  echo "Usage: $0 <url>" >&2
  exit 2
fi

OS="$(uname -s 2>/dev/null || echo unknown)"

open_with() {
  command -v "$1" >/dev/null 2>&1 || return 1
  "$@" >/dev/null 2>&1 &
  return 0
}

case "$OS" in
  Darwin)
    open_with open "$URL" && exit 0
    ;;
  Linux)
    # WSL detection
    if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
      open_with wslview "$URL" && exit 0
      open_with cmd.exe /c start "$URL" && exit 0
    fi
    open_with xdg-open "$URL" && exit 0
    open_with gio open "$URL" && exit 0
    open_with gnome-open "$URL" && exit 0
    open_with kde-open "$URL" && exit 0
    ;;
  CYGWIN*|MINGW*|MSYS*)
    open_with cmd.exe /c start "" "$URL" && exit 0
    open_with powershell.exe -Command "Start-Process '$URL'" && exit 0
    ;;
esac

# Last-ditch fallback: just print the URL. The agent should already have
# shown it in the chat, so this is purely informational.
echo "Could not auto-open. URL: $URL" >&2
exit 0
