import base64
import os
import re

def prepare_standalone_html():
    with open('landing-page/public/assets/nikahin-symbol-master-512.png', 'rb') as f:
        logo_b64 = base64.b64encode(f.read()).decode('utf-8')

    with open('assets/images/landpages/Beranda.jpeg', 'rb') as f:
        beranda_b64 = base64.b64encode(f.read()).decode('utf-8')

    # Read from master reference-og-card.html to ensure clean base every time
    with open('scripts/reference-og-card.html', 'r', encoding='utf-8') as f:
        html = f.read()

    # 1. Simplify body for exact 1200x630 capture (no header, no margins, no wrappers)
    # Extract style block
    style_match = re.search(r'<style>(.*?)</style>', html, re.DOTALL)
    styles = style_match.group(1) if style_match else ""

    # Adjust body style in styles
    styles = styles.replace(
        "body {\n            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;\n            margin: 0;\n            padding: 0;\n            transition: background-color 0.25s ease, color 0.25s ease;\n        }",
        "body {\n            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;\n            margin: 0;\n            padding: 0;\n            width: 1200px;\n            height: 630px;\n            overflow: hidden;\n            background-color: #F7BA1E;\n        }"
    )

    # Extract og-canvas HTML block
    canvas_match = re.search(r'(<div id="og-canvas">.*?<!-- ============================================================ -->)', html, re.DOTALL)
    if not canvas_match:
        canvas_match = re.search(r'(<div id="og-canvas">.*?</div>\s*</div>\s*</div>)', html, re.DOTALL)
    
    canvas_html = canvas_match.group(1) if canvas_match else ""

    # 2. Replace App Icon SVG with Real Official Nikahin Master Logo
    app_icon_pattern = r'<div class="og-app-icon">.*?</div>'
    new_app_icon = f'''<div class="og-app-icon" style="background: #FDF0DE; padding: 4px; border: 2.5px solid #0F172A; box-shadow: 3px 3px 0px #0F172A;">
                                <img src="data:image/png;base64,{logo_b64}" alt="Nikahin Official Logo" style="width: 100%; height: 100%; object-fit: contain;" />
                            </div>'''
    canvas_html = re.sub(app_icon_pattern, new_app_icon, canvas_html, count=1, flags=re.DOTALL)

    # 3. Inject Real Beranda Screenshot into Phone Screen and Hide Built-in Mockup
    screen_pattern = r'<img id="custom-screen-img".*?>\s*<!-- Built-in Rich "Nikahin" Beranda UI Mockup -->\s*<div id="builtin-mockup-ui".*?>'
    new_screen = f'''<img id="custom-screen-img" src="data:image/jpeg;base64,{beranda_b64}" alt="Nikahin Beranda Screenshot" style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: top center; z-index: 20; display: block;" />
                                <!-- Built-in Rich "Nikahin" Beranda UI Mockup (Hidden) -->
                                <div id="builtin-mockup-ui" class="w-full h-full flex flex-col bg-[#F8FAFC]" style="display: none;">'''
    
    canvas_html = re.sub(screen_pattern, new_screen, canvas_html, count=1, flags=re.DOTALL)

    # Build standalone HTML
    standalone_html = f'''<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nikahin — Open Graph Card (1200×630)</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
{styles}
    </style>
</head>
<body>
{canvas_html}
</body>
</html>
'''

    with open('scripts/reference-og-card-standalone.html', 'w', encoding='utf-8') as f:
        f.write(standalone_html)

    print("Generated fresh scripts/reference-og-card-standalone.html successfully!")

if __name__ == '__main__':
    prepare_standalone_html()
