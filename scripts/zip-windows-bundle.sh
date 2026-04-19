#!/usr/bin/env bash
# Build dist/GSBuilder.AI-windows-bundle-<ver>.zip (flat layout; run install-bundle.ps1 after unzip).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
VERSION="$(grep -m1 'readonly VERSION=' gsbuilder-ai | sed -n 's/.*\"\(.*\)\".*/\1/p')"
bash scripts/build-all.sh
ST="$(mktemp -d)"
trap 'rm -rf "$ST"' EXIT
mkdir -p "$ST/brand"
cp gsbuilder-ai gsbuilder.ai "$ST/" 2>/dev/null || { cp gsbuilder-ai "$ST/"; ln -sf gsbuilder-ai "$ST/gsbuilder.ai"; }
cp -R brand/* "$ST/brand/"
cp dist/windows/app.ico "$ST/app.ico"
cp installers/windows/gsbuilder-ai.cmd "$ST/"
cp installers/windows/install-bundle.ps1 "$ST/install.ps1"
OUT="dist/GSBuilder.AI-windows-bundle-${VERSION}.zip"
rm -f "$OUT"
( cd "$ST" && zip -q "$ROOT/$OUT" ./* ./*/* 2>/dev/null || zip -q "$ROOT/$OUT" -r . )
echo "Wrote $OUT (extract, then run: powershell -ExecutionPolicy Bypass -File install.ps1)"
