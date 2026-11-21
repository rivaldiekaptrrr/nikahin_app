import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_og_modern_card(output_path="landing-page/public/assets/og-image.png"):
    # 2x supersampling for ultra-crisp high-DPI rendering (2400 x 1260 -> 1200 x 630)
    WIDTH = 1200
    HEIGHT = 630
    SCALE = 2
    W = WIDTH * SCALE
    H = HEIGHT * SCALE

    # Fonts - Pure Modern Bold Sans-Serif (No wedding serif font)
    font_sans = "assets/fonts/PlusJakartaSans.ttf"

    def get_font(path, size, fallback="arialbd.ttf"):
        try:
            return ImageFont.truetype(path, int(size * SCALE))
        except Exception:
            return ImageFont.truetype(f"C:/Windows/Fonts/{fallback}", int(size * SCALE))

    # Bold Modern Tech Typography
    font_badge = get_font(font_sans, 13, "segoeuib.ttf")
    font_brand_title = get_font(font_sans, 56, "arialbd.ttf")  # Huge bold modern sans-serif
    font_tagline = get_font(font_sans, 19, "segoeuib.ttf")
    font_body = get_font(font_sans, 14.5, "segoeui.ttf")
    font_rating = get_font(font_sans, 16, "segoeuib.ttf")
    font_price_strike = get_font(font_sans, 15, "segoeui.ttf")
    font_price_main = get_font(font_sans, 32, "arialbd.ttf")
    font_price_unit = get_font(font_sans, 15, "segoeuib.ttf")
    font_cta = get_font(font_sans, 17, "segoeuib.ttf")
    font_footer = get_font(font_sans, 12.5, "segoeui.ttf")

    # 1. Base Canvas - High-Energy Modern Tech Amber/Yellow Backdrop
    # Exact inspiration: #F6B819 / #F7BA1E
    canvas = Image.new("RGBA", (W, H), (247, 186, 30, 255))
    canvas_draw = ImageDraw.Draw(canvas)

    # 2. Main White Card Geometry
    card_margin_x = int(44 * SCALE)
    card_margin_y = int(32 * SCALE)
    card_x1 = card_margin_x
    card_y1 = card_margin_y
    card_x2 = W - card_margin_x
    card_y2 = H - card_margin_y
    card_w = card_x2 - card_x1
    card_h = card_y2 - card_y1
    card_radius = int(32 * SCALE)

    # Crisp Neo-Brutalist / Modern SaaS Offset Solid Shadow
    shadow_offset_x = int(14 * SCALE)
    shadow_offset_y = int(18 * SCALE)
    canvas_draw.rounded_rectangle(
        [card_x1 + shadow_offset_x, card_y1 + shadow_offset_y, card_x2 + shadow_offset_x, card_y2 + shadow_offset_y],
        radius=card_radius,
        fill=(15, 23, 42, 255)  # Solid dark slate shadow matching modern tech cards
    )

    # Main Card Base
    card_img = Image.new("RGBA", (card_w, card_h), (255, 255, 255, 255))
    card_draw = ImageDraw.Draw(card_img)

    # Clean Dark Border on White Card
    card_draw.rounded_rectangle(
        [0, 0, card_w - 1, card_h - 1],
        radius=card_radius,
        outline=(15, 23, 42, 255),
        width=int(4 * SCALE)
    )

    # 3. LEFT COLUMN: Modern Tech Copywriting & Deal Specs
    pad_left = int(48 * SCALE)
    cur_y = int(44 * SCALE)

    # Pill: "LIFETIME DEAL"
    badge_text = "LIFETIME DEAL"
    badge_bbox = card_draw.textbbox((0, 0), badge_text, font=font_badge)
    badge_w = badge_bbox[2] - badge_bbox[0] + int(28 * SCALE)
    badge_h = badge_bbox[3] - badge_bbox[1] + int(16 * SCALE)
    badge_radius = int(8 * SCALE)

    card_draw.rounded_rectangle(
        [pad_left, cur_y, pad_left + badge_w, cur_y + badge_h],
        radius=badge_radius,
        fill=(15, 23, 42, 255)
    )
    card_draw.text(
        (pad_left + int(14 * SCALE), cur_y + int(7 * SCALE)),
        badge_text,
        fill=(255, 255, 255, 255),
        font=font_badge
    )
    cur_y += badge_h + int(22 * SCALE)

    # Brand Title: "Nikahin" in Bold Modern Sans-Serif
    brand_text = "Nikahin"
    card_draw.text((pad_left, cur_y), brand_text, fill=(15, 23, 42, 255), font=font_brand_title)
    brand_bbox = card_draw.textbbox((pad_left, cur_y), brand_text, font=font_brand_title)
    cur_y = brand_bbox[3] + int(18 * SCALE)

    # Tagline (Direct, Modern, Impactful)
    tagline_text = "Rencanakan pernikahan berdua\nlebih rapi, tenang, dan bebas stres."
    card_draw.text((pad_left, cur_y), tagline_text, fill=(15, 23, 42, 255), font=font_tagline, spacing=int(6 * SCALE))
    tag_bbox = card_draw.textbbox((pad_left, cur_y), tagline_text, font=font_tagline, spacing=int(6 * SCALE))
    cur_y = tag_bbox[3] + int(14 * SCALE)

    # Value details
    body_text = "Kelola bujet, vendor, rundown acara, dan buku tamu\nyang tersinkronisasi 2 akun secara real-time."
    card_draw.text((pad_left, cur_y), body_text, fill=(71, 85, 105, 255), font=font_body, spacing=int(4 * SCALE))
    body_bbox = card_draw.textbbox((pad_left, cur_y), body_text, font=font_body, spacing=int(4 * SCALE))
    cur_y = body_bbox[3] + int(26 * SCALE)

    # Divider Line
    divider_w = int(580 * SCALE)
    card_draw.line(
        [(pad_left, cur_y), (pad_left + divider_w, cur_y)],
        fill=(226, 232, 240, 255),
        width=int(2 * SCALE)
    )
    cur_y += int(22 * SCALE)

    # Social Proof: "★ 4.97 (1.200+ Pasangan)"
    star_icon = "★"
    card_draw.text((pad_left, cur_y), star_icon, fill=(245, 158, 11, 255), font=font_rating)
    star_bbox = card_draw.textbbox((pad_left, cur_y), star_icon, font=font_rating)
    card_draw.text(
        (star_bbox[2] + int(8 * SCALE), cur_y),
        "4.9 / 5.0 (1.200+ Calon Pengantin)",
        fill=(15, 23, 42, 255),
        font=font_rating
    )
    cur_y += int(38 * SCALE)

    # Price & Call to Action (CTA) Section
    # Original Strikethrough Price
    strike_text = "Rp 99.000"
    strike_bbox = card_draw.textbbox((pad_left, cur_y), strike_text, font=font_price_strike)
    card_draw.text((pad_left, cur_y), strike_text, fill=(148, 163, 184, 255), font=font_price_strike)
    strike_mid_y = (strike_bbox[1] + strike_bbox[3]) // 2
    card_draw.line([(strike_bbox[0], strike_mid_y), (strike_bbox[2], strike_mid_y)], fill=(225, 29, 72, 255), width=int(2 * SCALE))

    # Big Deal Price
    price_y = cur_y + int(18 * SCALE)
    price_text = "Rp 39.000"
    card_draw.text((pad_left, price_y), price_text, fill=(15, 23, 42, 255), font=font_price_main)
    price_bbox = card_draw.textbbox((pad_left, price_y), price_text, font=font_price_main)

    # Unit text
    unit_x = price_bbox[2] + int(10 * SCALE)
    unit_y = price_y + int(10 * SCALE)
    card_draw.text((unit_x, unit_y), "/ seumur hidup", fill=(100, 116, 139, 255), font=font_price_unit)

    # High-Converting Solid CTA Button: "[ Coba Sekarang  → ]"
    cta_text = "Coba Sekarang  →"
    cta_bbox = card_draw.textbbox((0, 0), cta_text, font=font_cta)
    cta_w = cta_bbox[2] - cta_bbox[0] + int(42 * SCALE)
    cta_h = int(54 * SCALE)
    cta_x = pad_left + int(360 * SCALE)
    cta_y = price_y - int(4 * SCALE)

    card_draw.rounded_rectangle(
        [cta_x, cta_y, cta_x + cta_w, cta_y + cta_h],
        radius=int(14 * SCALE),
        fill=(15, 23, 42, 255)  # Modern solid dark button matching template
    )
    card_draw.text(
        (cta_x + int(21 * SCALE), cta_y + int(15 * SCALE)),
        cta_text,
        fill=(255, 255, 255, 255),
        font=font_cta
    )

    # Platform note
    footer_y = price_y + int(56 * SCALE)
    card_draw.text(
        (pad_left, footer_y),
        "Tersedia untuk Android & iPhone  •  getnikahin.my.id",
        fill=(148, 163, 184, 255),
        font=font_footer
    )

    # 4. RIGHT COLUMN: Modern Flagship Smartphone (True Portrait iPhone Ratio ~ 9:19.5)
    # Card Height is card_h = 1132px (at 2x)
    # Phone height is 480 * SCALE = 960px.
    # Standard portrait ratio (9:19.5): Phone width is 960 * 9 / 19.5 ≈ 443px!
    phone_w = int(224 * SCALE)   # ~448px (Exact slender iPhone portrait aspect ratio)
    phone_h = int(485 * SCALE)   # ~970px
    phone_x = card_w - phone_w - int(44 * SCALE)
    phone_y = (card_h - phone_h) // 2
    phone_corner = int(38 * SCALE)

    # Phone Frame Layer
    phone_frame = Image.new("RGBA", (phone_w, phone_h), (0, 0, 0, 0))
    p_draw = ImageDraw.Draw(phone_frame)

    # Phone Outer Bezel (Modern Midnight Titanium)
    p_draw.rounded_rectangle(
        [0, 0, phone_w - 1, phone_h - 1],
        radius=phone_corner,
        fill=(15, 23, 42, 255),  # Midnight Titanium
        outline=(51, 65, 85, 255),
        width=int(2 * SCALE)
    )

    # Screen Geometry
    bezel_size = int(8 * SCALE)
    screen_x = bezel_size
    screen_y = bezel_size
    screen_w = phone_w - (2 * bezel_size)
    screen_h = phone_h - (2 * bezel_size)
    screen_corner = phone_corner - int(4 * SCALE)

    # Render Actual App Beranda Screenshot inside iPhone Screen
    beranda_path = "assets/images/landpages/Beranda.jpeg"
    if os.path.exists(beranda_path):
        screen_raw = Image.open(beranda_path).convert("RGBA")
        
        # Cover screen_w and screen_h exactly
        scale_ratio = max(screen_w / screen_raw.width, screen_h / screen_raw.height)
        scaled_w = int(screen_raw.width * scale_ratio)
        scaled_h = int(screen_raw.height * scale_ratio)
        scaled_screen = screen_raw.resize((scaled_w, scaled_h), Image.Resampling.LANCZOS)
        
        # Crop to exact screen dimensions
        crop_left = max(0, (scaled_w - screen_w) // 2)
        crop_top = 0
        cropped_screen = scaled_screen.crop((crop_left, crop_top, crop_left + screen_w, crop_top + screen_h))

        # Screen mask with rounded corners
        mask = Image.new("L", (screen_w, screen_h), 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle([0, 0, screen_w, screen_h], radius=screen_corner, fill=255)

        phone_frame.paste(cropped_screen, (screen_x, screen_y), mask)

        # Dynamic Island Pill (Top Center)
        island_w = int(58 * SCALE)
        island_h = int(14 * SCALE)
        island_x = (phone_w - island_w) // 2
        island_y = screen_y + int(7 * SCALE)
        p_draw.rounded_rectangle(
            [island_x, island_y, island_x + island_w, island_y + island_h],
            radius=int(7 * SCALE),
            fill=(10, 10, 15, 255)
        )

        # Bottom iOS Home Indicator Bar
        home_bar_w = int(72 * SCALE)
        home_bar_h = int(3 * SCALE)
        home_bar_x = (phone_w - home_bar_w) // 2
        home_bar_y = phone_h - screen_y - int(8 * SCALE)
        p_draw.rounded_rectangle(
            [home_bar_x, home_bar_y, home_bar_x + home_bar_w, home_bar_y + home_bar_h],
            radius=int(2 * SCALE),
            fill=(255, 255, 255, 180)
        )

    # Phone Floating Drop Shadow onto White Card
    phone_shadow_offset_x = int(12 * SCALE)
    phone_shadow_offset_y = int(14 * SCALE)
    card_draw.rounded_rectangle(
        [phone_x + phone_shadow_offset_x, phone_y + phone_shadow_offset_y, phone_x + phone_w + phone_shadow_offset_x, phone_y + phone_h + phone_shadow_offset_y],
        radius=phone_corner,
        fill=(203, 213, 225, 180)
    )

    # Paste Phone Frame onto Card
    card_img.paste(phone_frame, (phone_x, phone_y), phone_frame)

    # 5. Composite Card onto Canvas
    canvas.paste(card_img, (card_x1, card_y1), card_img)

    # 6. Downscale to exact 1200 x 630 with high-precision Lanczos
    final_card = canvas.resize((WIDTH, HEIGHT), Image.Resampling.LANCZOS)

    # Save to targets
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    final_card.save(output_path, "PNG", optimize=True)
    print(f"Generated Modern Tech OG Image successfully at {output_path} ({os.path.getsize(output_path)} bytes)")

    for web_target in ["web/assets/og-image.png", "web/og-image.png"]:
        os.makedirs(os.path.dirname(web_target), exist_ok=True)
        final_card.save(web_target, "PNG", optimize=True)
        print(f"Copied to {web_target}")

if __name__ == "__main__":
    create_og_modern_card()
