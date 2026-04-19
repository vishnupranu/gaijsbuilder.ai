#!/usr/bin/env bash
# Build a drag-style DMG with the CLI bundle folder + Applications alias (macOS).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
VERSION="$(grep -m1 'readonly VERSION=' gsbuilder-ai | sed -n 's/.*\"\(.*\)\".*/\1/p')"
bash scripts/build-all.sh

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
VOL="GSBuilder.AI ${VERSION}"

mkdir -p "$STAGE/${VOL}"
cp gsbuilder-ai gsbuilder.ai "$STAGE/${VOL}/" 2>/dev/null || { cp gsbuilder-ai "$STAGE/${VOL}/"; ln -sf gsbuilder-ai "$STAGE/${VOL}/gsbuilder.ai"; }
chmod +x "$STAGE/${VOL}/gsbuilder-ai"
cp -R brand "$STAGE/${VOL}/"
if [[ -f dist/mac/app.icns ]]; then
  cp dist/mac/app.icns "$STAGE/${VOL}/"
fi
cat >"$STAGE/${VOL}/README-macos.txt" <<EOF
GSBUILDER.AI ${VERSION}

Drag the folder "GSBuilder.AI ${VERSION}" into /usr/local/ (merge) or run installers/macos/build-pkg.sh for a .pkg installer.

Then add to PATH:
  export PATH=/usr/local/bin:\$PATH

Run: gsbuilder.ai .
EOF
ln -sf /Applications "$STAGE/Applications"

mkdir -p dist/dmg
hdiutil create -volname "$VOL" -srcfolder "$STAGE" -ov -format UDZO "dist/dmg/GSBuilder.AI-macos-${VERSION}.dmg"
echo "Wrote dist/dmg/GSBuilder.AI-macos-${VERSION}.dmg"
