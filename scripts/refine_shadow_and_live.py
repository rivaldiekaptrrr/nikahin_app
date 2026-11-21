import base64
import os
import re

def refine_gradient():
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

    # 3. Pull the black shadow back to the left:
    # Solid black only up to 45%, fading rapidly by 52%-62%, leaving the photo crisp and bright from 65% onwards!
    new_gradient = """#og-gradient-overlay {
            position: absolute;
            inset: 0;
            z-index: 2;
            background:
                linear-gradient(90deg,
                    #090807 0%,
                    #090807 45%,
                    rgba(9, 8, 7, 0.88) 52%,
                    rgba(9, 8, 7, 0.40) 62%,
                    rgba(9, 8, 7, 0.12) 75%,
                    rgba(9, 8, 7, 0.02) 100%),
                radial-gradient(ellipse at 82% 50%,
                    rgba(212, 175, 55, 0.06) 0%,
                    rgba(9, 8, 7, 0.20) 86%);
        }"""
    html = re.sub(r'#og-gradient-overlay\s*\{[^}]*\}', new_gradient, html)

    # Also update the updateGradientDarkness JS function to reflect this cleaner, softer baseline
    js_func = """function updateGradientDarkness(val) {
      const num = Number(val);
      document.getElementById('darkness-val').textContent = `${num}%`;

      const factor = (num - 50) / 50; // -1 to +1
      const midAlpha = Math.min(0.98, Math.max(0.60, 0.88 + factor * 0.12));
      const fadeAlpha = Math.min(0.75, Math.max(0.18, 0.40 + factor * 0.22));
      const rightAlpha = Math.min(0.40, Math.max(0.01, 0.02 + factor * 0.10));

      const overlay = document.getElementById('og-gradient-overlay');
      overlay.style.background = `
        linear-gradient(
          90deg,
          #090807 0%,
          #090807 45%,
          rgba(9, 8, 7, ${midAlpha.toFixed(2)}) 52%,
          rgba(9, 8, 7, ${fadeAlpha.toFixed(2)}) 62%,
          rgba(9, 8, 7, ${rightAlpha.toFixed(2)}) 100%
        ),
        radial-gradient(
          ellipse at 82% 50%,
          rgba(212, 175, 55, 0.06) 0%,
          rgba(9, 8, 7, 0.20) 86%
        )
      `;
    }"""
    html = re.sub(r'function updateGradientDarkness\(val\)\s*\{.*?overlay\.style\.background\s*=\s*`.*?`;\s*\}', js_func, html, flags=re.DOTALL)

    # Ensure .og-left keeps its spacious width (680px) and padding so price never breaks
    new_left = """.og-left {
            width: 675px;
            height: 100%;
            padding: 48px 36px 46px 56px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }"""
    html = re.sub(r'\.og-left\s*\{[^}]*\}', new_left, html)

    # Save reference-og-card.html
    with open(ref_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print("Updated scripts/reference-og-card.html with pulled-back dark shadow!")

    # 4. Generate standalone HTML for Playwright capture
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
    refine_gradient()

