import base64
import os

def generate_clean_og_card():
    # Read official logo
    with open('landing-page/public/assets/nikahin-symbol-master-512.png', 'rb') as f:
        logo_b64 = base64.b64encode(f.read()).decode('utf-8')

    # Read latest Beranda screenshot
    with open('assets/images/landpages/Beranda.jpeg', 'rb') as f:
        beranda_b64 = base64.b64encode(f.read()).decode('utf-8')

    html_content = f'''<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nikahin — Open Graph Card Clean Template</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        * {{
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }}
        body {{
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            width: 1200px;
            height: 630px;
            overflow: hidden;
            background-color: #F7BA1E;
        }}
        #og-canvas {{
            width: 1200px;
            height: 630px;
            background-color: #F7BA1E;
            background-image:
                radial-gradient(rgba(15, 23, 42, 0.08) 1.5px, transparent 1.5px),
                radial-gradient(rgba(15, 23, 42, 0.08) 1.5px, transparent 1.5px);
            background-size: 20px 20px;
            background-position: 0 0, 10px 10px;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }}
        .main-card {{
            width: 1124px;
            height: 566px;
            background-color: #FFFFFF;
            border: 4px solid #0F172A;
            border-radius: 28px;
            box-shadow: 14px 16px 0px #0F172A;
            overflow: hidden;
            display: flex;
            flex-direction: row;
        }}
        .left-col {{
            width: 630px;
            height: 100%;
            padding: 40px 44px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background-color: #FFFFFF;
            position: relative;
            z-index: 2;
        }}
        .right-col {{
            flex: 1;
            height: 100%;
            background-color: #FFFDF7;
            background-image:
                radial-gradient(circle at 50% 50%, rgba(254, 243, 199, 0.8) 0%, rgba(255, 253, 247, 0.2) 75%),
                radial-gradient(rgba(15, 23, 42, 0.06) 1.2px, transparent 1.2px);
            background-size: 100% 100%, 16px 16px;
            border-left: 2px dashed #E2E8F0;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }}
        .phone-wrapper {{
            width: 240px;
            height: 504px;
            border-radius: 40px;
            background-color: #0F172A;
            border: 2.5px solid #334155;
            box-shadow: 10px 12px 0px #0F172A;
            padding: 7px;
            position: relative;
            overflow: hidden;
        }}
        .phone-screen {{
            width: 100%;
            height: 100%;
            border-radius: 33px;
            background-color: #F8FAFC;
            position: relative;
            overflow: hidden;
        }}
        .dynamic-island {{
            position: absolute;
            top: 7px;
            left: 50%;
            transform: translateX(-50%);
            width: 64px;
            height: 15px;
            border-radius: 8px;
            background-color: #0A0A0F;
            z-index: 30;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 4px;
        }}
        .island-lens {{
            width: 5px;
            height: 5px;
            border-radius: 9999px;
            background: radial-gradient(circle at 35% 35%, #38BDF8 0%, #1E293B 60%, #090D16 100%);
        }}
        .home-indicator {{
            position: absolute;
            bottom: 6px;
            left: 50%;
            transform: translateX(-50%);
            width: 76px;
            height: 3.5px;
            border-radius: 2px;
            background-color: rgba(15, 23, 42, 0.35);
            z-index: 30;
        }}
    </style>
</head>
<body>
    <div id="og-canvas">
        <div class="main-card">
            <!-- Left Column: Copy, Rating, Price & CTA (Faithful to Reference Template) -->
            <div class="left-col">
                <!-- Top Group -->
                <div>
                    <!-- Badge -->
                    <div style="display: inline-flex; align-items: center; background-color: #0F172A; color: #FFFFFF; font-size: 13px; font-weight: 800; letter-spacing: 0.08em; padding: 7px 14px; border-radius: 8px;">
                        LIFETIME DEAL
                    </div>

                    <!-- Headline with Official Master Logo -->
                    <div style="display: flex; align-items: center; gap: 14px; margin-top: 18px;">
                        <div style="width: 48px; height: 48px; border-radius: 14px; background: #FDF0DE; border: 2.5px solid #0F172A; box-shadow: 3px 3px 0px #0F172A; display: flex; align-items: center; justify-content: center; padding: 5px; flex-shrink: 0;">
                            <img src="data:image/png;base64,{logo_b64}" alt="Nikahin Logo" style="width: 100%; height: 100%; object-fit: contain;" />
                        </div>
                        <div style="display: flex; flex-direction: column;">
                            <h1 style="font-size: 46px; font-weight: 800; color: #0F172A; line-height: 1; letter-spacing: -0.03em;">
                                Nikahin
                            </h1>
                        </div>
                    </div>

                    <!-- Subtitle Tagline -->
                    <div style="font-size: 19px; font-weight: 800; color: #0F172A; margin-top: 10px; line-height: 1.25; letter-spacing: -0.015em;">
                        Aplikasi Wedding Planner &amp; Budgeting Pasangan
                    </div>

                    <!-- Body Paragraph (Faithful to Template) -->
                    <p style="font-size: 15px; font-weight: 500; color: #475569; line-height: 1.5; margin-top: 12px; max-width: 535px;">
                        Hanya Rp 39.000 sekali bayar seumur hidup (Lifetime). Tautkan 2 akun berdua (CPP &amp; CPW), bebas pilih tema visual pernikahan, kelola anggaran, vendor, rundown, dan tamu real-time tanpa biaya bulanan.
                    </p>
                </div>

                <!-- Bottom Group -->
                <div>
                    <!-- Horizontal Subtle Divider -->
                    <div style="width: 100%; height: 2px; background-color: #E2E8F0; margin-bottom: 16px; border-radius: 2px;"></div>

                    <!-- Social Proof / Rating -->
                    <div style="display: flex; align-items: center; gap: 8px; font-size: 15.5px; font-weight: 700; color: #0F172A; margin-bottom: 20px;">
                        <span style="color: #F59E0B; font-size: 17px; letter-spacing: 0.5px;">⭐</span>
                        <span style="font-weight: 800; font-size: 16px;">4.97</span>
                        <span style="color: #64748B; font-weight: 600; font-size: 14.5px;">(155+ ulasan pasangan)</span>
                    </div>

                    <!-- Price & CTA Button (Split Flex) -->
                    <div style="display: flex; align-items: center; justify-content: space-between;">
                        <!-- Price -->
                        <div style="display: flex; flex-direction: column;">
                            <div style="display: flex; align-items: baseline; gap: 7px;">
                                <span style="font-size: 36px; font-weight: 800; color: #0F172A; line-height: 1; letter-spacing: -0.03em;">
                                    Rp 39.000
                                </span>
                                <span style="font-size: 16px; font-weight: 600; color: #64748B; line-height: 1;">
                                    / seumur hidup
                                </span>
                            </div>
                            <span style="font-size: 12px; font-weight: 700; color: #16A34A; margin-top: 4px; line-height: 1;">
                                ✓ Sekali bayar selamanya • Akses 2 HP
                            </span>
                        </div>

                        <!-- CTA Button -->
                        <div style="background-color: #0F172A; color: #FFFFFF; font-size: 16px; font-weight: 800; padding: 13px 26px; border-radius: 12px; display: inline-flex; align-items: center; gap: 8px; box-shadow: 4px 4px 0px #F7BA1E; cursor: pointer;">
                            <span>Coba Sekarang</span>
                            <span style="font-size: 18px; font-weight: 800;">→</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Clean Slender Portrait Phone Mockup -->
            <div class="right-col">
                <div class="phone-wrapper">
                    <div class="phone-screen">
                        <!-- Dynamic Island -->
                        <div class="dynamic-island">
                            <div class="island-lens"></div>
                        </div>

                        <!-- Real Beranda Screenshot -->
                        <img src="data:image/jpeg;base64,{beranda_b64}" alt="Nikahin Beranda Screenshot" style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: top center; z-index: 20; display: block;" />

                        <!-- Home Indicator -->
                        <div class="home-indicator"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
'''
    with open('scripts/clean_og_card.html', 'w', encoding='utf-8') as f:
        f.write(html_content)
    print("Generated scripts/clean_og_card.html successfully!")

if __name__ == '__main__':
    generate_clean_og_card()

