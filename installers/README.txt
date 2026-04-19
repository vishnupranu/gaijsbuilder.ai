GSBUILDER.AI — multi-platform installers

Canonical brand (one SVG for all platforms, embedded raster):
  brand/icon.svg

Raster + platform layouts (build on any OS with Python 3 + Pillow; .icns needs macOS):
  bash scripts/build-all.sh
  python3 scripts/build-icons.py

macOS
  ./installers/macos/build-pkg.sh   → dist/pkg/GSBuilder.AI-<version>.pkg
  ./installers/macos/build-dmg.sh   → dist/dmg/GSBuilder.AI-macos-<version>.dmg
  ./install.sh --auto               → user-local CLI (existing)

Windows
  Zip bundle (flat; includes app.ico + same brand/icon.svg):
               bash scripts/zip-windows-bundle.sh
               → extract dist/GSBuilder.AI-windows-bundle-<ver>.zip, then:
               powershell -ExecutionPolicy Bypass -File install.ps1
  From a git clone (paths relative to repo):
               .\installers\windows\install.ps1
  Installer EXE (Windows + Inno Setup 6):
               iscc installers\windows\setup.iss

Android / iOS
  See installers/android/README.txt and installers/ios/README.txt
