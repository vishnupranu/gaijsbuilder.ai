# GSBUILDER.AI — local build check + install
PREFIX ?= $(HOME)/.local

.PHONY: check run install install-system uninstall icons pkg dmg winzip help

help:
	@echo "GSBUILDER.AI — targets:"
	@echo "  make check     — syntax-check gsbuilder-ai"
	@echo "  make run       — run launcher version (no editor exec)"
	@echo "  make install   — install to PREFIX (default: ~/.local)"
	@echo "  make install-system — install to /usr/local (may use sudo)"
	@echo "  make uninstall — remove from PREFIX"
	@echo "  make icons     — Python icon pipeline + macOS app.icns"
	@echo "  make pkg       — macOS .pkg (requires macOS)"
	@echo "  make dmg       — macOS .dmg (requires macOS)"
	@echo "  make winzip    — Windows zip bundle with icons + install.ps1"

check:
	bash -n gsbuilder-ai
	chmod +x gsbuilder-ai install.sh gsbuilder.ai

run: check
	./gsbuilder-ai version

install: check
	./install.sh --prefix=$(PREFIX) --auto

install-system: check
	./install.sh --system --auto

uninstall:
	./install.sh --uninstall --prefix=$(PREFIX)

icons:
	python3 scripts/build-icons.py
	@if [ "$$(uname -s)" = Darwin ]; then iconutil -c icns -o dist/mac/app.icns dist/mac/AppIcon.iconset; fi

pkg:
	bash installers/macos/build-pkg.sh

dmg:
	bash installers/macos/build-dmg.sh

winzip:
	bash scripts/zip-windows-bundle.sh
