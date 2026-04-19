GSBUILDER.AI — iOS (Xcode)

Canonical brand (same as all platforms):
  brand/icon.svg

App Store / Xcode asset catalog (PNGs generated from the same source as icon.svg):
  dist/ios/AppIcon.appiconset/

Steps:
1. From repo root on macOS:
     bash scripts/build-all.sh
     python3 scripts/build-icons.py
2. In Xcode: open your app target → AppIcon → drag all images from dist/ios/AppIcon.appiconset into the slots, OR replace the target’s Assets.xcassets/AppIcon.appiconset with this folder (keep your asset catalog structure if needed).
3. Rebuild the iOS app.

Note: This repository ships a CLI launcher for desktop editors; the iOS assets are for a future or companion native app that shares the same gsbuilder.ai branding.
