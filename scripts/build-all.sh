#!/usr/bin/env bash
# Build raster icons + macOS .icns (requires macOS + iconutil).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
python3 scripts/build-icons.py
if [[ "$(uname -s)" == "Darwin" ]]; then
  iconutil -c icns -o dist/mac/app.icns dist/mac/AppIcon.iconset
  echo "Built dist/mac/app.icns"
else
  echo "Skip iconutil (not macOS); copy .iconset to a Mac to build app.icns" >&2
fi
