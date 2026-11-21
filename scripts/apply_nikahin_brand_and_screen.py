import base64
import os
import re

def update_og_card_with_brand_and_screen():
    # 1. Load Assets as base64 for standalone rendering
    with open('landing-page/public/assets/nikahin-symbol-master-512.png', 'rb') as f:
        logo_b64 = base64.b64encode(f.read()).decode('utf-8')
    logo_data_uri = f"data:image/png;base64,{logo_b64}"

    with open('assets/images/landpages/Beranda.jpeg', 'rb') as f:
        beranda_b64 = base64.b64encode(f.read()).decode('utf-8')
    beranda_data_uri = f"data:image/jpeg;base64,{beranda_b64}"

    with open('landing-page/public/assets/og-bg.jpg', 'rb') as f:
        bg_b64 = base64.b64encode(f.read()).decode('utf-8')
    bg_data_uri = f"data:image/jpeg;base64,{bg_b64}"

    # 2. Read reference-og-card.html
    ref_path = 'scripts/reference-og-card.html'
    with open(ref_path, 'r', encoding='utf-8') as f:
        html = f.read()

    # 3. Add brand header styling in CSS if not present
    brand_css = """
        /* Brand Identity Lockup (Logo + Wordmark) */
        .og-brand-header {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .og-brand-lockup {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .og-logo-box {
            width: 38px;
            height: 38px;
            border-radius: 11px;
            background: #1C1612;
            border: 1.5px solid rgba(212, 175, 55, 0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
            flex-shrink: 0;
        }

        .og-logo-img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .og-brand-title {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 24px;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: -0.025em;
            line-height: 1;
        }

        .og-eyebrow-pill {
            font-size: 10.5px;
            font-weight: 700;
            letter-spacing: 0.16em;
            text-transform: uppercase;
            color: #D4AF37;
            background: rgba(212, 175, 55, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.35);
            padding: 5px 11px;
            border-radius: 6px;
            line-height: 1;
        }
    """

    if '.og-brand-header' not in html:
        html = html.replace('.og-left {', f'{brand_css}\n        .og-left {{')

    # 4. Replace Top Accent in HTML with Brand Lockup
    old_accent_pattern = r'<!-- 1\. Top Gold Accent Line & Eyebrow \(No Price\) -->\s*<div class="og-top-accent">.*?</div>\s*</div>'
    new_accent_html = f'''<!-- 1. Brand Identity Header (Official Master Logo + Brand Name "Nikahin") -->
              <div class="og-brand-header">
                <div class="og-brand-lockup">
                  <div class="og-logo-box">
                    <img src="../landing-page/public/assets/nikahin-symbol-master-512.png" alt="Logo Nikahin" class="og-logo-img" />
                  </div>
                  <span class="og-brand-title">Nikahin</span>
                </div>
                <div class="og-gold-rule" style="width: 20px; height: 1.5px; background-color: rgba(212, 175, 55, 0.4);"></div>
                <div class="og-eyebrow-pill">LIFETIME ACCESS &nbsp;•&nbsp; ANDROID &amp; IPHONE</div>
              </div>'''
    
    html = re.sub(old_accent_pattern, new_accent_html, html, flags=re.DOTALL)

    # 5. Inject Real Beranda Screenshot into Phone Screen
    old_phone_screen_pattern = r'<!-- Custom Uploaded Screenshot Image -->\s*<img id="custom-screen-img"[^>]*>.*?<!-- Bottom Home Indicator Bar -->'
    new_phone_screen_html = f'''<!-- Custom Uploaded Screenshot Image (Real Beranda Nikahin) -->
                  <img id="custom-screen-img" src="../assets/images/landpages/Beranda.jpeg" alt="Nikahin App Beranda Screenshot" style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: top center; z-index: 20; display: block;" />

                  <!-- Built-in Warm Luxury Cream/Champagne/Rose "Nikahin" Beranda UI (Hidden) -->
                  <div id="builtin-mockup-ui" class="w-full h-full flex flex-col" style="display: none; background-color: #FAF7F2; color: #1C1612;">
                  </div>

                  <!-- Bottom Home Indicator Bar -->'''
    
    html = re.sub(old_phone_screen_pattern, new_phone_screen_html, html, flags=re.DOTALL)

    # Save reference-og-card.html
    with open(ref_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print("Updated scripts/reference-og-card.html with brand lockup and real Beranda screen!")

    # 6. Generate standalone HTML for Playwright capture
    style_match = re.search(r'<style>(.*?)</style>', html, re.DOTALL)
    styles = style_match.group(1) if style_match else ""

    start = html.find('<div id="og-card">')
    end = html.find('<!-- ========================================================== -->', start)
    card_html = html[start:end].strip()

    # In standalone, inject base64 data URIs so there's zero network delay or missing file issues
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
    <title>Nikahin — Luxury Editorial Open Graph Card (1200×630)</title>
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
    print("Generated fresh scripts/reference-og-card-standalone.html!")

if __name__ == '__main__':
    update_og_card_with_brand_and_screen()
