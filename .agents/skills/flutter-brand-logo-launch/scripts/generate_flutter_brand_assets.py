#!/usr/bin/env python3
"""
Nikahin App - Automated Brand Logo & Multi-Platform Icon Generator
Mengekspor seluruh varian SVG ke PNG resolusi tinggi dan memperbarui ikon launcher untuk semua platform:
- Android (Adaptive & Legacy mipmaps)
- iOS (Apple xcassets)
- Windows (.ico multi-size)
- macOS (xcassets)
- Web (Favicon, Apple touch icon, PWA icons)
- Welcome Screen / Onboarding illustrations (SVG ke PNG)
"""

import os
import sys
import json
import shutil
from PIL import Image

sys.dont_write_bytecode = True

# Path resolution
SKILL_DIR = os.path.dirname(os.path.abspath(__file__))
candidate = os.path.abspath(os.path.join(SKILL_DIR, "..", "..", "..", ".."))
WORKSPACE = candidate if os.path.exists(os.path.join(candidate, "pubspec.yaml")) else os.path.abspath(".")
LOGO_DESIGN_SCRIPTS = os.path.join(WORKSPACE, ".agents", "skills", "logo-design", "scripts")
if LOGO_DESIGN_SCRIPTS not in sys.path:
    sys.path.insert(0, LOGO_DESIGN_SCRIPTS)

try:
    import render_png
except ImportError:
    print("Error: render_png module not found. Pastikan skill logo-design terinstall.")
    sys.exit(1)

SVG_DIR = os.path.join(WORKSPACE, "assets", "logo", "svg")
PNG_DIR = os.path.join(WORKSPACE, "assets", "logo", "png")
APP_ICON_DIR = os.path.join(WORKSPACE, "assets", "logo", "app_icon")
ILLUSTRATIONS_DIR = os.path.join(WORKSPACE, "assets", "illustrations")
IMAGES_DIR = os.path.join(WORKSPACE, "assets", "images")

os.makedirs(PNG_DIR, exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "ios"), exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "android"), exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "web"), exist_ok=True)
os.makedirs(IMAGES_DIR, exist_ok=True)

def main():
    print("[1/7] Merender master SVG logo ke resolusi tinggi (PNG)...")
    tasks = [
        ("nikahin-symbol-master.svg", "nikahin-symbol-master.png", 1024, 1024),
        ("nikahin-symbol-black.svg", "nikahin-symbol-black.png", 1024, 1024),
        ("nikahin-symbol-white.svg", "nikahin-symbol-white.png", 1024, 1024),
        ("nikahin-lockup-horizontal.svg", "nikahin-lockup-horizontal.png", 1200, 400),
        ("nikahin-lockup-horizontal-dark.svg", "nikahin-lockup-horizontal-dark.png", 1200, 400),
        ("nikahin-lockup-stacked.svg", "nikahin-lockup-stacked.png", 600, 680),
        ("nikahin-lockup-stacked-dark.svg", "nikahin-lockup-stacked-dark.png", 600, 680),
        ("nikahin-app-icon.svg", "nikahin-app-icon.png", 1024, 1024),
        ("nikahin-app-icon-fg.svg", "nikahin-app-icon-fg.png", 512, 512),
        ("nikahin-app-icon-bg.svg", "nikahin-app-icon-bg.png", 512, 512),
    ]

    for svg_name, png_name, w, h in tasks:
        svg_path = os.path.join(SVG_DIR, svg_name)
        png_path = os.path.join(PNG_DIR, png_name)
        if os.path.exists(svg_path):
            print(f"  -> Rendering logo: {svg_name} ({w}x{h})...")
            render_png.render(svg_path, png_path, width=w, height=h)
        else:
            print(f"  -> Melewati {svg_name} (file tidak ditemukan).")

    # Generate 512px symbols
    for base in ["nikahin-symbol-master", "nikahin-symbol-black", "nikahin-symbol-white"]:
        src_p = os.path.join(PNG_DIR, f"{base}.png")
        if os.path.exists(src_p):
            src_img = Image.open(src_p)
            img_512 = src_img.resize((512, 512), Image.Resampling.LANCZOS)
            img_512.save(os.path.join(PNG_DIR, f"{base}-512.png"))

    print("[2/7] Merender ilustrasi vektor Welcome Screen (SVG -> PNG)...")
    welcome_slides = [
        ("welcome_slide_1.svg", "welcome_slide_1.png", 512, 512),
        ("welcome_slide_2.svg", "welcome_slide_2.png", 512, 512),
        ("welcome_slide_3.svg", "welcome_slide_3.png", 512, 512),
    ]
    for svg_name, png_name, w, h in welcome_slides:
        svg_p = os.path.join(ILLUSTRATIONS_DIR, svg_name)
        png_p = os.path.join(IMAGES_DIR, png_name)
        if os.path.exists(svg_p):
            print(f"  -> Rendering welcome slide: {svg_name} ({w}x{h})...")
            render_png.render(svg_p, png_p, width=w, height=h)
        else:
            print(f"  -> Melewati ilustrasi {svg_name} (file tidak ditemukan).")

    master_icon_path = os.path.join(PNG_DIR, "nikahin-app-icon.png")
    if not os.path.exists(master_icon_path):
        print("Error: Master icon nikahin-app-icon.png tidak ditemukan!")
        return

    master_icon = Image.open(master_icon_path).convert("RGBA")

    print("[3/7] Memperbarui aset iOS AppIcon (xcassets)...")
    ios_1024 = Image.new("RGB", (1024, 1024), (253, 242, 233))  # Warm Champagne Solid
    ios_1024.paste(master_icon, (0, 0), master_icon)
    ios_1024.save(os.path.join(APP_ICON_DIR, "ios", "icon-1024.png"), quality=95)

    ios_xcassets = os.path.join(WORKSPACE, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")
    contents_json_path = os.path.join(ios_xcassets, "Contents.json")
    if os.path.exists(contents_json_path):
        with open(contents_json_path, "r", encoding="utf-8") as f:
            meta = json.load(f)
        for entry in meta.get("images", []):
            filename = entry.get("filename")
            if not filename:
                continue
            size_str = entry.get("size", "20x20")
            scale_str = entry.get("scale", "1x")
            base_size = float(size_str.split("x")[0])
            scale = float(scale_str.replace("x", ""))
            target_px = int(round(base_size * scale))

            target_img = ios_1024.resize((target_px, target_px), Image.Resampling.LANCZOS)
            target_img.save(os.path.join(ios_xcassets, filename))
            target_img.save(os.path.join(APP_ICON_DIR, "ios", filename))

    print("[4/7] Memperbarui aset Android mipmap (Adaptive & Legacy)...")
    android_sizes = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
    fg_adaptive_sizes = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}

    fg_p = os.path.join(PNG_DIR, "nikahin-app-icon-fg.png")
    bg_p = os.path.join(PNG_DIR, "nikahin-app-icon-bg.png")
    if os.path.exists(fg_p) and os.path.exists(bg_p):
        fg_img = Image.open(fg_p).convert("RGBA")
        bg_img = Image.open(bg_p).convert("RGBA")
        res_dir = os.path.join(WORKSPACE, "android", "app", "src", "main", "res")

        for density, px in android_sizes.items():
            folder = os.path.join(res_dir, f"mipmap-{density}")
            os.makedirs(folder, exist_ok=True)
            legacy = master_icon.resize((px, px), Image.Resampling.LANCZOS)
            legacy.save(os.path.join(folder, "ic_launcher.png"))

        for density, px in fg_adaptive_sizes.items():
            folder = os.path.join(res_dir, f"mipmap-{density}")
            os.makedirs(folder, exist_ok=True)
            fg_img.resize((px, px), Image.Resampling.LANCZOS).save(os.path.join(folder, "ic_launcher_foreground.png"))
            bg_img.resize((px, px), Image.Resampling.LANCZOS).save(os.path.join(folder, "ic_launcher_background.png"))

    print("[5/7] Memperbarui aset Windows App Icon (resources/app_icon.ico)...")
    win_res = os.path.join(WORKSPACE, "windows", "runner", "resources")
    if os.path.exists(win_res):
        win_ico_path = os.path.join(win_res, "app_icon.ico")
        master_icon.save(
            win_ico_path,
            format="ICO",
            sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
        )
        print(f"  -> Windows app_icon.ico diperbarui ({win_ico_path})")

    print("[6/7] Memperbarui aset macOS AppIcon (xcassets)...")
    macos_xcassets = os.path.join(WORKSPACE, "macos", "Runner", "Assets.xcassets", "AppIcon.appiconset")
    macos_json_path = os.path.join(macos_xcassets, "Contents.json")
    if os.path.exists(macos_json_path):
        with open(macos_json_path, "r", encoding="utf-8") as f:
            macos_meta = json.load(f)
        for entry in macos_meta.get("images", []):
            filename = entry.get("filename")
            if not filename:
                continue
            size_str = entry.get("size", "16x16")
            scale_str = entry.get("scale", "1x")
            base_size = float(size_str.split("x")[0])
            scale = float(scale_str.replace("x", ""))
            target_px = int(round(base_size * scale))

            target_img = master_icon.resize((target_px, target_px), Image.Resampling.LANCZOS)
            target_img.save(os.path.join(macos_xcassets, filename))
        print("  -> macOS AppIcon.appiconset berhasil disinkronkan.")

    print("[7/7] Membangun paket Web Favicon & PWA Suite (web/ & assets/logo/app_icon/web/)...")
    web_app_icon_dir = os.path.join(APP_ICON_DIR, "web")
    web_dir = os.path.join(WORKSPACE, "web")
    web_icons_dir = os.path.join(web_dir, "icons")
    os.makedirs(web_icons_dir, exist_ok=True)

    # 1. Favicon multi-size ICO
    master_icon.save(
        os.path.join(web_app_icon_dir, "favicon.ico"),
        format="ICO",
        sizes=[(16, 16), (32, 32), (48, 48)],
    )
    if os.path.exists(web_dir):
        master_icon.resize((32, 32), Image.Resampling.LANCZOS).save(os.path.join(web_dir, "favicon.png"))
        master_icon.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, "Icon-192.png"))
        master_icon.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, "Icon-512.png"))
        master_icon.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, "Icon-maskable-192.png"))
        master_icon.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, "Icon-maskable-512.png"))

    # 2. Web metadata folder
    master_icon.resize((16, 16), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon_dir, "favicon-16x16.png"))
    master_icon.resize((32, 32), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon_dir, "favicon-32x32.png"))
    master_icon.resize((48, 48), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon_dir, "favicon-48x48.png"))
    master_icon.resize((180, 180), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon_dir, "apple-touch-icon.png"))
    master_icon.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon_dir, "android-chrome-192x192.png"))
    master_icon.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon_dir, "android-chrome-512x512.png"))

    print("\n✨ SUKSES BESAR! Seluruh aset brand, logo, ikon multi-platform (Android, iOS, Windows, macOS, Web), dan Welcome Screen berhasil disinkronkan!")

if __name__ == "__main__":
    main()
