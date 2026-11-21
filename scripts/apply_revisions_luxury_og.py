import base64
import os
import re

def apply_revisions():
    # 1. Read base64 assets
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

    # 3. Update CSS in reference-og-card.html
    # Update .og-left width and padding
    html = re.sub(
        r'\.og-left\s*\{[^}]*\}',
        '''.og-left {
            width: 640px;
            height: 100%;
            padding: 50px 48px 48px 56px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }''',
        html
    )

    # Update .og-headline font size
    html = re.sub(
        r'\.og-headline\s*\{[^}]*\}',
        '''.og-headline {
            font-family: 'Playfair Display', Georgia, serif;
            font-size: 46px;
            font-weight: 600;
            line-height: 1.15;
            color: #F8F5F0;
            letter-spacing: -0.015em;
            margin: 0;
        }''',
        html
    )

    # Update .og-description
    html = re.sub(
        r'\.og-description\s*\{[^}]*\}',
        '''.og-description {
            font-size: 15px;
            font-weight: 400;
            line-height: 1.62;
            color: #B8B2A8;
            max-width: 535px;
            margin: 0;
        }''',
        html
    )

    # Update price styles (enlarged highlight)
    html = re.sub(
        r'\.og-price-old\s*\{[^}]*\}',
        '''.og-price-old {
            font-size: 19px;
            font-weight: 600;
            color: #9C9488;
            text-decoration: line-through;
            text-decoration-color: #E11D48;
            text-decoration-thickness: 2px;
            line-height: 1;
        }''',
        html
    )

    html = re.sub(
        r'\.og-discount-pill\s*\{[^}]*\}',
        '''.og-discount-pill {
            font-size: 12.5px;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #F8E39D;
            border: 1.5px solid #DFB951;
            background-color: rgba(212, 175, 55, 0.16);
            padding: 4px 10px;
            border-radius: 5px;
            line-height: 1;
            box-shadow: 0 2px 8px rgba(223, 185, 81, 0.15);
        }''',
        html
    )

    html = re.sub(
        r'\.og-price-now\s*\{[^}]*\}',
        '''.og-price-now {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 46px;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: -0.03em;
            line-height: 1;
        }''',
        html
    )

    html = re.sub(
        r'\.og-price-unit\s*\{[^}]*\}',
        '''.og-price-unit {
            font-size: 15.5px;
            font-weight: 600;
            color: #DFBE6F;
            line-height: 1;
        }''',
        html
    )

    # Update .og-cta-btn padding and font
    html = re.sub(
        r'\.og-cta-btn\s*\{[^}]*\}',
        '''.og-cta-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background-color: #DFB951;
            color: #0F0D0B;
            font-size: 15.5px;
            font-weight: 800;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            padding: 17px 32px;
            border-radius: 6px;
            line-height: 1;
            white-space: nowrap;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.45);
            transition: background-color 0.2s ease;
        }''',
        html
    )

    # Update .og-right (shift phone left to center in background area)
    html = re.sub(
        r'\.og-right\s*\{[^}]*\}',
        '''.og-right {
            flex: 1;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }''',
        html
    )

    # 4. Update the Headline & Description in HTML
    headline_pattern = r'<h1 class="og-headline">.*?</h1>'
    new_headline = '<h1 class="og-headline">Nikahin — Wedding Planner.</h1>'
    html = re.sub(headline_pattern, new_headline, html, count=1, flags=re.DOTALL)

    desc_pattern = r'<p class="og-description">.*?</p>'
    new_desc = '<p class="og-description">Tautkan akun Anda dan pasangan secara real-time untuk mencatat anggaran, vendor, susunan acara, hingga buku tamu digital. Bebas pilih tema visual pernikahan, sekali bayar tanpa biaya bulanan.</p>'
    html = re.sub(desc_pattern, new_desc, html, count=1, flags=re.DOTALL)

    # Save reference-og-card.html
    with open(ref_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print("Updated scripts/reference-og-card.html with all 4 revisions!")

    # 5. Generate fresh standalone HTML for capture
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
    apply_revisions()
