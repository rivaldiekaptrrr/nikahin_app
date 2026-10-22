#!/usr/bin/env python3
"""
Nikahin App - Complete Brand Logo Launch v2 Generator
Generates all master PNGs, lockups, onboarding illustration, and multi-platform icons (Android, iOS, Windows, macOS, Web).
"""

import os
import sys
import json
import base64
import numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter

WORKSPACE = r"c:\Rivaldi\nikahin_app"
PNG_DIR = os.path.join(WORKSPACE, "assets", "logo", "png")
SVG_DIR = os.path.join(WORKSPACE, "assets", "logo", "svg")
APP_ICON_DIR = os.path.join(WORKSPACE, "assets", "logo", "app_icon")
IMAGES_DIR = os.path.join(WORKSPACE, "assets", "images")
ILLUSTRATIONS_DIR = os.path.join(WORKSPACE, "assets", "illustrations")

os.makedirs(PNG_DIR, exist_ok=True)
os.makedirs(SVG_DIR, exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "ios"), exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "android"), exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "web"), exist_ok=True)
os.makedirs(IMAGES_DIR, exist_ok=True)

# 1. Colors
DEEP_WINE = (139, 32, 74)       # #8B204A
DEEP_WINE_DARK = (74, 19, 40)   # #4A1328
CHAMPAGNE_BG = (253, 242, 233)  # #FDF2E9
CREAM_TEXT = (255, 243, 223)    # #FFF3DF
GOLD_TAGLINE = (212, 175, 55)   # #D4AF37
GOLD_ACCENT = (170, 119, 28)    # #AA771C

# Font loading
FONT_DIR = r"C:\Windows\Fonts"
try:
    FONT_TITLE_LARGE = ImageFont.truetype(os.path.join(FONT_DIR, "georgiab.ttf"), 96)
    FONT_TAGLINE_LARGE = ImageFont.truetype(os.path.join(FONT_DIR, "seguisb.ttf"), 24)
    FONT_TITLE_MED = ImageFont.truetype(os.path.join(FONT_DIR, "georgiab.ttf"), 54)
    FONT_TAGLINE_MED = ImageFont.truetype(os.path.join(FONT_DIR, "seguisb.ttf"), 16)
except Exception:
    FONT_TITLE_LARGE = ImageFont.load_default()
    FONT_TAGLINE_LARGE = ImageFont.load_default()
    FONT_TITLE_MED = ImageFont.load_default()
    FONT_TAGLINE_MED = ImageFont.load_default()

def get_clean_emblem_rgba():
    """Extract clean 2048x2048 emblem with transparent alpha."""
    nobg = np.array(Image.open(os.path.join(WORKSPACE, "logonobg.jpg"))).astype(float)
    withbg = np.array(Image.open(os.path.join(WORKSPACE, "logowithbg.jpg"))).astype(float)
    
    sat = np.max(nobg, axis=-1) - np.min(nobg, axis=-1)
    alpha = np.clip((sat - 4.0) / (18.0 - 4.0), 0.0, 1.0)
    
    mask_im = Image.fromarray((alpha * 255).astype(np.uint8), mode='L')
    mask_im = mask_im.filter(ImageFilter.GaussianBlur(radius=0.7))
    alpha_smooth = np.array(mask_im).astype(float) / 255.0
    
    B = np.array([139.0, 32.0, 74.0])
    rgb = withbg.copy()
    unblend_mask = (alpha_smooth > 0.05) & (alpha_smooth < 0.98)
    for c in range(3):
        unblended = (rgb[:, :, c] - (1.0 - alpha_smooth) * B[c]) / np.maximum(alpha_smooth, 0.05)
        rgb[:, :, c] = np.where(unblend_mask, np.clip(unblended, 0, 255), rgb[:, :, c])
        
    rgba = np.dstack([rgb, alpha_smooth * 255]).astype(np.uint8)
    emblem_full = Image.fromarray(rgba, mode='RGBA')
    
    # Crop to non-transparent bounding box
    bbox = emblem_full.getbbox()
    cropped = emblem_full.crop(bbox)
    
    # Make square with 4% padding around the emblem
    w, h = cropped.size
    side = int(max(w, h) * 1.08)
    sq = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    offset = ((side - w) // 2, (side - h) // 2 - int(side * 0.01)) # slight optical dy
    sq.paste(cropped, offset, cropped)
    return sq

def create_monochrome_variant(emblem_rgba, color_rgb):
    """Create solid color silhouette keeping original alpha."""
    r, g, b = color_rgb
    arr = np.array(emblem_rgba)
    alpha = arr[:, :, 3]
    out_arr = np.zeros_like(arr)
    out_arr[:, :, 0] = r
    out_arr[:, :, 1] = g
    out_arr[:, :, 2] = b
    out_arr[:, :, 3] = alpha
    return Image.fromarray(out_arr, mode="RGBA")

def build_horizontal_lockup(emblem_rgba, dark=False):
    canvas = Image.new("RGBA", (1200, 400), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    
    if dark:
        # Rounded plate with deep wine dark plate
        draw.rounded_rectangle([20, 20, 1180, 380], radius=36, fill=DEEP_WINE_DARK, outline=(139, 32, 74), width=3)
    
    # Emblem at left: 260x260
    emblem_thumb = emblem_rgba.resize((260, 260), Image.Resampling.LANCZOS)
    canvas.paste(emblem_thumb, (70, 70), emblem_thumb)
    
    # Text on right
    title_text = "Nikahin"
    tagline_text = "W E D D I N G   P L A N N E R"
    
    title_color = CREAM_TEXT if dark else DEEP_WINE_DARK
    tagline_color = (255, 215, 158) if dark else GOLD_ACCENT
    
    draw.text((370, 105), title_text, font=FONT_TITLE_LARGE, fill=title_color)
    draw.text((375, 235), tagline_text, font=FONT_TAGLINE_LARGE, fill=tagline_color)
    return canvas

def build_stacked_lockup(emblem_rgba, dark=False):
    canvas = Image.new("RGBA", (600, 680), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    
    if dark:
        draw.rounded_rectangle([15, 15, 585, 665], radius=32, fill=DEEP_WINE_DARK, outline=(139, 32, 74), width=3)
        
    # Emblem centered top: 300x300
    emblem_thumb = emblem_rgba.resize((300, 300), Image.Resampling.LANCZOS)
    canvas.paste(emblem_thumb, (150, 60), emblem_thumb)
    
    title_text = "Nikahin"
    tagline_text = "W E D D I N G   P L A N N E R"
    title_color = CREAM_TEXT if dark else DEEP_WINE_DARK
    tagline_color = (255, 215, 158) if dark else GOLD_ACCENT
    
    # Center title
    bbox_t = draw.textbbox((0, 0), title_text, font=FONT_TITLE_MED)
    tw = bbox_t[2] - bbox_t[0]
    draw.text(((600 - tw) // 2, 400), title_text, font=FONT_TITLE_MED, fill=title_color)
    
    bbox_tag = draw.textbbox((0, 0), tagline_text, font=FONT_TAGLINE_MED)
    tagw = bbox_tag[2] - bbox_tag[0]
    draw.text(((600 - tagw) // 2, 480), tagline_text, font=FONT_TAGLINE_MED, fill=tagline_color)
    return canvas

def build_welcome_slide_1(emblem_rgba):
    """Render welcome_slide_1.png (512x512) matching wedding plate aesthetic."""
    canvas = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    
    # 1. Main circular plate
    plate_rect = [26, 26, 486, 486]
    # Create soft gradient saucer
    saucer = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(saucer)
    s_draw.ellipse(plate_rect, fill=(253, 243, 231, 255), outline=(212, 175, 55, 255), width=4)
    # Dashed outer orbit
    s_draw.ellipse([14, 14, 498, 498], outline=(232, 213, 190, 180), width=2)
    # Inner gold ring
    s_draw.ellipse([48, 48, 464, 464], outline=(240, 220, 186, 120), width=1)
    
    # Ambient glow
    s_draw.ellipse([126, 120, 386, 380], fill=(254, 239, 216, 160))
    
    canvas = Image.alpha_composite(canvas, saucer)
    
    # 2. Place emblem in center (280x280) with slight drop shadow
    emblem_size = 280
    emb_thumb = emblem_rgba.resize((emblem_size, emblem_size), Image.Resampling.LANCZOS)
    
    # Drop shadow
    shadow = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    shadow_mask = Image.fromarray(np.array(emb_thumb)[:, :, 3], mode='L')
    shadow_layer = Image.new("RGBA", (emblem_size, emblem_size), (139, 32, 74, 90))
    shadow.paste(shadow_layer, ((512 - emblem_size) // 2, (512 - emblem_size) // 2 + 10), shadow_mask)
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=8))
    
    canvas = Image.alpha_composite(canvas, shadow)
    canvas.paste(emb_thumb, ((512 - emblem_size) // 2, (512 - emblem_size) // 2 - 4), emb_thumb)
    
    # 3. Gold sparkles
    draw = ImageDraw.Draw(canvas)
    def draw_sparkle(cx, cy, r, color=(212, 175, 55, 230)):
        draw.polygon([(cx, cy - r), (cx + r//3, cy), (cx, cy + r), (cx - r//3, cy)], fill=color)
        draw.polygon([(cx - r, cy), (cx, cy + r//3), (cx + r, cy), (cx, cy - r//3)], fill=color)
        draw.ellipse([cx-1, cy-1, cx+1, cy+1], fill=(255, 255, 255, 255))
        
    draw_sparkle(105, 120, 16)
    draw_sparkle(410, 130, 18)
    draw_sparkle(95, 360, 13)
    draw_sparkle(405, 370, 14)
    return canvas

def main():
    print("[1/6] Mengambil & mengisolasi master lambang cinta-tangan transparan murni...")
    emblem = get_clean_emblem_rgba()
    
    # Simpan master 1024 dan 512
    m1024 = emblem.resize((1024, 1024), Image.Resampling.LANCZOS)
    m1024.save(os.path.join(PNG_DIR, "nikahin-symbol-master.png"))
    m512 = emblem.resize((512, 512), Image.Resampling.LANCZOS)
    m512.save(os.path.join(PNG_DIR, "nikahin-symbol-master-512.png"))
    print("  -> nikahin-symbol-master.png (1024 & 512 px) disimpan.")
    
    # Simbol Hitam & Putih solid (Monokrom)
    black_sym = create_monochrome_variant(m1024, (0, 0, 0))
    black_sym.save(os.path.join(PNG_DIR, "nikahin-symbol-black.png"))
    black_sym.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(PNG_DIR, "nikahin-symbol-black-512.png"))
    
    white_sym = create_monochrome_variant(m1024, (255, 255, 255))
    white_sym.save(os.path.join(PNG_DIR, "nikahin-symbol-white.png"))
    white_sym.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(PNG_DIR, "nikahin-symbol-white-512.png"))
    print("  -> Varian monokrom (black & white) disimpan.")
    
    print("[2/6] Membangun Lockup Horizontal & Stacked (Light & Dark)...")
    build_horizontal_lockup(m512, dark=False).save(os.path.join(PNG_DIR, "nikahin-lockup-horizontal.png"))
    build_horizontal_lockup(m512, dark=True).save(os.path.join(PNG_DIR, "nikahin-lockup-horizontal-dark.png"))
    build_stacked_lockup(m512, dark=False).save(os.path.join(PNG_DIR, "nikahin-lockup-stacked.png"))
    build_stacked_lockup(m512, dark=True).save(os.path.join(PNG_DIR, "nikahin-lockup-stacked-dark.png"))
    print("  -> Seluruh file lockup tersimpan.")
    
    print("[3/6] Membangun Ikon Aplikasi Master & Lapisan Adaptive (Opsi 1: Deep Wine)...")
    # Master App Icon 1024x1024 (Solid RGB Deep Wine #8B204A)
    app_icon_1024 = Image.new("RGB", (1024, 1024), DEEP_WINE)
    # Emblem scaled to 780x780 (centered, dy = -15)
    emblem_app = emblem.resize((780, 780), Image.Resampling.LANCZOS)
    app_icon_1024.paste(emblem_app, ((1024 - 780) // 2, (1024 - 780) // 2 - 15), emblem_app)
    app_icon_1024.save(os.path.join(PNG_DIR, "nikahin-app-icon.png"), quality=95)
    app_icon_1024.save(os.path.join(APP_ICON_DIR, "ios", "icon-1024.png"), quality=95)
    
    # Android Adaptive: safe zone 66% (circle diameter 338 in 512 canvas)
    # We fit emblem into 330x330
    fg_canvas = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    fg_emblem = emblem.resize((326, 326), Image.Resampling.LANCZOS)
    fg_canvas.paste(fg_emblem, ((512 - 326) // 2, (512 - 326) // 2 - 6), fg_emblem)
    fg_canvas.save(os.path.join(PNG_DIR, "nikahin-app-icon-fg.png"))
    
    bg_canvas = Image.new("RGBA", (512, 512), (*DEEP_WINE, 255))
    bg_canvas.save(os.path.join(PNG_DIR, "nikahin-app-icon-bg.png"))
    print("  -> Master app-icon, foreground adaptive, dan background adaptive siap.")
    
    print("[4/6] Memperbarui Welcome Screen Onboarding Slide 1...")
    welcome_1 = build_welcome_slide_1(m512)
    welcome_1.save(os.path.join(IMAGES_DIR, "welcome_slide_1.png"))
    print("  -> assets/images/welcome_slide_1.png diperbarui.")
    
    print("[5/6] Mendistribusikan Ikon ke Semua Platform...")
    # iOS xcassets
    ios_xcassets = os.path.join(WORKSPACE, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")
    contents_json = os.path.join(ios_xcassets, "Contents.json")
    if os.path.exists(contents_json):
        with open(contents_json, "r", encoding="utf-8") as f:
            meta = json.load(f)
        for entry in meta.get("images", []):
            filename = entry.get("filename")
            if not filename:
                continue
            base_size = float(entry.get("size", "20x20").split("x")[0])
            scale = float(entry.get("scale", "1x").replace("x", ""))
            px = int(round(base_size * scale))
            target_img = app_icon_1024.resize((px, px), Image.Resampling.LANCZOS)
            target_img.save(os.path.join(ios_xcassets, filename))
            target_img.save(os.path.join(APP_ICON_DIR, "ios", filename))
        print("  -> iOS AppIcon.appiconset selesai disinkronkan.")
        
    # Android mipmaps
    res_dir = os.path.join(WORKSPACE, "android", "app", "src", "main", "res")
    android_legacy = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
    android_fg = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}
    for density, px in android_legacy.items():
        folder = os.path.join(res_dir, f"mipmap-{density}")
        os.makedirs(folder, exist_ok=True)
        app_icon_1024.resize((px, px), Image.Resampling.LANCZOS).save(os.path.join(folder, "ic_launcher.png"))
    for density, px in android_fg.items():
        folder = os.path.join(res_dir, f"mipmap-{density}")
        fg_canvas.resize((px, px), Image.Resampling.LANCZOS).save(os.path.join(folder, "ic_launcher_foreground.png"))
        bg_canvas.resize((px, px), Image.Resampling.LANCZOS).save(os.path.join(folder, "ic_launcher_background.png"))
    print("  -> Android mipmaps (Adaptive & Legacy) selesai disinkronkan.")
    
    # Windows Desktop ICO
    win_res = os.path.join(WORKSPACE, "windows", "runner", "resources")
    if os.path.exists(win_res):
        win_ico = os.path.join(win_res, "app_icon.ico")
        app_icon_1024.save(win_ico, format="ICO", sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
        print("  -> Windows app_icon.ico selesai diperbarui.")
        
    # macOS xcassets
    macos_xcassets = os.path.join(WORKSPACE, "macos", "Runner", "Assets.xcassets", "AppIcon.appiconset")
    if os.path.exists(macos_xcassets):
        macos_json = os.path.join(macos_xcassets, "Contents.json")
        if os.path.exists(macos_json):
            with open(macos_json, "r", encoding="utf-8") as f:
                macos_meta = json.load(f)
            for entry in macos_meta.get("images", []):
                filename = entry.get("filename")
                if not filename:
                    continue
                base_size = float(entry.get("size", "16x16").split("x")[0])
                scale = float(entry.get("scale", "1x").replace("x", ""))
                px = int(round(base_size * scale))
                app_icon_1024.resize((px, px), Image.Resampling.LANCZOS).save(os.path.join(macos_xcassets, filename))
        print("  -> macOS AppIcon.appiconset selesai disinkronkan.")
        
    # Web Favicons & PWA Suite
    web_dir = os.path.join(WORKSPACE, "web")
    web_icons = os.path.join(web_dir, "icons")
    web_app_icon = os.path.join(APP_ICON_DIR, "web")
    os.makedirs(web_icons, exist_ok=True)
    os.makedirs(web_app_icon, exist_ok=True)
    
    app_icon_1024.save(os.path.join(web_app_icon, "favicon.ico"), format="ICO", sizes=[(16, 16), (32, 32), (48, 48)])
    app_icon_1024.resize((32, 32), Image.Resampling.LANCZOS).save(os.path.join(web_dir, "favicon.png"))
    app_icon_1024.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_icons, "Icon-192.png"))
    app_icon_1024.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_icons, "Icon-512.png"))
    app_icon_1024.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_icons, "Icon-maskable-192.png"))
    app_icon_1024.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_icons, "Icon-maskable-512.png"))
    app_icon_1024.resize((180, 180), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon, "apple-touch-icon.png"))
    app_icon_1024.resize((16, 16), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon, "favicon-16x16.png"))
    app_icon_1024.resize((32, 32), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon, "favicon-32x32.png"))
    app_icon_1024.resize((48, 48), Image.Resampling.LANCZOS).save(os.path.join(web_app_icon, "favicon-48x48.png"))
    print("  -> Web Favicon & PWA Suite selesai diperbarui.")

    # Sinkronisasi SVG Master
    print("[6/6] Memperbarui berkas SVG master...")
    def to_b64(path):
        with open(path, "rb") as f:
            return base64.b64encode(f.read()).decode("ascii")

    svg_tasks = [
        ("nikahin-symbol-master.svg", "nikahin-symbol-master.png", 1024, 1024),
        ("nikahin-symbol-black.svg", "nikahin-symbol-black.png", 1024, 1024),
        ("nikahin-symbol-white.svg", "nikahin-symbol-white.png", 1024, 1024),
        ("nikahin-app-icon.svg", "nikahin-app-icon.png", 1024, 1024),
        ("nikahin-app-icon-fg.svg", "nikahin-app-icon-fg.png", 512, 512),
        ("nikahin-lockup-horizontal.svg", "nikahin-lockup-horizontal.png", 1200, 400),
        ("nikahin-lockup-horizontal-dark.svg", "nikahin-lockup-horizontal-dark.png", 1200, 400),
        ("nikahin-lockup-stacked.svg", "nikahin-lockup-stacked.png", 600, 680),
        ("nikahin-lockup-stacked-dark.svg", "nikahin-lockup-stacked-dark.png", 600, 680),
    ]
    for s_name, p_name, w, h in svg_tasks:
        p_path = os.path.join(PNG_DIR, p_name)
        if os.path.exists(p_path):
            b64_data = to_b64(p_path)
            s_path = os.path.join(SVG_DIR, s_name)
            with open(s_path, "w", encoding="utf-8") as f:
                f.write(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">\n'
                        f'  <image width="{w}" height="{h}" href="data:image/png;base64,{b64_data}" />\n'
                        f'</svg>\n')

    # nikahin-app-icon-bg.svg
    with open(os.path.join(SVG_DIR, "nikahin-app-icon-bg.svg"), "w", encoding="utf-8") as f:
        f.write('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">\n'
                '  <rect width="100%" height="100%" fill="#8B204A" />\n'
                '</svg>\n')

    # welcome_slide_1.svg
    w1_png = os.path.join(IMAGES_DIR, "welcome_slide_1.png")
    if os.path.exists(w1_png):
        b64_w1 = to_b64(w1_png)
        with open(os.path.join(ILLUSTRATIONS_DIR, "welcome_slide_1.svg"), "w", encoding="utf-8") as f:
            f.write('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">\n'
                    f'  <image width="512" height="512" href="data:image/png;base64,{b64_w1}" />\n'
                    '</svg>\n')
    print("  -> Seluruh berkas SVG master selesai disinkronkan.")

    print("\n[OK] SUKSES PENUH! Seluruh aset visual brand, SVG, PNG, dan launcher icons multi-platform berhasil diperbarui.")

if __name__ == "__main__":
    main()
