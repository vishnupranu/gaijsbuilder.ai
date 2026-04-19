GSBUILDER.AI — Android (Android Studio)

The canonical brand asset is the same SVG used everywhere:
  brand/icon.svg

Raster launcher icons (generated from the same source JPEG as icon.svg):
  dist/android/res/mipmap-*/ic_launcher.png
  dist/android/res/mipmap-*/ic_launcher_round.png

Steps:
1. On a dev machine with Python 3 + Pillow: from repo root run
     bash scripts/build-all.sh
   (or: python3 scripts/build-icons.py)
2. In Android Studio, copy the folder
     dist/android/res/mipmap-mdpi … mipmap-xxxhdpi
   into your module’s src/main/res/ (merge mipmaps).
3. In AndroidManifest.xml set android:icon="@mipmap/ic_launcher" and roundIcon if desired.

Optional: embed brand/icon.svg in WebView or use Android Studio Vector Asset import if you convert SVG to Android Vector Drawable separately.
