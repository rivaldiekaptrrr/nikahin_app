import base64
import os
import shutil

def prepare_standalone_html():
    with open('landing-page/public/assets/nikahin-symbol-master-512.png', 'rb') as f:
        logo_b64 = base64.b64encode(f.read()).decode('utf-8')

    with open('assets/images/landpages/Beranda.jpeg', 'rb') as f:
        beranda_b64 = base64.b64encode(f.read()).decode('utf-8')

    with open('scripts/reference-og-card-standalone.html', 'r', encoding='utf-8') as f:
        html = f.read()

    # 1. Replace App Icon SVG with Real Nikahin Logo
    old_app_icon = '''                        <div class="og-app-icon">
                            <svg width="30" height="30" viewBox="0 0 28 28" fill="none">
                                <circle cx="11" cy="15" r="6" stroke="#FFFFFF" stroke-width="2.8" />
                                <circle cx="17" cy="15" r="6" stroke="#FFFFFF" stroke-width="2.8" />
                                <path
                                    d="M14 7.5L15.6 5.4C16.4 4.5 17.8 4.6 18.4 5.6C18.9 6.5 18.5 7.7 17.6 8.3L14 10.6L10.4 8.3C9.5 7.7 9.1 6.5 9.6 5.6C10.2 4.6 11.6 4.5 12.4 5.4L14 7.5Z"
                                    fill="#FFFFFF" />
                            </svg>
                        </div>'''
    
    new_app_icon = f'''                        <div class="og-app-icon" style="background: #FDF0DE; padding: 4px; border: 2.5px solid #0F172A; box-shadow: 3px 3px 0px #0F172A;">
                            <img src="data:image/png;base64,{logo_b64}" alt="Nikahin Official Logo" style="width: 100%; height: 100%; object-fit: contain;" />
                        </div>'''

    if old_app_icon in html:
        html = html.replace(old_app_icon, new_app_icon)
    else:
        # Regex or substring fallback
        print("Warning: old_app_icon exact match not found, checking alternatives...")

    # 2. Inject Real Beranda Screenshot into Phone Screen
    old_screen_block = '''                            <!-- Built-in Rich "Nikahin" Beranda UI Mockup -->
                            <div id="builtin-mockup-ui" class="w-full h-full flex flex-col bg-[#F8FAFC]">'''
    
    new_screen_block = f'''                            <!-- Real Nikahin Beranda App Screenshot -->
                            <img id="custom-screen-img" src="data:image/jpeg;base64,{beranda_b64}" alt="Nikahin Beranda Screenshot" style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: top center; z-index: 20; display: block;" />

                            <!-- Built-in Rich "Nikahin" Beranda UI Mockup (Hidden) -->
                            <div id="builtin-mockup-ui" class="w-full h-full flex flex-col bg-[#F8FAFC]" style="display: none;">'''

    if old_screen_block in html:
        html = html.replace(old_screen_block, new_screen_block)
    else:
        print("Warning: old_screen_block exact match not found!")

    with open('scripts/reference-og-card-standalone.html', 'w', encoding='utf-8') as f:
        f.write(html)

    print("Updated scripts/reference-og-card-standalone.html successfully!")

if __name__ == '__main__':
    prepare_standalone_html()
