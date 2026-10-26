#!/usr/bin/env python3
"""
Nikahin App - Unified Brand Logo & Multi-Platform Icon Generator
Skrip tunggal resmi (single source of truth) untuk merender, memproses, dan mendistribusikan aset brand Nikahin:
- Mendukung sumber vektor SVG maupun raster resolusi tinggi (alpha-matting & extraction).
- Menghasilkan Master Symbol (warna penuh, hitam, putih), Lockup (horizontal & vertikal, light & dark).
- Menghasilkan App Icon (Deep Wine Maroon #8B204A) & Onboarding Illustration (welcome_slide_1).
- Mendistribusikan ke seluruh platform: Android (Adaptive & Legacy), iOS (xcassets zero-alpha),
  Windows (.ico multi-resolusi), macOS (xcassets), dan Web Suite (Favicon, Apple touch icon, PWA icons).
"""

import os
import sys
import json
import base64
import numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter

sys.dont_write_bytecode = True

# 1. Resolusi Jalur Proyek
SKILL_DIR = os.path.dirname(os.path.abspath(__file__))
candidate = os.path.abspath(os.path.join(SKILL_DIR, "..", "..", "..", ".."))
WORKSPACE = candidate if os.path.exists(os.path.join(candidate, "pubspec.yaml")) else os.path.abspath(".")

LOGO_DESIGN_SCRIPTS = os.path.join(WORKSPACE, ".agents", "skills", "logo-design", "scripts")
if LOGO_DESIGN_SCRIPTS not in sys.path:
    sys.path.insert(0, LOGO_DESIGN_SCRIPTS)

SVG_DIR = os.path.join(WORKSPACE, "assets", "logo", "svg")
PNG_DIR = os.path.join(WORKSPACE, "assets", "logo", "png")
APP_ICON_DIR = os.path.join(WORKSPACE, "assets", "logo", "app_icon")
ILLUSTRATIONS_DIR = os.path.join(WORKSPACE, "assets", "illustrations")
IMAGES_DIR = os.path.join(WORKSPACE, "assets", "images")

os.makedirs(PNG_DIR, exist_ok=True)
os.makedirs(SVG_DIR, exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "ios"), exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "android"), exist_ok=True)
os.makedirs(os.path.join(APP_ICON_DIR, "web"), exist_ok=True)
os.makedirs(IMAGES_DIR, exist_ok=True)

# 2. Konstanta Desain & Warna Resmi Brand Nikahin
DEEP_WINE = (139, 32, 74)       # #8B204A
DEEP_WINE_DARK = (74, 19, 40)   # #4A1328
CHAMPAGNE_BG = (253, 242, 233)  # #FDF2E9
CREAM_TEXT = (255, 243, 223)    # #FFF3DF
GOLD_TAGLINE = (212, 175, 55)   # #D4AF37
GOLD_ACCENT = (170, 119, 28)    # #AA771C

# 3. Tipografi
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

def extract_clean_emblem_from_raster():
    """Ekstraksi lambang transparan murni dari file sumber raster bila tersedia."""
    nobg_path = os.path.join(WORKSPACE, "logonobg.jpg")
    withbg_path = os.path.join(WORKSPACE, "logowithbg.jpg")
    master_png = os.path.join(PNG_DIR, "nikahin-symbol-master.png")

    if os.path.exists(nobg_path) and os.path.exists(withbg_path):
        nobg = np.array(Image.open(nobg_path)).astype(float)
        withbg = np.array(Image.open(withbg_path)).astype(float)

        sat = np.max(nobg, axis=-1) - np.min(nobg, axis=-1)
        # Saring noise saturasi latar belakang agar tepi benar-benar bersih transparan (alpha 0)
        alpha = np.clip((sat - 7.0) / (22.0 - 7.0), 0.0, 1.0)
        alpha[alpha < 0.03] = 0.0

        mask_im = Image.fromarray((alpha * 255).astype(np.uint8), mode='L')
        mask_im = mask_im.filter(ImageFilter.GaussianBlur(radius=0.7))
        alpha_smooth = np.array(mask_im).astype(float) / 255.0
        alpha_smooth[alpha_smooth < 0.02] = 0.0

        B = np.array([139.0, 32.0, 74.0])
        rgb = withbg.copy()
        unblend_mask = (alpha_smooth > 0.05) & (alpha_smooth < 0.98)
        for c in range(3):
            unblended = (rgb[:, :, c] - (1.0 - alpha_smooth) * B[c]) / np.maximum(alpha_smooth, 0.05)
            rgb[:, :, c] = np.where(unblend_mask, np.clip(unblended, 0, 255), rgb[:, :, c])

        rgba = np.dstack([rgb, alpha_smooth * 255]).astype(np.uint8)
        emblem_full = Image.fromarray(rgba, mode='RGBA')

        # Crop ketat ke bounding box nyata lambang (memangkas ruang kosong latar)
        bbox = emblem_full.getbbox()
        cropped = emblem_full.crop(bbox)

        w, h = cropped.size
        # Berikan margin optik minimal 5% agar lambang proporsional dan tidak terpotong
        side = int(max(w, h) * 1.05)
        sq = Image.new("RGBA", (side, side), (0, 0, 0, 0))
        # Posisi presisi di tengah vertikal dan horizontal (50-50 balance)
        offset = ((side - w) // 2, (side - h) // 2)
        sq.paste(cropped, offset, cropped)
        return sq
    elif os.path.exists(master_png):
        return Image.open(master_png).convert("RGBA")
    else:
        raise FileNotFoundError("Sumber master logo tidak ditemukan (JPG sumber atau nikahin-symbol-master.png).")

def build_warm_champagne_background(size):
    """Membangun kanvas latar Rich Warm Champagne & Sacred Melati Light Luxury (Bukan Putih Polos)."""
    y = np.linspace(0, 1, size).reshape(size, 1)
    x = np.linspace(0, 1, size).reshape(1, size)
    # Radial glow terpusat dari area atas (x=0.5, y=0.38)
    cx, cy = 0.5, 0.38
    r_dist = np.sqrt((x - cx)**2 + (y - cy)**2) / 0.72
    r_dist = np.clip(r_dist, 0.0, 1.0)
    # Kombinasi radial highlight dengan vignette vertikal mewah
    t = np.clip(r_dist * 0.7 + y * 0.3, 0.0, 1.0)

    # Warna:
    # Inti Kilau: Sacred Melati Champagne #FDF0DE (253, 240, 222)
    # Pinggir / Dasar Vignette: Rich Golden Champagne Silk #E6C59E (230, 197, 158)
    c_center = np.array([253.0, 240.0, 222.0])
    c_outer = np.array([230.0, 197.0, 158.0])

    rgb = (c_center * (1.0 - t[:, :, np.newaxis]) + c_outer * t[:, :, np.newaxis]).astype(np.uint8)
    return Image.fromarray(rgb, mode="RGB")

def create_monochrome_variant(emblem_rgba, color_rgb):
    """Membuat varian monokrom siluet dengan mempertahankan alpha channel asli."""
    r, g, b = color_rgb
    arr = np.array(emblem_rgba)
    alpha = arr[:, :, 3]
    out_arr = np.zeros_like(arr)
    out_arr[:, :, 0] = r
    out_arr[:, :, 1] = g
    out_arr[:, :, 2] = b
    out_arr[:, :, 3] = alpha
    return Image.fromarray(out_arr, mode="RGBA")

def create_champagne_plate(w, h, radius, pad=20):
    plate = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    box_w = w - 2 * pad
    box_h = h - 2 * pad
    y = np.linspace(0, 1, box_h).reshape(box_h, 1, 1)
    c_top = np.array([253.0, 240.0, 222.0]).reshape(1, 1, 3)  # #FDF0DE
    c_bot = np.array([230.0, 197.0, 158.0]).reshape(1, 1, 3)  # #E6C59E
    rgb = (c_top * (1.0 - y) + c_bot * y).astype(np.uint8)
    rgb_full = np.repeat(rgb, box_w, axis=1)
    grad_im = Image.fromarray(rgb_full, mode="RGB").convert("RGBA")

    mask = Image.new("L", (box_w, box_h), 0)
    m_draw = ImageDraw.Draw(mask)
    m_draw.rounded_rectangle([0, 0, box_w, box_h], radius=radius, fill=255)

    plate.paste(grad_im, (pad, pad), mask)
    p_draw = ImageDraw.Draw(plate)
    p_draw.rounded_rectangle([pad, pad, w - pad, h - pad], radius=radius, outline=(212, 175, 55, 230), width=3)
    return plate

def build_horizontal_lockup(emblem_rgba, dark=False):
    canvas = Image.new("RGBA", (1200, 400), (0, 0, 0, 0))
    if dark:
        plate = create_champagne_plate(1200, 400, radius=36, pad=20)
        canvas = Image.alpha_composite(canvas, plate)

    emblem_thumb = emblem_rgba.resize((260, 260), Image.Resampling.LANCZOS)
    if dark:
        emb_shadow = Image.new("RGBA", (1200, 400), (0, 0, 0, 0))
        emb_mask = Image.fromarray(np.array(emblem_thumb)[:, :, 3], mode='L')
        emb_sh_layer = Image.new("RGBA", (260, 260), (139, 32, 74, 50))
        emb_shadow.paste(emb_sh_layer, (70, 74), emb_mask)
        emb_shadow = emb_shadow.filter(ImageFilter.GaussianBlur(radius=8))
        canvas = Image.alpha_composite(canvas, emb_shadow)

    canvas.paste(emblem_thumb, (70, 70), emblem_thumb)

    draw = ImageDraw.Draw(canvas)
    title_text = "Nikahin"
    tagline_text = "W E D D I N G   P L A N N E R"
    title_color = DEEP_WINE_DARK
    tagline_color = GOLD_ACCENT

    draw.text((370, 105), title_text, font=FONT_TITLE_LARGE, fill=title_color)
    draw.text((375, 235), tagline_text, font=FONT_TAGLINE_LARGE, fill=tagline_color)
    return canvas

def build_stacked_lockup(emblem_rgba, dark=False):
    canvas = Image.new("RGBA", (600, 680), (0, 0, 0, 0))
    if dark:
        plate = create_champagne_plate(600, 680, radius=32, pad=15)
        canvas = Image.alpha_composite(canvas, plate)

    emblem_thumb = emblem_rgba.resize((300, 300), Image.Resampling.LANCZOS)
    if dark:
        emb_shadow = Image.new("RGBA", (600, 680), (0, 0, 0, 0))
        emb_mask = Image.fromarray(np.array(emblem_thumb)[:, :, 3], mode='L')
        emb_sh_layer = Image.new("RGBA", (300, 300), (139, 32, 74, 50))
        emb_shadow.paste(emb_sh_layer, (150, 64), emb_mask)
        emb_shadow = emb_shadow.filter(ImageFilter.GaussianBlur(radius=8))
        canvas = Image.alpha_composite(canvas, emb_shadow)

    canvas.paste(emblem_thumb, (150, 60), emblem_thumb)

    draw = ImageDraw.Draw(canvas)
    title_text = "Nikahin"
    tagline_text = "W E D D I N G   P L A N N E R"
    title_color = DEEP_WINE_DARK
    tagline_color = GOLD_ACCENT

    bbox_t = draw.textbbox((0, 0), title_text, font=FONT_TITLE_MED)
    tw = bbox_t[2] - bbox_t[0]
    draw.text(((600 - tw) // 2, 400), title_text, font=FONT_TITLE_MED, fill=title_color)

    bbox_tag = draw.textbbox((0, 0), tagline_text, font=FONT_TAGLINE_MED)
    tagw = bbox_tag[2] - bbox_tag[0]
    draw.text(((600 - tagw) // 2, 480), tagline_text, font=FONT_TAGLINE_MED, fill=tagline_color)
    return canvas

def build_welcome_slide_1(emblem_rgba):
    """Membangun ilustrasi welcome slide 1 (512x512) dengan piringan bento champagne & gold sparkles."""
    canvas = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    saucer = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(saucer)
    s_draw.ellipse([26, 26, 486, 486], fill=(253, 243, 231, 255), outline=(212, 175, 55, 255), width=4)
    s_draw.ellipse([14, 14, 498, 498], outline=(232, 213, 190, 180), width=2)
    s_draw.ellipse([48, 48, 464, 464], outline=(240, 220, 186, 120), width=1)
    s_draw.ellipse([126, 120, 386, 380], fill=(254, 239, 216, 160))
    canvas = Image.alpha_composite(canvas, saucer)

    emblem_size = 280
    emb_thumb = emblem_rgba.resize((emblem_size, emblem_size), Image.Resampling.LANCZOS)
    shadow = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    shadow_mask = Image.fromarray(np.array(emb_thumb)[:, :, 3], mode='L')
    shadow_layer = Image.new("RGBA", (emblem_size, emblem_size), (139, 32, 74, 90))
    shadow.paste(shadow_layer, ((512 - emblem_size) // 2, (512 - emblem_size) // 2 + 10), shadow_mask)
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=8))

    canvas = Image.alpha_composite(canvas, shadow)
    canvas.paste(emb_thumb, ((512 - emblem_size) // 2, (512 - emblem_size) // 2), emb_thumb)

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
    print("[1/7] Menyiapkan Master Symbol transparan murni...")
    emblem = extract_clean_emblem_from_raster()

    m1024 = emblem.resize((1024, 1024), Image.Resampling.LANCZOS)
    m1024.save(os.path.join(PNG_DIR, "nikahin-symbol-master.png"))
    m512 = emblem.resize((512, 512), Image.Resampling.LANCZOS)
    m512.save(os.path.join(PNG_DIR, "nikahin-symbol-master-512.png"))

    black_sym = create_monochrome_variant(m1024, (0, 0, 0))
    black_sym.save(os.path.join(PNG_DIR, "nikahin-symbol-black.png"))
    black_sym.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(PNG_DIR, "nikahin-symbol-black-512.png"))

    white_sym = create_monochrome_variant(m1024, (255, 255, 255))
    white_sym.save(os.path.join(PNG_DIR, "nikahin-symbol-white.png"))
    white_sym.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(PNG_DIR, "nikahin-symbol-white-512.png"))
    print("  -> nikahin-symbol-master, black, dan white (1024 & 512 px) siap.")

    print("[2/7] Membangun Lockup Horizontal & Stacked (Light & Dark)...")
    build_horizontal_lockup(m512, dark=False).save(os.path.join(PNG_DIR, "nikahin-lockup-horizontal.png"))
    build_horizontal_lockup(m512, dark=True).save(os.path.join(PNG_DIR, "nikahin-lockup-horizontal-dark.png"))
    build_stacked_lockup(m512, dark=False).save(os.path.join(PNG_DIR, "nikahin-lockup-stacked.png"))
    build_stacked_lockup(m512, dark=True).save(os.path.join(PNG_DIR, "nikahin-lockup-stacked-dark.png"))
    print("  -> Berkas lockup selesai dibangun.")

    print("[3/7] Membangun Ikon Aplikasi Master & Lapisan Adaptive (Warm Champagne & Sacred Melati)...")
    app_bg = build_warm_champagne_background(1024)
    app_icon_rgba = app_bg.convert("RGBA")

    # Skala visual zoom-in ~840px visible (82% canvas) standar aplikasi modern (iOS & Android)
    emblem_app = emblem.resize((840, 840), Image.Resampling.LANCZOS)

    # Ambient luxury shadow di belakang lambang agar kontras dan elevasi terjaga anggun di atas latar krem
    shadow_1024 = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    shadow_mask = Image.fromarray(np.array(emblem_app)[:, :, 3], mode='L')
    shadow_layer = Image.new("RGBA", (840, 840), (139, 32, 74, 55)) # Warm Wine ambient shadow
    shadow_1024.paste(shadow_layer, ((1024 - 840) // 2, (1024 - 840) // 2 + 14), shadow_mask)
    shadow_1024 = shadow_1024.filter(ImageFilter.GaussianBlur(radius=16))

    app_icon_rgba = Image.alpha_composite(app_icon_rgba, shadow_1024)
    app_icon_rgba.paste(emblem_app, ((1024 - 840) // 2, (1024 - 840) // 2), emblem_app)

    # Solid RGB tanpa alpha untuk mematuhi Apple App Store
    app_icon_1024 = app_icon_rgba.convert("RGB")
    app_icon_1024.save(os.path.join(PNG_DIR, "nikahin-app-icon.png"), quality=95)
    app_icon_1024.save(os.path.join(APP_ICON_DIR, "ios", "icon-1024.png"), quality=95)

    # Android Adaptive foreground (512x512):
    # Ukuran 310x310 berada 100% di dalam safe-zone lingkaran 338px
    fg_canvas = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    fg_emblem = emblem.resize((310, 310), Image.Resampling.LANCZOS)

    fg_shadow = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    fg_shadow_mask = Image.fromarray(np.array(fg_emblem)[:, :, 3], mode='L')
    fg_shadow_layer = Image.new("RGBA", (310, 310), (139, 32, 74, 50))
    fg_shadow.paste(fg_shadow_layer, ((512 - 310) // 2, (512 - 310) // 2 + 6), fg_shadow_mask)
    fg_shadow = fg_shadow.filter(ImageFilter.GaussianBlur(radius=6))

    fg_canvas = Image.alpha_composite(fg_canvas, fg_shadow)
    fg_canvas.paste(fg_emblem, ((512 - 310) // 2, (512 - 310) // 2), fg_emblem)
    fg_canvas.save(os.path.join(PNG_DIR, "nikahin-app-icon-fg.png"))

    bg_img = build_warm_champagne_background(512)
    bg_canvas = bg_img.convert("RGBA")
    bg_canvas.save(os.path.join(PNG_DIR, "nikahin-app-icon-bg.png"))
    print("  -> Master app-icon, foreground adaptive, dan background adaptive siap.")

    print("[4/7] Memperbarui Welcome Screen Onboarding Slide 1...")
    welcome_1 = build_welcome_slide_1(m512)
    welcome_1.save(os.path.join(IMAGES_DIR, "welcome_slide_1.png"))
    print("  -> assets/images/welcome_slide_1.png diperbarui.")

    print("[5/7] Mendistribusikan Ikon ke Semua Platform...")
    # iOS xcassets (Solid RGB zero-alpha)
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

    print("[6/7] Memperbarui berkas SVG master...")
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

    with open(os.path.join(SVG_DIR, "nikahin-app-icon-bg.svg"), "w", encoding="utf-8") as f:
        f.write('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">\n'
                '  <defs>\n'
                '    <linearGradient id="champagneGrad" x1="0" y1="0" x2="0" y2="1">\n'
                '      <stop offset="0%" stop-color="#FDF0DE" />\n'
                '      <stop offset="100%" stop-color="#E6C59E" />\n'
                '    </linearGradient>\n'
                '  </defs>\n'
                '  <rect width="100%" height="100%" fill="url(#champagneGrad)" />\n'
                '</svg>\n')

    w1_png = os.path.join(IMAGES_DIR, "welcome_slide_1.png")
    if os.path.exists(w1_png):
        b64_w1 = to_b64(w1_png)
        with open(os.path.join(ILLUSTRATIONS_DIR, "welcome_slide_1.svg"), "w", encoding="utf-8") as f:
            f.write('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">\n'
                    f'  <image width="512" height="512" href="data:image/png;base64,{b64_w1}" />\n'
                    '</svg>\n')
    print("  -> Seluruh berkas SVG master selesai disinkronkan.")

    print("\n[7/7] [OK] SUKSES PENUH! Seluruh aset visual brand, SVG, PNG, dan launcher icons multi-platform berhasil diperbarui.")

if __name__ == "__main__":
    main()
