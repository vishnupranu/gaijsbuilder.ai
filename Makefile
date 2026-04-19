# GSBUILDER.AI — local build check + install
PREFIX ?= $(HOME)/.local

.PHONY: check run install install-system uninstall help

help:
	@echo "GSBUILDER.AI — targets:"
	@echo "  make check     — syntax-check gsbuilder-ai"
	@echo "  make run       — run launcher version (no editor exec)"
	@echo "  make install   — install to PREFIX (default: ~/.local)"
	@echo "  make install-system — install to /usr/local (may use sudo)"
	@echo "  make uninstall — remove from PREFIX"

check:
	bash -n gsbuilder-ai
	chmod +x gsbuilder-ai install.sh

run: check
	./gsbuilder-ai version

install: check
	./install.sh --prefix=$(PREFIX) --auto

install-system: check
	./install.sh --system --auto

uninstall:
	./install.sh --uninstall --prefix=$(PREFIX)
