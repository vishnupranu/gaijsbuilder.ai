#!/usr/bin/env python3
"""Generate platform icons from brand/logo-mark.jpg (same source for all targets)."""
from __future__ import annotations

import json
import struct
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "brand" / "logo-mark.jpg"
DIST = ROOT / "dist"


def ensure_src() -> Image.Image:
    if not SRC.is_file():
        print(f"Missing source image: {SRC}", file=sys.stderr)
        sys.exit(1)
    im = Image.open(SRC).convert("RGBA")
    return im


def save_png(im: Image.Image, path: Path, size: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    out = im.resize((size, size), Image.Resampling.LANCZOS)
    out.save(path, format="PNG")


def write_ico(im: Image.Image, path: Path) -> None:
    """Multi-size ICO for Windows / Inno Setup (largest image first for Pillow)."""
    path.parent.mkdir(parents=True, exist_ok=True)
    sizes = [(256, 256), (64, 64), (48, 48), (32, 32), (24, 24), (16, 16)]
    images = [im.resize(s, Image.Resampling.LANCZOS) for s in sizes]
    images[0].save(
        path,
        format="ICO",
        sizes=sizes,
        append_images=images[1:],
    )


def write_mac_iconset(im: Image.Image, iconset: Path) -> None:
    """PNG set for iconutil -c icns (macOS)."""
    iconset.mkdir(parents=True, exist_ok=True)
    specs = [
        ("icon_16x16.png", 16),
        ("icon_16x16@2x.png", 32),
        ("icon_32x32.png", 32),
        ("icon_32x32@2x.png", 64),
        ("icon_128x128.png", 128),
        ("icon_128x128@2x.png", 256),
        ("icon_256x256.png", 256),
        ("icon_256x256@2x.png", 512),
        ("icon_512x512.png", 512),
        ("icon_512x512@2x.png", 1024),
    ]
    for name, dim in specs:
        save_png(im, iconset / name, dim)


def write_ios_appiconset(im: Image.Image, app_dir: Path) -> None:
    """Xcode AppIcon.appiconset (iphone + ipad + marketing)."""
    app_dir.mkdir(parents=True, exist_ok=True)
    entries: list[tuple[str, int, str, str | None, str]] = [
        ("AppIcon-20@2x.png", 40, "iphone", "20x20", "2x"),
        ("AppIcon-20@3x.png", 60, "iphone", "20x20", "3x"),
        ("AppIcon-29@2x.png", 58, "iphone", "29x29", "2x"),
        ("AppIcon-29@3x.png", 87, "iphone", "29x29", "3x"),
        ("AppIcon-40@2x.png", 80, "iphone", "40x40", "2x"),
        ("AppIcon-40@3x.png", 120, "iphone", "40x40", "3x"),
        ("AppIcon-60@2x.png", 120, "iphone", "60x60", "2x"),
        ("AppIcon-60@3x.png", 180, "iphone", "60x60", "3x"),
        ("AppIcon-20ipad.png", 20, "ipad", "20x20", "1x"),
        ("AppIcon-20@2xipad.png", 40, "ipad", "20x20", "2x"),
        ("AppIcon-29ipad.png", 29, "ipad", "29x29", "1x"),
        ("AppIcon-29@2xipad.png", 58, "ipad", "29x29", "2x"),
        ("AppIcon-40ipad.png", 40, "ipad", "40x40", "1x"),
        ("AppIcon-40@2xipad.png", 80, "ipad", "40x40", "2x"),
        ("AppIcon-76ipad.png", 76, "ipad", "76x76", "1x"),
        ("AppIcon-76@2xipad.png", 152, "ipad", "76x76", "2x"),
        ("AppIcon-83.5@2xipad.png", 167, "ipad", "83.5x83.5", "2x"),
        ("AppIcon-1024.png", 1024, "ios-marketing", None, "1x"),
    ]
    images_json = []
    for filename, px, idiom, size, scale in entries:
        save_png(im, app_dir / filename, px)
        row: dict[str, str] = {"filename": filename, "idiom": idiom, "scale": scale}
        if size is not None:
            row["size"] = size
        images_json.append(row)
    payload = {"images": images_json, "info": {"author": "gsbuilder", "version": 1}}
    (app_dir / "Contents.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")


def write_android_mipmaps(im: Image.Image, base: Path) -> None:
    """Standard launcher sizes (png)."""
    mapping = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, dim in mapping.items():
        d = base / folder
        d.mkdir(parents=True, exist_ok=True)
        save_png(im, d / "ic_launcher.png", dim)
        save_png(im, d / "ic_launcher_round.png", dim)


def main() -> None:
    im = ensure_src()
    DIST.mkdir(exist_ok=True)

    write_ico(im, DIST / "windows" / "app.ico")
    write_mac_iconset(im, DIST / "mac" / "AppIcon.iconset")
    write_ios_appiconset(im, DIST / "ios" / "AppIcon.appiconset")
    write_android_mipmaps(im, DIST / "android" / "res")

    # High-res marketing PNG (any platform)
    save_png(im, DIST / "gsbuilder-ai-1024.png", 1024)
    print("Wrote:", DIST / "windows" / "app.ico")
    print("Wrote:", DIST / "mac" / "AppIcon.iconset" / "(PNG set; run iconutil on macOS)")
    print("Wrote:", DIST / "ios" / "AppIcon.appiconset")
    print("Wrote:", DIST / "android" / "res" / "mipmap-*")
    print("Wrote:", DIST / "gsbuilder-ai-1024.png")


if __name__ == "__main__":
    main()
