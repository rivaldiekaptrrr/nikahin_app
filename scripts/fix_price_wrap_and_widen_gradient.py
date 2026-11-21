import base64
import os
import re

def fix_price_and_widen_gradient():
    # 1. Load assets
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

    # 3. Update Gradient Overlay: expand dark vignette further to the right (up to ~56-58% solid black)
    new_gradient = """#og-gradient-overlay {
            position: absolute;
            inset: 0;
            z-index: 2;
            background:
                linear-gradient(90deg,
                    #090807 0%,
                    #090807 56%,
                    rgba(9, 8, 7, 0.95) 64%,
                    rgba(9, 8, 7, 0.58) 78%,
                    rgba(9, 8, 7, 0.18) 90%,
                    rgba(9, 8, 7, 0.10) 100%),
                radial-gradient(ellipse at 84% 50%,
                    rgba(212, 175, 55, 0.08) 0%,
                    rgba(9, 8, 7, 0.36) 86%);
        }"""
    html = re.sub(r'#og-gradient-overlay\s*\{[^}]*\}', new_gradient, html)

    # 4. Widen .og-left from 640px to 695px with balanced padding
    new_left = """.og-left {
            width: 695px;
            height: 100%;
            padding: 48px 36px 46px 56px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }"""
    html = re.sub(r'\.og-left\s*\{[^}]*\}', new_left, html)

    # 5. Fix price layout: prevent wrapping, seamless single-line alignment
    new_price_callout = """.og-price-callout {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex-shrink: 0;
        }"""
    html = re.sub(r'\.og-price-callout\s*\{[^}]*\}', new_price_callout, html)

    new_price_bottom = """.og-price-bottom {
            display: flex;
            align-items: baseline;
            gap: 10px;
            white-space: nowrap;
        }"""
    html = re.sub(r'\.og-price-bottom\s*\{[^}]*\}', new_price_bottom, html)

    new_price_now = """.og-price-now {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 44px;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: -0.03em;
            line-height: 1;
            white-space: nowrap;
        }"""
    html = re.sub(r'\.og-price-now\s*\{[^}]*\}', new_price_now, html)

    new_cta_row = """.og-cta-row {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 32px;
            max-width: 600px;
        }"""
    html = re.sub(r'\.og-cta-row\s*\{[^}]*\}', new_cta_row, html)

    # 6. Center .og-right phone
    new_right = """.og-right {
            flex: 1;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }"""
    html = re.sub(r'\.og-right\s*\{[^}]*\}', new_right, html)

    # Save reference-og-card.html
    with open(ref_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print("Updated scripts/reference-og-card.html successfully!")

    # 7. Generate standalone HTML for capture
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
    print("Generated fresh scripts/reference-og-card-standalone.html successfully!")

if __name__ == '__main__':
    fix_price_and_widen_gradient()

