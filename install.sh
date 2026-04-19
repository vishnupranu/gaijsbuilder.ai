#!/usr/bin/env bash
# GSBUILDER.AI — manual / unattended install (CLI launcher + brand assets).
#
# Not related to Adobe DNG SDK (raw image SDK). For macOS app bundles / DMG
# packaging, build a .dmg separately (create-dmg, Disk Utility); this script
# installs command-line files only.
set -euo pipefail

readonly ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${HOME}/.local"
AUTO=0
DO_UNINSTALL=0

usage() {
  cat <<'EOF'
GSBUILDER.AI install.sh

Usage:
  ./install.sh [--prefix DIR] [--auto|-y]
  ./install.sh --system             # PREFIX=/usr/local (may prompt for sudo)
  ./install.sh --uninstall [--prefix DIR]

Options:
  --prefix DIR   Install layout under DIR (default: ~/.local)
  --system       Same as --prefix=/usr/local
  --auto, -y     Non-interactive (skip confirmation)
  --uninstall    Remove gsbuilder-ai, gsbuilder.ai, and share data from PREFIX

After install (user scope), add to ~/.zshrc or ~/.bashrc if needed:
  export PATH="$HOME/.local/bin:$PATH"

One-line install from GitHub (when published on main):
  curl -fsSL https://raw.githubusercontent.com/vishnupranu/gaijsbuilder.ai/main/install.sh | bash -s -- --auto

EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prefix=*)
      PREFIX="${1#*=}"
      shift
      ;;
    --prefix)
      [[ $# -ge 2 ]] || {
        printf '%s\n' "install.sh: missing directory after --prefix" >&2
        exit 1
      }
      PREFIX="$2"
      shift 2
      ;;
    --system)
      PREFIX="/usr/local"
      shift
      ;;
    --auto|-y)
      AUTO=1
      shift
      ;;
    --uninstall)
      DO_UNINSTALL=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

BINDIR="$PREFIX/bin"
SHARE="$PREFIX/share/gsbuilder-ai"
SRC_BIN="$ROOT/gsbuilder-ai"
SRC_BRAND="$ROOT/brand"

run_uninstall() {
  rm -f "$BINDIR/gsbuilder-ai" "$BINDIR/gsbuilder.ai" 2>/dev/null || true
  rm -rf "$SHARE" 2>/dev/null || true
  printf 'Removed %s, %s, and %s\n' "$BINDIR/gsbuilder-ai" "$BINDIR/gsbuilder.ai" "$SHARE"
}

if [[ "$DO_UNINSTALL" -eq 1 ]]; then
  run_uninstall
  exit 0
fi

[[ -x "$SRC_BIN" || -f "$SRC_BIN" ]] || {
  printf 'Missing %s — run this script from the repository root.\n' "$SRC_BIN" >&2
  exit 1
}

if [[ "$AUTO" -eq 0 ]]; then
  printf 'Install GSBUILDER.AI to PREFIX=%s ? [y/N] ' "$PREFIX"
  read -r ans
  case "$ans" in
    y|Y|yes|YES) ;;
    *) printf 'Cancelled.\n'; exit 1 ;;
  esac
fi

install_files() {
  mkdir -p "$BINDIR" "$SHARE/brand"
  cp -f "$SRC_BIN" "$BINDIR/gsbuilder-ai"
  chmod +x "$BINDIR/gsbuilder-ai"
  ln -sf gsbuilder-ai "$BINDIR/gsbuilder.ai"
  if [[ -d "$SRC_BRAND" ]]; then
    cp -f "$SRC_BRAND"/* "$SHARE/brand/" 2>/dev/null || true
  fi
}

if [[ "$PREFIX" == "/usr/local" ]] && [[ ! -w "$PREFIX/bin" ]] 2>/dev/null; then
  sudo mkdir -p "$BINDIR" "$SHARE/brand"
  sudo cp -f "$SRC_BIN" "$BINDIR/gsbuilder-ai"
  sudo chmod +x "$BINDIR/gsbuilder-ai"
  sudo ln -sf gsbuilder-ai "$BINDIR/gsbuilder.ai"
  if [[ -d "$SRC_BRAND" ]]; then
    sudo cp -f "$SRC_BRAND"/* "$SHARE/brand/" 2>/dev/null || true
  fi
else
  install_files
fi

printf '\nInstalled:\n  %s\n  %s (symlink)\n  %s\n\n' "$BINDIR/gsbuilder-ai" "$BINDIR/gsbuilder.ai" "$SHARE/brand"
printf 'Ensure this directory is on your PATH:\n  %s\n' "$BINDIR"
if [[ "$PREFIX" == "${HOME}/.local" ]]; then
  printf '\nExample:\n  export PATH="%s:$PATH"\n' "$BINDIR"
fi
printf '\nTest:\n  gsbuilder-ai version\n  gsbuilder.ai version\n  gsbuilder-ai --help\n'
