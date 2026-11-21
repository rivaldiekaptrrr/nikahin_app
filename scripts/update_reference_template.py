import base64
import os
import re

def update_reference_og_card():
    # 1. Read base64 assets
    with open('landing-page/public/assets/nikahin-symbol-master-512.png', 'rb') as f:
        logo_b64 = base64.b64encode(f.read()).decode('utf-8')

    with open('assets/images/landpages/Beranda.jpeg', 'rb') as f:
        beranda_b64 = base64.b64encode(f.read()).decode('utf-8')

    # Read clean template
    with open('scripts/clean_og_card.html', 'r', encoding='utf-8') as f:
        clean_html = f.read()

    # Extract canvas from clean_html
    canvas_match = re.search(r'(<div id="og-canvas">.*?</div>\s*</div>\s*</div>)', clean_html, re.DOTALL)
    if not canvas_match:
        raise ValueError("Could not find og-canvas in clean_og_card.html")
    clean_canvas = canvas_match.group(1)

    # Read reference-og-card.html
    with open('scripts/reference-og-card.html', 'r', encoding='utf-8') as f:
        ref_html = f.read()

    # Replace the old og-canvas inside reference-og-card.html
    # The canvas starts at <!-- EXACT 1200 x 630 MAXIMIZED OPEN GRAPH CARD --> and ends before <!-- ============================================================ -->
    old_canvas_pattern = r'(<!-- ===+\s*EXACT 1200 x 630 MAXIMIZED OPEN GRAPH CARD\s*===+ -->\s*<div id="og-canvas">.*?</div>\s*</div>\s*</div>\s*<!-- ===+ -->)'
    
    new_canvas_block = f'''<!-- ============================================================
             EXACT 1200 x 630 MAXIMIZED OPEN GRAPH CARD (CLEAN TEMPLATE)
             ============================================================ -->
{clean_canvas}
                <!-- ============================================================ -->'
    '''

    ref_html_updated = re.sub(old_canvas_pattern, new_canvas_block, ref_html, flags=re.DOTALL)

    with open('scripts/reference-og-card.html', 'w', encoding='utf-8') as f:
        f.write(ref_html_updated)

    print("Updated scripts/reference-og-card.html successfully!")

if __name__ == '__main__':
    update_reference_og_card()

