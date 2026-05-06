#!/usr/bin/env bash
# OS-aware URL opener. Usage: bash scripts/open-url.sh <url>
# Always exits 0 — auto-open is a UX bonus, the agent should still print
# the URL in chat as the canonical delivery.

set -u
URL="${1:-}"
[ -z "$URL" ] && { echo "Usage: $0 <url>" >&2; exit 2; }

try() { command -v "$1" >/dev/null 2>&1 && "$@" >/dev/null 2>&1 & disown; }

case "$(uname -s 2>/dev/null)" in
  Darwin)
    try open "$URL" && exit 0 ;;
  Linux)
    if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
      try wslview "$URL" && exit 0
      try cmd.exe /c start "$URL" && exit 0
    fi
    for opener in xdg-open gio gnome-open kde-open; do
      try "$opener" "$URL" && exit 0
    done ;;
  CYGWIN*|MINGW*|MSYS*)
    try cmd.exe /c start "" "$URL" && exit 0
    try powershell.exe -Command "Start-Process '$URL'" && exit 0 ;;
esac

echo "Could not auto-open. URL: $URL" >&2
exit 0
