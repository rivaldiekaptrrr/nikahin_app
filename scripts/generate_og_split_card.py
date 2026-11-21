import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_og_split_card(output_path="landing-page/public/assets/og-image.png"):
    # 2x supersampling for high-DPI rendering (2400 x 1260 -> 1200 x 630)
    WIDTH = 1200
    HEIGHT = 630
    SCALE = 2
    W = WIDTH * SCALE
    H = HEIGHT * SCALE

    # Fonts
    font_sans = "assets/fonts/PlusJakartaSans.ttf"
    font_serif = "assets/fonts/PlayfairDisplay.ttf"

    def get_font(path, size, fallback="arial.ttf"):
        try:
            return ImageFont.truetype(path, int(size * SCALE))
        except Exception:
            return ImageFont.truetype(f"C:/Windows/Fonts/{fallback}", int(size * SCALE))

    font_badge = get_font(font_sans, 12, "segoeuib.ttf")
    font_brand_title = get_font(font_serif, 46, "georgiab.ttf")
    font_tagline = get_font(font_sans, 18, "segoeuib.ttf")
    font_body = get_font(font_sans, 14, "segoeui.ttf")
    font_rating = get_font(font_sans, 15, "segoeuib.ttf")
    font_price_strike = get_font(font_sans, 15, "segoeui.ttf")
    font_price = get_font(font_sans, 26, "segoeuib.ttf")
    font_price_unit = get_font(font_sans, 14, "segoeui.ttf")
    font_cta = get_font(font_sans, 16, "segoeuib.ttf")
    font_platform = get_font(font_sans, 12, "segoeui.ttf")

    # 1. Base Canvas - Warm Golden Amber Backdrop (inspired by user template #F7BA1E / #F5B82E)
    # Creates high contrast against white card and pops in WhatsApp chat bubbles
    canvas = Image.new("RGBA", (W, H), (247, 186, 30, 255))
    canvas_draw = ImageDraw.Draw(canvas)

    # Subtle ambient gradient texture on backdrop
    for y_step in range(0, H, 4):
        alpha_tint = int(25 * (y_step / H))
        canvas_draw.line([(0, y_step), (W, y_step)], fill=(235, 165, 15, alpha_tint), width=4)

    # 2. Main White Card in Center with Drop Shadow
    card_margin_x = int(48 * SCALE)
    card_margin_y = int(36 * SCALE)
    card_x1 = card_margin_x
    card_y1 = card_margin_y
    card_x2 = W - card_margin_x
    card_y2 = H - card_margin_y
    card_radius = int(28 * SCALE)

    # Drop shadow behind card (clean offset shadow)
    shadow_offset_x = int(10 * SCALE)
    shadow_offset_y = int(14 * SCALE)
    canvas_draw.rounded_rectangle(
        [card_x1 + shadow_offset_x, card_y1 + shadow_offset_y, card_x2 + shadow_offset_x, card_y2 + shadow_offset_y],
        radius=card_radius,
        fill=(180, 125, 10, 255)  # Crisp solid shadow matching modern graphic template
    )

    # Main Card Body
    card_img = Image.new("RGBA", (card_x2 - card_x1, card_y2 - card_y1), (255, 255, 255, 255))
    card_draw = ImageDraw.Draw(card_img)

    # Subtle card hairline border
    card_draw.rounded_rectangle(
        [0, 0, card_img.width - 1, card_img.height - 1],
        radius=card_radius,
        outline=(230, 220, 205, 255),
        width=int(2 * SCALE)
    )

    # 3. LEFT COLUMN (Content, Brand, Value, Social Proof, CTA)
    pad_left = int(44 * SCALE)
    cur_y = int(42 * SCALE)

    # Top Tag / Pill: "LIFETIME DEAL" or "WEDDING PLANNER"
    badge_text = "LIFETIME DEAL"
    badge_bbox = card_draw.textbbox((0, 0), badge_text, font=font_badge)
    badge_w = badge_bbox[2] - badge_bbox[0] + int(24 * SCALE)
    badge_h = badge_bbox[3] - badge_bbox[1] + int(14 * SCALE)
    badge_radius = int(8 * SCALE)
    
    # Pill background
    card_draw.rounded_rectangle(
        [pad_left, cur_y, pad_left + badge_w, cur_y + badge_h],
        radius=badge_radius,
        fill=(15, 23, 42, 255)  # Dark slate 900
    )
    # Pill text
    card_draw.text(
        (pad_left + int(12 * SCALE), cur_y + int(6 * SCALE)),
        badge_text,
        fill=(255, 255, 255, 255),
        font=font_badge
    )

    cur_y += badge_h + int(18 * SCALE)

    # Brand Title: "Nikahin" with Logo
    logo_path = "landing-page/public/assets/nikahin-symbol-master-512.png"
    logo_size = int(48 * SCALE)
    if os.path.exists(logo_path):
        logo_icon = Image.open(logo_path).convert("RGBA")
        logo_icon = logo_icon.resize((logo_size, logo_size), Image.Resampling.LANCZOS)
        card_img.paste(logo_icon, (pad_left, cur_y - int(4 * SCALE)), logo_icon)
        text_x = pad_left + logo_size + int(12 * SCALE)
    else:
        text_x = pad_left

    card_draw.text((text_x, cur_y - int(8 * SCALE)), "Nikahin", fill=(74, 19, 40, 255), font=font_brand_title)
    brand_bbox = card_draw.textbbox((text_x, cur_y - int(8 * SCALE)), "Nikahin", font=font_brand_title)
    
    cur_y = brand_bbox[3] + int(16 * SCALE)

    # Tagline (Editorial, Bold & Clean)
    tagline_text = "Rencanakan hari bahagia berdua\nlebih rapi, tenang, dan bebas stres."
    card_draw.text((pad_left, cur_y), tagline_text, fill=(15, 23, 42, 255), font=font_tagline, spacing=int(6 * SCALE))
    tag_bbox = card_draw.textbbox((pad_left, cur_y), tagline_text, font=font_tagline, spacing=int(6 * SCALE))
    cur_y = tag_bbox[3] + int(14 * SCALE)

    # Value details
    body_text = "Kelola anggaran, termin vendor, rundown, buku tamu,\ndan seserahan tersinkronisasi 2 akun secara real-time."
    card_draw.text((pad_left, cur_y), body_text, fill=(100, 116, 139, 255), font=font_body, spacing=int(4 * SCALE))
    body_bbox = card_draw.textbbox((pad_left, cur_y), body_text, font=font_body, spacing=int(4 * SCALE))
    cur_y = body_bbox[3] + int(24 * SCALE)

    # Horizontal Divider Line
    divider_w = int(500 * SCALE)
    card_draw.line(
        [(pad_left, cur_y), (pad_left + divider_w, cur_y)],
        fill=(226, 232, 240, 255),
        width=int(1.5 * SCALE)
    )
    cur_y += int(20 * SCALE)

    # Social Proof / Rating: "★ 4.9 (1.200+ Pasangan)"
    star_icon = "★"
    card_draw.text((pad_left, cur_y), star_icon, fill=(245, 158, 11, 255), font=font_rating)
    star_bbox = card_draw.textbbox((pad_left, cur_y), star_icon, font=font_rating)
    card_draw.text(
        (star_bbox[2] + int(8 * SCALE), cur_y),
        "4.9 / 5.0 (1.200+ Calon Pengantin)",
        fill=(30, 41, 59, 255),
        font=font_rating
    )
    cur_y += int(34 * SCALE)

    # Price & CTA Button Row
    # Strikethrough original price
    strike_text = "Rp 99.000"
    strike_bbox = card_draw.textbbox((pad_left, cur_y), strike_text, font=font_price_strike)
    card_draw.text((pad_left, cur_y), strike_text, fill=(148, 163, 184, 255), font=font_price_strike)
    strike_y = (strike_bbox[1] + strike_bbox[3]) // 2
    card_draw.line([(strike_bbox[0], strike_y), (strike_bbox[2], strike_y)], fill=(225, 29, 72, 255), width=int(2 * SCALE))

    # Main Price
    price_y = cur_y + int(18 * SCALE)
    price_text = "Rp 39.000"
    card_draw.text((pad_left, price_y), price_text, fill=(15, 23, 42, 255), font=font_price)
    price_bbox = card_draw.textbbox((pad_left, price_y), price_text, font=font_price)
    
    # Unit "/ seumur hidup"
    unit_x = price_bbox[2] + int(8 * SCALE)
    unit_y = price_y + int(8 * SCALE)
    card_draw.text((unit_x, unit_y), "/ seumur hidup", fill=(100, 116, 139, 255), font=font_price_unit)

    # CTA Button on the right of price
    cta_btn_text = "Coba Sekarang  →"
    cta_bbox = card_draw.textbbox((0, 0), cta_btn_text, font=font_cta)
    cta_w = cta_bbox[2] - cta_bbox[0] + int(36 * SCALE)
    cta_h = int(48 * SCALE)
    cta_x = pad_left + int(310 * SCALE)
    cta_y = price_y - int(6 * SCALE)

    card_draw.rounded_rectangle(
        [cta_x, cta_y, cta_x + cta_w, cta_y + cta_h],
        radius=int(14 * SCALE),
        fill=(15, 23, 42, 255)  # High contrast solid black button matching template
    )
    card_draw.text(
        (cta_x + int(18 * SCALE), cta_y + int(13 * SCALE)),
        cta_btn_text,
        fill=(255, 255, 255, 255),
        font=font_cta
    )

    # Footer note under price & CTA
    footer_y = price_y + int(46 * SCALE)
    card_draw.text(
        (pad_left, footer_y),
        "Tersedia untuk Android & iOS  •  getnikahin.my.id",
        fill=(148, 163, 184, 255),
        font=font_platform
    )

    # 4. RIGHT COLUMN (Mockup Smartphone Beranda Spill)
    phone_x = int(600 * SCALE)
    phone_y = int(24 * SCALE)
    phone_w = int(390 * SCALE)
    phone_h = int(470 * SCALE)  # Flows naturally inside card
    phone_corner = int(32 * SCALE)

    # Smartphone Outer Frame (Modern titanium dark frame)
    phone_img = Image.new("RGBA", (phone_w, phone_h), (0, 0, 0, 0))
    p_draw = ImageDraw.Draw(phone_img)

    # Phone outer shadow
    phone_bezel = int(10 * SCALE)
    p_draw.rounded_rectangle(
        [0, 0, phone_w - 1, phone_h - 1],
        radius=phone_corner,
        fill=(15, 23, 42, 255),  # Sleek dark midnight slate bezel
        outline=(51, 65, 85, 255),
        width=int(2 * SCALE)
    )

    # Inner Screen dimensions
    screen_x = phone_bezel
    screen_y = phone_bezel
    screen_w = phone_w - (2 * phone_bezel)
    screen_h = phone_h - (2 * phone_bezel)
    screen_corner = phone_corner - int(4 * SCALE)

    # Load and insert Beranda.jpeg screenshot
    beranda_path = "assets/images/landpages/Beranda.jpeg"
    if os.path.exists(beranda_path):
        screen_raw = Image.open(beranda_path).convert("RGBA")
        
        # Scale screenshot to fit screen_w exactly
        scale_ratio = screen_w / screen_raw.width
        scaled_h = int(screen_raw.height * scale_ratio)
        scaled_screen = screen_raw.resize((screen_w, scaled_h), Image.Resampling.LANCZOS)
        
        # Crop top section (the header photo, countdown D-Day, and budget card)
        cropped_screen = scaled_screen.crop((0, 0, screen_w, screen_h))

        # Mask with rounded corners
        mask = Image.new("L", (screen_w, screen_h), 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle([0, 0, screen_w, screen_h], radius=screen_corner, fill=255)
        
        phone_img.paste(cropped_screen, (screen_x, screen_y), mask)

        # Dynamic Island / Camera Notch at top center of phone screen
        notch_w = int(64 * SCALE)
        notch_h = int(14 * SCALE)
        notch_x = (phone_w - notch_w) // 2
        notch_y = screen_y + int(6 * SCALE)
        p_draw.rounded_rectangle(
            [notch_x, notch_y, notch_x + notch_w, notch_y + notch_h],
            radius=int(7 * SCALE),
            fill=(10, 10, 15, 255)
        )

        # Subtle bottom home indicator bar
        bar_w = int(90 * SCALE)
        bar_h = int(3 * SCALE)
        bar_x = (phone_w - bar_w) // 2
        bar_y = phone_h - screen_y - int(8 * SCALE)
        p_draw.rounded_rectangle(
            [bar_x, bar_y, bar_x + bar_w, bar_y + bar_h],
            radius=int(2 * SCALE),
            fill=(255, 255, 255, 180)
        )

    # Paste phone onto card
    card_img.paste(phone_img, (phone_x, phone_y), phone_img)

    # 5. Composite Main Card onto Canvas
    canvas.paste(card_img, (card_x1, card_y1), card_img)

    # 6. High Quality Resample down to 1200 x 630 (Lanczos)
    final_card = canvas.resize((WIDTH, HEIGHT), Image.Resampling.LANCZOS)

    # Save to targets
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    final_card.save(output_path, "PNG", optimize=True)
    print(f"Generated OG Image successfully at {output_path} ({os.path.getsize(output_path)} bytes)")

    # Also copy to web assets
    for web_target in ["web/assets/og-image.png", "web/og-image.png"]:
        os.makedirs(os.path.dirname(web_target), exist_ok=True)
        final_card.save(web_target, "PNG", optimize=True)
        print(f"Copied to {web_target}")

if __name__ == "__main__":
    create_og_split_card()
