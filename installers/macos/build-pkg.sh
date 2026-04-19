#!/usr/bin/env bash
# Build GSBuilder.AI.pkg (installs gsbuilder-ai under /usr/local). Run on macOS from repo root.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
VERSION="$(grep -m1 'readonly VERSION=' gsbuilder-ai | sed -n 's/.*\"\(.*\)\".*/\1/p')"
IDENT="ai.gsbuilder.cli"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

bash scripts/build-all.sh

mkdir -p "$STAGE/usr/local/bin" "$STAGE/usr/local/share/gsbuilder-ai/brand"
cp gsbuilder-ai "$STAGE/usr/local/bin/"
chmod +x "$STAGE/usr/local/bin/gsbuilder-ai"
ln -sf gsbuilder-ai "$STAGE/usr/local/bin/gsbuilder.ai"
cp -R brand/* "$STAGE/usr/local/share/gsbuilder-ai/brand/"

mkdir -p dist/pkg
pkgbuild --root "$STAGE" \
  --identifier "$IDENT" \
  --version "$VERSION" \
  --install-location / \
  "dist/pkg/GSBuilder.AI-${VERSION}.pkg"

echo "Wrote dist/pkg/GSBuilder.AI-${VERSION}.pkg"
