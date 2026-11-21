import base64
import os
import re

def main():
    # 1. Read og-bg.jpg as base64
    bg_path = 'landing-page/public/assets/og-bg.jpg'
    if not os.path.exists(bg_path):
        raise FileNotFoundError(f"Missing {bg_path}")
    with open(bg_path, 'rb') as f:
        bg_b64 = base64.b64encode(f.read()).decode('utf-8')
    bg_data_uri = f"data:image/jpeg;base64,{bg_b64}"

    # 2. Read reference-og-card.html
    ref_path = 'scripts/reference-og-card.html'
    with open(ref_path, 'r', encoding='utf-8') as f:
        html = f.read()

    # 3. Extract exact styles
    style_match = re.search(r'<style>(.*?)</style>', html, re.DOTALL)
    styles = style_match.group(1) if style_match else ""

    # 4. Extract exact #og-card block
    start = html.find('<div id="og-card">')
    end = html.find('<!-- ========================================================== -->', start)
    if start == -1 or end == -1:
        raise ValueError("Could not find exact #og-card bounds")
    card_html = html[start:end].strip()

    # 5. Inject og-bg.jpg as base64 into #og-bg-photo
    bg_photo_pattern = r'<img\s+id="og-bg-photo"[^>]*>'
    card_html = re.sub(
        bg_photo_pattern,
        f'<img id="og-bg-photo" src="{bg_data_uri}" alt="Wedding Couple Background" />',
        card_html,
        count=1
    )

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
    print("Generated perfect scripts/reference-og-card-standalone.html successfully!")

if __name__ == '__main__':
    main()
