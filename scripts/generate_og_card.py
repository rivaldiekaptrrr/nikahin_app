import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def draw_vector_checkmark(draw, x, y, size, circle_col=(220, 252, 231, 255), check_col=(22, 163, 74, 255), scale=1):
    draw.ellipse([x, y, x + size, y + size], fill=circle_col)
    pts = [
        (x + size * 0.26, y + size * 0.52),
        (x + size * 0.44, y + size * 0.72),
        (x + size * 0.74, y + size * 0.32)
    ]
    draw.line(pts, fill=check_col, width=max(1, int(2.5 * scale)), joint="curve")

def draw_vector_lock(draw, x, y, size, col=(120, 110, 100, 255), scale=1):
    bw = size * 0.75
    bh = size * 0.55
    bx = x + (size - bw) / 2
    by = y + size * 0.40
    draw.rounded_rectangle([bx, by, bx + bw, by + bh], radius=max(1, int(2 * scale)), fill=col)
    sw = size * 0.44
    sh = size * 0.44
    sx = x + (size - sw) / 2
    sy = y + size * 0.06
    draw.arc([sx, sy, sx + sw, sy + sh], start=180, end=0, fill=col, width=max(1, int(2 * scale)))

def draw_two_way_arrow(draw, x1, y, x2, col=(150, 106, 30, 255), scale=1):
    line_w = max(1, int(2 * scale))
    arrow_size = int(6 * scale)
    draw.line([x1 + arrow_size, y, x2 - arrow_size, y], fill=col, width=line_w)
    draw.line([(x1 + arrow_size, y - arrow_size), (x1, y), (x1 + arrow_size, y + arrow_size)], fill=col, width=line_w)
    draw.line([(x2 - arrow_size, y - arrow_size), (x2, y), (x2 - arrow_size, y + arrow_size)], fill=col, width=line_w)

def create_og_card(output_path, bg_path="c:/Rivaldi/nikahin_app/og-bg.jpg"):
    WIDTH = 1200
    HEIGHT = 630
    SCALE = 2  # 2x supersampling for high-DPI rendering
    W = WIDTH * SCALE
    H = HEIGHT * SCALE

    # 1. Base Canvas & Background Image Integration
    if os.path.exists(bg_path):
        user_bg = Image.open(bg_path).convert("RGBA")
        bg_ratio = user_bg.width / user_bg.height
        target_ratio = W / H
        if bg_ratio > target_ratio:
            new_h = H
            new_w = int(H * bg_ratio)
        else:
            new_w = W
            new_h = int(W / bg_ratio)
        
        user_bg_resized = user_bg.resize((new_w, new_h), Image.Resampling.LANCZOS)
        left = (new_w - W) // 2
        top = (new_h - H) // 2
        img = user_bg_resized.crop((left, top, left + W, top + H))
        
        # Soft warm parchment scrim for pure editorial contrast
        scrim = Image.new("RGBA", (W, H), (253, 250, 246, 205))
        img = Image.alpha_composite(img, scrim)
    else:
        img = Image.new("RGBA", (W, H), (252, 249, 245, 255))

    draw = ImageDraw.Draw(img)

    # Hairline Outer Border (Restrained, subtle)
    margin = int(16 * SCALE)
    draw.rounded_rectangle(
        [margin, margin, W - margin, H - margin],
        radius=int(18 * SCALE),
        outline=(220, 204, 185, 200),
        width=int(1.5 * SCALE)
    )

    # 2. Typography Setup (Scaled Up for High Readability on Thumbnails)
    font_dir = "c:/Rivaldi/nikahin_app/.cache_fonts"
    jakarta_path = os.path.join(font_dir, "PlusJakartaSans.ttf")
    playfair_path = os.path.join(font_dir, "PlayfairDisplay.ttf")

    def get_font(path, size, fallback="arial.ttf"):
        try:
            return ImageFont.truetype(path, int(size * SCALE))
        except Exception:
            return ImageFont.truetype(f"C:/Windows/Fonts/{fallback}", int(size * SCALE))

    font_brand = get_font(playfair_path, 42, "georgiab.ttf")
    font_brand_tag = get_font(jakarta_path, 11, "segoeuib.ttf")
    font_headline = get_font(playfair_path, 40, "georgiab.ttf")
    
    font_price_tag = get_font(jakarta_path, 13, "segoeuib.ttf")
    font_price_big = get_font(jakarta_path, 62, "arialbd.ttf")
    font_price_strike = get_font(jakarta_path, 22, "segoeui.ttf")
    font_discount_text = get_font(jakarta_path, 14, "segoeuib.ttf")
    font_price_sub = get_font(jakarta_path, 14.5, "segoeuib.ttf")
    font_bullet_bold = get_font(jakarta_path, 13.5, "segoeuib.ttf")
    font_bullet_reg = get_font(jakarta_path, 13.5, "segoeui.ttf")
    font_footer = get_font(jakarta_path, 12, "segoeui.ttf")

    font_sec_head = get_font(jakarta_path, 18, "segoeuib.ttf")
    font_sec_tag = get_font(jakarta_path, 12.5, "segoeuib.ttf")
    font_sec_body = get_font(jakarta_path, 13.5, "segoeui.ttf")
    font_chip_label = get_font(jakarta_path, 13, "segoeuib.ttf")

    # Colors
    DEEP_WINE = (65, 15, 35, 255)       # Sophisticated Wine
    DARK_WINE = (40, 10, 22, 255)
    ROYAL_GOLD = (150, 106, 30, 255)    # Gold
    CORAL_ROSE = (215, 65, 60, 255)     # Warm Coral
    TEAL_MINT = (15, 118, 110, 255)     # Deep Teal
    TEXT_STONE = (30, 26, 24, 255)      # Stone 900
    TEXT_MUTED = (105, 93, 80, 255)     # Stone 600
    CARD_BG = (255, 255, 255, 255)
    CARD_BORDER = (230, 216, 198, 255)
    DIVIDER_COL = (238, 226, 212, 255)

    # 3. TOP HEADER ROW (With Generous Breathing Room Under "Nikahin")
    header_x = int(40 * SCALE)
    header_y = int(24 * SCALE)

    # Official Logo Icon
    logo_path = "c:/Rivaldi/nikahin_app/landing-page/public/assets/nikahin-symbol-master-512.png"
    logo_size = int(54 * SCALE)
    if os.path.exists(logo_path):
        logo_img = Image.open(logo_path).convert("RGBA")
        logo_img = logo_img.resize((logo_size, logo_size), Image.Resampling.LANCZOS)
        img.paste(logo_img, (header_x, header_y), logo_img)
        logo_offset = logo_size + int(14 * SCALE)
    else:
        logo_offset = 0

    # Brand Wordmark "Nikahin" (42pt Playfair Display)
    nikahin_y = header_y - int(4 * SCALE)
    draw.text((header_x + logo_offset, nikahin_y), "Nikahin", fill=DEEP_WINE, font=font_brand)
    b_box = draw.textbbox((header_x + logo_offset, nikahin_y), "Nikahin", font=font_brand)
    
    # Tagline with 12px Clear Breathing Space (Bebas dari Kemepetan)
    tag_y = b_box[3] + int(8 * SCALE)
    draw.text((header_x + logo_offset + int(2 * SCALE), tag_y), "WEDDING PLANNER & BUDGET PASANGAN", fill=ROYAL_GOLD, font=font_brand_tag)

    # Top-right Platform: Android & iOS
    right_note = "Android & iOS  •  getnikahin.my.id"
    bbox_rn = draw.textbbox((0, 0), right_note, font=font_bullet_bold)
    rn_w = bbox_rn[2] - bbox_rn[0]
    draw.text((W - int(40 * SCALE) - rn_w, header_y + int(14 * SCALE)), right_note, fill=DARK_WINE, font=font_bullet_bold)

    # Subtle Header Divider
    header_div_y = int(88 * SCALE)
    draw.line([header_x, header_div_y, W - int(40 * SCALE), header_div_y], fill=(225, 210, 192, 220), width=int(1 * SCALE))

    # =========================================================================
    # 4. LEFT COLUMN: Headline & Highlight Harga Seumur Hidup
    # =========================================================================
    col1_x = int(40 * SCALE)
    col1_w = int(510 * SCALE)
    main_y = int(102 * SCALE)

    # Headline (Scaled up to 40pt)
    draw.text((col1_x, main_y), "Aplikasi Wedding Planner", fill=DARK_WINE, font=font_headline)
    draw.text((col1_x, main_y + int(48 * SCALE)), "untuk Berdua.", fill=DARK_WINE, font=font_headline)

    # -------------------------------------------------------------------------
    # Card Harga Spesial (Scaled Up, Lapang, & Elegan)
    # -------------------------------------------------------------------------
    price_box_y = main_y + int(108 * SCALE)
    price_box_h = int(342 * SCALE)

    # Ambient drop shadow
    shadow_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow_layer)
    s_draw.rounded_rectangle(
        [col1_x, price_box_y + int(4 * SCALE), col1_x + col1_w, price_box_y + price_box_h + int(6 * SCALE)],
        radius=int(16 * SCALE),
        fill=(65, 15, 35, 16)
    )
    shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(8 * SCALE))
    img = Image.alpha_composite(img, shadow_layer)
    draw = ImageDraw.Draw(img)

    # Card Body
    draw.rounded_rectangle(
        [col1_x, price_box_y, col1_x + col1_w, price_box_y + price_box_h],
        radius=int(16 * SCALE),
        fill=CARD_BG,
        outline=CARD_BORDER,
        width=int(1.5 * SCALE)
    )

    pad_x = int(26 * SCALE)
    cur_y = price_box_y + int(24 * SCALE)

    # Top Row inside Card: Left = Offer label, Right = Hemat 60%
    draw.text((col1_x + pad_x, cur_y), "Sekali Bayar • Tanpa Biaya Berlangganan", fill=ROYAL_GOLD, font=font_price_tag)
    
    disc_text = "Hemat 60%"
    disc_w = draw.textbbox((0, 0), disc_text, font=font_discount_text)[2]
    draw.text((col1_x + col1_w - pad_x - disc_w, cur_y - int(1 * SCALE)), disc_text, fill=CORAL_ROSE, font=font_discount_text)
    cur_y += int(26 * SCALE)

    # Big Price Row: Rp 39.000 (Scaled Up to 62pt bold!) + Strikethrough Rp 99.000
    draw.text((col1_x + pad_x, cur_y), "Rp 39.000", fill=DARK_WINE, font=font_price_big)
    price_w = draw.textbbox((0, 0), "Rp 39.000", font=font_price_big)[2]

    strike_x = col1_x + pad_x + price_w + int(16 * SCALE)
    strike_y = cur_y + int(24 * SCALE)
    draw.text((strike_x, strike_y), "Rp 99.000", fill=(160, 150, 140, 255), font=font_price_strike)
    strike_w = draw.textbbox((0, 0), "Rp 99.000", font=font_price_strike)[2]
    draw.line([strike_x, strike_y + int(14 * SCALE), strike_x + strike_w, strike_y + int(14 * SCALE)], fill=(160, 150, 140, 255), width=int(1.5 * SCALE))

    cur_y += int(78 * SCALE)
    draw.text((col1_x + pad_x, cur_y), "Akses Penuh Selamanya untuk Kedua Mempelai", fill=TEXT_STONE, font=font_price_sub)
    cur_y += int(30 * SCALE)

    # Hairline divider
    draw.line([col1_x + pad_x, cur_y, col1_x + col1_w - pad_x, cur_y], fill=DIVIDER_COL, width=int(1 * SCALE))
    cur_y += int(18 * SCALE)

    # 3 Bullet Rows (Scaled up with 18px vector checkmark circle)
    def draw_bullet_row(y, bold_text, reg_text):
        icon_size = int(18 * SCALE)
        draw_vector_checkmark(draw, col1_x + pad_x, y + int(1 * SCALE), icon_size, circle_col=(220, 252, 231, 255), check_col=(22, 163, 74, 255), scale=SCALE)
        text_x = col1_x + pad_x + icon_size + int(12 * SCALE)
        draw.text((text_x, y), bold_text, fill=DARK_WINE, font=font_bullet_bold)
        bw = draw.textbbox((0, 0), bold_text, font=font_bullet_bold)[2]
        draw.text((text_x + bw, y), reg_text, fill=TEXT_MUTED, font=font_bullet_reg)

    draw_bullet_row(cur_y, "1 Pembayaran untuk Berdua: ", "Aktif di ponsel pria & wanita")
    cur_y += int(32 * SCALE)
    draw_bullet_row(cur_y, "Bebas Iklan & Langganan: ", "Sekali bayar aktif selamanya")
    cur_y += int(32 * SCALE)
    draw_bullet_row(cur_y, "Penyimpanan Aman: ", "Tersinkron cloud & bisa offline")

    # Bottom Callout dengan Vector Lock Icon
    callout_y = price_box_y + price_box_h + int(18 * SCALE)
    lock_size = int(16 * SCALE)
    draw_vector_lock(draw, col1_x, callout_y + int(2 * SCALE), lock_size, col=(125, 110, 95, 255), scale=SCALE)
    draw.text(
        (col1_x + lock_size + int(10 * SCALE), callout_y),
        "Pembayaran resmi instan via QRIS (BCA, Mandiri, BRI, GoPay, ShopeePay)",
        fill=TEXT_MUTED,
        font=font_footer
    )

    # =========================================================================
    # 5. RIGHT COLUMN: Scaled-up Unified Showcase Panel
    # =========================================================================
    col2_x = int(574 * SCALE)
    col2_w = W - col2_x - int(40 * SCALE)
    panel_y = main_y
    panel_h = int(494 * SCALE)

    # Single Unified Showcase Panel with Soft Ambient Shadow
    s_draw.rounded_rectangle(
        [col2_x, panel_y + int(4 * SCALE), col2_x + col2_w, panel_y + panel_h + int(6 * SCALE)],
        radius=int(16 * SCALE),
        fill=(65, 15, 35, 16)
    )
    shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(8 * SCALE))
    img = Image.alpha_composite(img, shadow_layer)
    draw = ImageDraw.Draw(img)

    draw.rounded_rectangle(
        [col2_x, panel_y, col2_x + col2_w, panel_y + panel_h],
        radius=int(16 * SCALE),
        fill=CARD_BG,
        outline=CARD_BORDER,
        width=int(1.5 * SCALE)
    )

    pad_r = int(28 * SCALE)
    sec_gap = int(164 * SCALE)

    # -------------------------------------------------------------------------
    # SECTION 1: KONEK 2 AKUN BERDUA (REAL-TIME)
    # -------------------------------------------------------------------------
    sec1_y = panel_y + int(24 * SCALE)
    draw.text((col2_x + pad_r, sec1_y), "Konek 2 Akun Berdua (Real-Time)", fill=DARK_WINE, font=font_sec_head)
    
    tag1_text = "CPP & CPW Sinkron"
    tag1_w = draw.textbbox((0, 0), tag1_text, font=font_sec_tag)[2]
    draw.text((col2_x + col2_w - pad_r - tag1_w, sec1_y + int(3 * SCALE)), tag1_text, fill=TEAL_MINT, font=font_sec_tag)

    draw.text(
        (col2_x + pad_r, sec1_y + int(32 * SCALE)),
        "Cukup satu akun yang membayar, langsung aktif untuk kedua mempelai.\nCatatan di HP calon pengantin pria seketika terupdate di HP wanita.",
        fill=TEXT_MUTED,
        font=font_sec_body,
        spacing=int(5 * SCALE)
    )

    # Scaled Sync Diagram
    sync_y = sec1_y + int(86 * SCALE)
    draw.text((col2_x + pad_r, sync_y), "HP Pria (CPP)", fill=DARK_WINE, font=font_chip_label)
    pria_w = draw.textbbox((0, 0), "HP Pria (CPP)", font=font_chip_label)[2]

    arrow_x1 = col2_x + pad_r + pria_w + int(12 * SCALE)
    arrow_x2 = arrow_x1 + int(42 * SCALE)
    draw_two_way_arrow(draw, arrow_x1, sync_y + int(9 * SCALE), arrow_x2, col=ROYAL_GOLD, scale=SCALE)

    sync_label = "Sinkron 2 Arah Real-Time"
    draw.text((arrow_x2 + int(12 * SCALE), sync_y), sync_label, fill=ROYAL_GOLD, font=font_chip_label)
    lbl_w = draw.textbbox((0, 0), sync_label, font=font_chip_label)[2]

    arrow_x3 = arrow_x2 + int(12 * SCALE) + lbl_w + int(12 * SCALE)
    arrow_x4 = arrow_x3 + int(42 * SCALE)
    draw_two_way_arrow(draw, arrow_x3, sync_y + int(9 * SCALE), arrow_x4, col=ROYAL_GOLD, scale=SCALE)

    draw.text((arrow_x4 + int(12 * SCALE), sync_y), "HP Wanita (CPW)", fill=DARK_WINE, font=font_chip_label)

    # Section Divider 1
    sec1_div_y = sec1_y + int(136 * SCALE)
    draw.line([col2_x + pad_r, sec1_div_y, col2_x + col2_w - pad_r, sec1_div_y], fill=DIVIDER_COL, width=int(1 * SCALE))

    # -------------------------------------------------------------------------
    # SECTION 2: BEBAS PILIH TEMA WARNA APLIKASI
    # -------------------------------------------------------------------------
    sec2_y = sec1_div_y + int(20 * SCALE)
    draw.text((col2_x + pad_r, sec2_y), "Bebas Pilih Tema Warna Aplikasi", fill=DARK_WINE, font=font_sec_head)

    tag2_text = "5 Nuansa Eksklusif"
    tag2_w = draw.textbbox((0, 0), tag2_text, font=font_sec_tag)[2]
    draw.text((col2_x + col2_w - pad_r - tag2_w, sec2_y + int(3 * SCALE)), tag2_text, fill=ROYAL_GOLD, font=font_sec_tag)

    draw.text(
        (col2_x + pad_r, sec2_y + int(32 * SCALE)),
        "Sesuaikan palet warna antarmuka aplikasi agar senada dengan konsep\ndan dekorasi pernikahan Anda:",
        fill=TEXT_MUTED,
        font=font_sec_body,
        spacing=int(5 * SCALE)
    )

    # Swatches Row (Scaled up with 18px diameter dots)
    swatches = [
        ("Champagne", (212, 175, 55, 255)),
        ("Rose", (235, 91, 86, 255)),
        ("Emerald", (0, 105, 92, 255)),
        ("Burgundy", (125, 31, 63, 255)),
        ("Slate", (30, 41, 59, 255)),
    ]
    sw_x = col2_x + pad_r
    sw_y = sec2_y + int(86 * SCALE)
    dot_size = int(18 * SCALE)
    for s_name, s_col in swatches:
        draw.ellipse([sw_x, sw_y + int(1 * SCALE), sw_x + dot_size, sw_y + dot_size + int(1 * SCALE)], fill=s_col)
        draw.text((sw_x + dot_size + int(8 * SCALE), sw_y), s_name, fill=TEXT_STONE, font=font_chip_label)
        sw_w = draw.textbbox((0, 0), s_name, font=font_chip_label)[2]
        sw_x += dot_size + sw_w + int(20 * SCALE)

    # Section Divider 2
    sec2_div_y = sec2_y + int(136 * SCALE)
    draw.line([col2_x + pad_r, sec2_div_y, col2_x + col2_w - pad_r, sec2_div_y], fill=DIVIDER_COL, width=int(1 * SCALE))

    # -------------------------------------------------------------------------
    # SECTION 3: FITUR LENGKAP PERSIAPAN HARI H
    # -------------------------------------------------------------------------
    sec3_y = sec2_div_y + int(20 * SCALE)
    draw.text((col2_x + pad_r, sec3_y), "Fitur Lengkap Persiapan Hari H", fill=DARK_WINE, font=font_sec_head)

    tag3_text = "Semua Kebutuhan"
    tag3_w = draw.textbbox((0, 0), tag3_text, font=font_sec_tag)[2]
    draw.text((col2_x + col2_w - pad_r - tag3_w, sec3_y + int(3 * SCALE)), tag3_text, fill=CORAL_ROSE, font=font_sec_tag)

    draw.text(
        (col2_x + pad_r, sec3_y + int(32 * SCALE)),
        "Semua kebutuhan pernikahan terkumpul rapi tanpa berpindah aplikasi:",
        fill=TEXT_MUTED,
        font=font_sec_body
    )

    # Grid 2 Kolom x 2 Baris (Scaled up with 7px accent dots)
    col_left_x = col2_x + pad_r
    col_right_x = col2_x + int(285 * SCALE)
    bullet_size = int(7 * SCALE)

    row1_y = sec3_y + int(66 * SCALE)
    row2_y = sec3_y + int(96 * SCALE)

    def draw_feature_item(x, y, label):
        draw.ellipse([x, y + int(5 * SCALE), x + bullet_size, y + int(5 * SCALE) + bullet_size], fill=CORAL_ROSE)
        draw.text((x + bullet_size + int(10 * SCALE), y), label, fill=DARK_WINE, font=font_chip_label)

    draw_feature_item(col_left_x, row1_y, "Budget & DP Vendor (Termin)")
    draw_feature_item(col_right_x, row1_y, "Rundown Hari H & PIC")
    draw_feature_item(col_left_x, row2_y, "Buku Tamu & RSVP Digital")
    draw_feature_item(col_right_x, row2_y, "Seserahan & Dokumen KUA")

    # 6. Downscale to final 1200x630
    final_img = img.resize((WIDTH, HEIGHT), Image.Resampling.LANCZOS)
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    final_img.convert("RGB").save(output_path, "PNG", optimize=True)
    print(f"[SUCCESS] Scaled-Up Anti-Slop OG Card generated at {output_path} ({os.path.getsize(output_path)} bytes)")

if __name__ == "__main__":
    out = "c:/Rivaldi/nikahin_app/landing-page/public/assets/og-image.png"
    create_og_card(out, "c:/Rivaldi/nikahin_app/og-bg.jpg")
