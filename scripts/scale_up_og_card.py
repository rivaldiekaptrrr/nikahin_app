import base64
import os
import re
from playwright.sync_api import sync_playwright

def apply_scale_up_plus_20():
    print("Reading reference files and assets...")
    # 1. Load base64 assets
    with open('landing-page/public/assets/nikahin-symbol-master-512.png', 'rb') as f:
        logo_b64 = base64.b64encode(f.read()).decode('utf-8')
    logo_data_uri = f"data:image/png;base64,{logo_b64}"

    with open('assets/images/landpages/Beranda.jpeg', 'rb') as f:
        beranda_b64 = base64.b64encode(f.read()).decode('utf-8')
    beranda_data_uri = f"data:image/jpeg;base64,{beranda_b64}"

    with open('landing-page/public/assets/og-bg.jpg', 'rb') as f:
        bg_b64 = base64.b64encode(f.read()).decode('utf-8')
    bg_data_uri = f"data:image/jpeg;base64,{bg_b64}"

    # 2. Read scripts/reference-og-card.html
    ref_path = 'scripts/reference-og-card.html'
    with open(ref_path, 'r', encoding='utf-8') as f:
        html = f.read()

    # --- CSS Updates (Scaled up +20%) ---

    # A. Scale up .og-logo-box: from 50px to 58px
    old_logo_box = r'\.og-logo-box\s*\{[^}]*\}'
    new_logo_box = """.og-logo-box {
            width: 58px;
            height: 58px;
            border-radius: 15px;
            background: #1C1612;
            border: 1.5px solid rgba(212, 175, 55, 0.55);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 6px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.6);
            flex-shrink: 0;
        }"""
    html = re.sub(old_logo_box, new_logo_box, html)

    # B. Scale up .og-brand-title: from 32px to 38px
    old_brand_title = r'\.og-brand-title\s*\{[^}]*\}'
    new_brand_title = """.og-brand-title {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 38px;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: -0.025em;
            line-height: 1;
        }"""
    html = re.sub(old_brand_title, new_brand_title, html)

    # C. Scale up .og-eyebrow-pill: from 13px to 15.5px
    old_pill = r'\.og-eyebrow-pill\s*\{[^}]*\}'
    new_pill = """.og-eyebrow-pill {
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0.10em;
            text-transform: uppercase;
            color: #D4AF37;
            background: rgba(212, 175, 55, 0.12);
            border: 1.5px solid rgba(212, 175, 55, 0.45);
            padding: 8px 16px;
            border-radius: 8px;
            line-height: 1;
        }"""
    html = re.sub(old_pill, new_pill, html)

    # D. Scale up .og-brand-header gap
    old_header = r'\.og-brand-header\s*\{[^}]*\}'
    new_header = """.og-brand-header {
            display: flex;
            align-items: center;
            gap: 18px;
        }"""
    html = re.sub(old_header, new_header, html)

    old_lockup = r'\.og-brand-lockup\s*\{[^}]*\}'
    new_lockup = """.og-brand-lockup {
            display: flex;
            align-items: center;
            gap: 14px;
        }"""
    html = re.sub(old_lockup, new_lockup, html)

    # E. Headline: scale to 50px
    old_headline = r'\.og-headline\s*\{[^}]*\}'
    new_headline = """.og-headline {
            font-family: 'Playfair Display', Georgia, serif;
            font-size: 50px;
            font-weight: 600;
            line-height: 1.15;
            color: #F8F5F0;
            letter-spacing: -0.015em;
            margin: 0;
        }"""
    html = re.sub(old_headline, new_headline, html)

    # F. Scale up .og-description: from 20px to 23.5px with higher contrast
    old_desc = r'\.og-description\s*\{[^}]*\}'
    new_desc = """.og-description {
            font-size: 23px;
            font-weight: 500;
            line-height: 1.55;
            color: #D4CDC2;
            max-width: 595px;
            margin: 0;
        }"""
    html = re.sub(old_desc, new_desc, html)

    # G. Scale up .og-footer-proof: from 16.5px to 19.5px
    old_footer = r'\.og-footer-proof\s*\{[^}]*\}'
    new_footer = """.og-footer-proof {
            display: flex;
            align-items: center;
            gap: 14px;
            font-size: 19.5px;
            font-weight: 500;
            color: #B5AEA1;
            line-height: 1.2;
        }"""
    html = re.sub(old_footer, new_footer, html)

    # H. Scale up Price Row elements:
    # Price old
    old_price_old = r'\.og-price-old\s*\{[^}]*\}'
    new_price_old = """.og-price-old {
            font-size: 22px;
            font-weight: 600;
            color: #A8A094;
            text-decoration: line-through;
            text-decoration-color: #E11D48;
            text-decoration-thickness: 2.5px;
            line-height: 1;
        }"""
    html = re.sub(old_price_old, new_price_old, html)

    # Discount pill
    old_discount_pill = r'\.og-discount-pill\s*\{[^}]*\}'
    new_discount_pill = """.og-discount-pill {
            font-size: 14px;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #F8E39D;
            border: 1.5px solid #DFB951;
            background-color: rgba(212, 175, 55, 0.16);
            padding: 5px 11px;
            border-radius: 6px;
            line-height: 1;
            box-shadow: 0 2px 8px rgba(223, 185, 81, 0.15);
        }"""
    html = re.sub(old_discount_pill, new_discount_pill, html)

    # Price now
    old_price_now = r'\.og-price-now\s*\{[^}]*\}'
    new_price_now = """.og-price-now {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 48px;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: -0.03em;
            line-height: 1;
            white-space: nowrap;
        }"""
    html = re.sub(old_price_now, new_price_now, html)

    # Price unit
    old_price_unit = r'\.og-price-unit\s*\{[^}]*\}'
    new_price_unit = """.og-price-unit {
            font-size: 18px;
            font-weight: 600;
            color: #DFBE6F;
            line-height: 1;
        }"""
    html = re.sub(old_price_unit, new_price_unit, html)

    # CTA button
    old_cta_btn = r'\.og-cta-btn\s*\{[^}]*\}'
    new_cta_btn = """.og-cta-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            background-color: #DFB951;
            color: #0F0D0B;
            font-size: 16.5px;
            font-weight: 800;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            padding: 18px 34px;
            border-radius: 7px;
            line-height: 1;
            white-space: nowrap;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.45);
            transition: background-color 0.2s ease;
        }"""
    html = re.sub(old_cta_btn, new_cta_btn, html)

    # I. Tune .og-left layout
    old_left = r'\.og-left\s*\{[^}]*\}'
    new_left = """.og-left {
            width: 690px;
            height: 100%;
            padding: 40px 36px 38px 52px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }"""
    html = re.sub(old_left, new_left, html)

    # --- HTML Markup Updates ---

    # 1. Update Eyebrow Pill to "Support Android & iOS"
    old_eyebrow_markup = r'<div class="og-eyebrow-pill">.*?</div>'
    new_eyebrow_markup = '<div class="og-eyebrow-pill">Support Android &amp; iOS</div>'
    html = re.sub(old_eyebrow_markup, new_eyebrow_markup, html)

    # 2. Update divider line in header
    html = re.sub(
        r'<div class="og-gold-rule" style="[^"]*"></div>',
        r'<div class="og-gold-rule" style="width: 26px; height: 2px; background-color: rgba(212, 175, 55, 0.45);"></div>',
        html
    )

    # 3. Update description text (audited via humanizer-indonesia, crisp and impactful)
    old_desc_html = r'<p class="og-description">.*?</p>'
    new_desc_text = '<p class="og-description">Kelola anggaran, vendor, dan susunan acara bersama pasangan secara real-time. Bebas pilih tema visual, aktif selamanya tanpa biaya bulanan.</p>'
    html = re.sub(old_desc_html, new_desc_text, html, flags=re.DOTALL)

    # 4. Update Price Unit to "/ selamanya"
    old_price_unit_markup = r'<span class="og-price-unit">.*?</span>'
    new_price_unit_markup = '<span class="og-price-unit">/ selamanya</span>'
    html = re.sub(old_price_unit_markup, new_price_unit_markup, html)

    # 5. Update footer proof markup with scaled-up inline styles
    old_footer_html = r'<div class="og-footer-proof">.*?</div>'
    new_footer_html = """<div class="og-footer-proof">
                <span style="color: #DFB951; font-size: 22px;">★</span>
                <span style="color: #F4EFEB; font-weight: 700; font-size: 19.5px;">4.9 / 5.0 (1.200+ Pasangan)</span>
                <span style="color: rgba(212, 175, 55, 0.55); font-size: 20px;">•</span>
                <span style="color: #D4CDC2; font-weight: 600; font-size: 19px; letter-spacing: 0.02em;">getnikahin.my.id</span>
              </div>"""
    html = re.sub(old_footer_html, new_footer_html, html, flags=re.DOTALL)

    # Write updated reference-og-card.html
    with open(ref_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print("Updated scripts/reference-og-card.html")

    # 6. Generate standalone HTML
    style_match = re.search(r'<style>(.*?)</style>', html, re.DOTALL)
    styles = style_match.group(1) if style_match else ""

    start = html.find('<div id="og-card">')
    end = html.find('<!-- ========================================================== -->', start)
    card_html = html[start:end].strip()

    # In standalone, inject base64 data URIs
    card_html = re.sub(r'src="\.\./landing-page/public/assets/nikahin-symbol-master-512\.png"', f'src="{logo_data_uri}"', card_html)
    card_html = re.sub(r'src="\.\./assets/images/landpages/Beranda\.jpeg"', f'src="{beranda_data_uri}"', card_html)
    card_html = re.sub(r'src="\.\./landing-page/public/assets/og-bg\.jpg"', f'src="{bg_data_uri}"', card_html)

    body_override = """
        body {
            margin: 0;
            padding: 0;
            width: 1200px;
            height: 630px;
            overflow: hidden;
            background-color: #090807;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
    """

    standalone_html = f'''<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nikahin — Scaled Up Luxury Editorial Open Graph Card (1200×630)</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
{styles}
{body_override}
    </style>
</head>
<body>
{card_html}
</body>
</html>
'''

    with open('scripts/reference-og-card-standalone.html', 'w', encoding='utf-8') as f:
        f.write(standalone_html)
    print("Updated scripts/reference-og-card-standalone.html")

    # 7. Render with Playwright
    print("Rendering high-res screenshot using Playwright...")
    abs_standalone = os.path.abspath('scripts/reference-og-card-standalone.html')
    file_url = f"file:///{abs_standalone.replace(os.sep, '/')}"

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1200, "height": 630}, device_scale_factor=1)
        page.goto(file_url, wait_until="networkidle")
        page.wait_for_timeout(1000)

        card = page.locator("#og-card")
        
        # Save to preview
        preview_path = 'scripts/preview-scaleup.png'
        card.screenshot(path=preview_path)
        print(f"Saved preview to {preview_path}")

        # Also copy to artifact directory for markdown display
        artifact_dir = r"C:\Users\Administrator\.gemini\antigravity\brain\31d9ae96-ec24-48d7-aa5c-30130fc68465"
        artifact_img = os.path.join(artifact_dir, "og-scaleup-review.png")
        card.screenshot(path=artifact_img)
        print(f"Saved artifact preview to {artifact_img}")

        browser.close()

if __name__ == '__main__':
    apply_scale_up_plus_20()
