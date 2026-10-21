---
name: flutter-brand-logo-launch
description: Standard operating procedure (SOP) end-to-end pembuatan, kurasi geometri, rendering varian warna, dan peluncuran logo/ikon aplikasi ke framework Flutter untuk semua platform (Android, iOS, Windows, macOS, Web, dan Welcome Screen Onboarding).
---

# 🚀 Flutter Brand Logo Launch & Multi-Platform Assets SOP

Panduan referensi operasional standar (SOP) definitif ketika ingin **mengubah, merombak, atau memperbarui desain logo aplikasi Nikahin**. Dokumen ini mencatat seluruh daftar berkas yang wajib diubah di folder `assets/`, ilustrasi **Welcome Screen**, ikon seluruh platform (**Android, iOS, Windows, macOS, Web**), serta titik pemanggilan di kode Flutter.

---

## ⚡ 1. Eksekusi Cepat (One-Command Automation)

Setelah berkas vektor SVG master baru disiapkan di `assets/logo/svg/` dan `assets/illustrations/`, **cukup jalankan satu perintah berikut** untuk merender dan mendistribusikan seluruh ikon ke semua platform secara otomatis:

```bash
python .agents/skills/flutter-brand-logo-launch/scripts/generate_flutter_brand_assets.py
```

Skrip ini akan otomatis merender 7 tahapan:
1. Master Logo PNG (`assets/logo/png/`).
2. Welcome Screen Onboarding PNG (`assets/images/`).
3. iOS AppIcon xcassets (`ios/Runner/Assets.xcassets/AppIcon.appiconset/`).
4. Android Adaptive & Legacy Mipmaps (`android/app/src/main/res/mipmap-*/`).
5. Windows App Icon (`windows/runner/resources/app_icon.ico`).
6. macOS AppIcon xcassets (`macos/Runner/Assets.xcassets/AppIcon.appiconset/`).
7. Web Favicon & PWA Suite (`web/`, `web/icons/`, dan `assets/logo/app_icon/web/`).

---

## 📁 2. Daftar Lengkap Berkas yang Wajib Diubah/Dibuat

### A. Vektor Master Logo (`assets/logo/svg/`)
Ini adalah sumber kebenaran (*single source of truth*) desain logo:

| Berkas SVG | Dimensi Kanvas | Kegunaan & Karakteristik |
|---|---|---|
| [`nikahin-symbol-master.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-master.svg) | `400×400` / `1024×1024` | Simbol resmi warna penuh (Cincin Emas, 3 Bar Anggaran, Simpul Hati) dengan latar transparan. |
| [`nikahin-symbol-black.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-black.svg) | `400×400` / `1024×1024` | 100% Solid Black (`#000000`) untuk stempel, watermark dokumen, dan cetak struk/nota. |
| [`nikahin-symbol-white.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-white.svg) | `400×400` / `1024×1024` | 100% Solid White (`#FFFFFF`) untuk latar belakang gelap, video, dan fotografi. |
| [`nikahin-lockup-horizontal.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-horizontal.svg) | `1200×400` (Rasio 3:1) | Logo + Teks horizontal latar transparan/terang untuk navbar web dan kop surat. |
| [`nikahin-lockup-horizontal-dark.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-horizontal-dark.svg) | `1200×400` (Rasio 3:1) | Logo + Teks horizontal di atas piringan bento Warm Champagne (`#FFFBF5` → `#F8E7D8`). |
| [`nikahin-lockup-stacked.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-stacked.svg) | `600×680` (Vertikal) | Logo di atas, Wordmark di tengah, Tagline di bawah. Ideal untuk poster dan splash screen. |
| [`nikahin-lockup-stacked-dark.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-stacked-dark.svg) | `600×680` (Vertikal) | Format bertumpuk di atas piringan bento Warm Champagne dengan teks Deep Wine (`#4A1328`). |
| [`nikahin-app-icon.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-app-icon.svg) | `1024×1024` | Master ikon aplikasi penuh (Simbol ~80% coverage di atas latar Warm Champagne). |
| [`nikahin-app-icon-fg.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-app-icon-fg.svg) | `512×512` | Foreground layer untuk Android Adaptive Icon (Simbol berada di dalam safe zone lingkaran tengah 66%). |
| [`nikahin-app-icon-bg.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-app-icon-bg.svg) | `512×512` | Background layer solid/gradasi Warm Champagne untuk Android Adaptive Icon. |

---

### B. Ilustrasi Vektor & Raster Welcome Screen (Onboarding)
Ketika logo diubah, ketiga layar Welcome Screen wajib diselaraskan agar identitas brand tetap harmonis:

| Berkas Master Vektor (SVG) | Berkas Target Flutter (PNG 512×512) | Tema & Deskripsi Layar Onboarding |
|---|---|---|
| [`assets/illustrations/welcome_slide_1.svg`](file:///c:/Rivaldi/nikahin_app/assets/illustrations/welcome_slide_1.svg) | [`assets/images/welcome_slide_1.png`](file:///c:/Rivaldi/nikahin_app/assets/images/welcome_slide_1.png) | **Layar 1 (Nikahin)**: Lambang master baru di atas piringan bento bertabur kilau bintang emas (*sparkles*). |
| [`assets/illustrations/welcome_slide_2.svg`](file:///c:/Rivaldi/nikahin_app/assets/illustrations/welcome_slide_2.svg) | [`assets/images/welcome_slide_2.png`](file:///c:/Rivaldi/nikahin_app/assets/images/welcome_slide_2.png) | **Layar 2 (Atur Anggaran & Pos Biaya)**: Kartu analitik bertingkat, dompet beludru Deep Wine kunci emas ruby, dan koin emas mahar Rp. |
| [`assets/illustrations/welcome_slide_3.svg`](file:///c:/Rivaldi/nikahin_app/assets/illustrations/welcome_slide_3.svg) | [`assets/images/welcome_slide_3.png`](file:///c:/Rivaldi/nikahin_app/assets/images/welcome_slide_3.png) | **Layar 3 (Kelola Tamu, Vendor & Rundown)**: Amplop undangan mewah stempel lilin anggur `N`, ceklist rundown, jam saku akad 08:00, dan melati sakral. |

---

### C. Berkas Hasil Render Logo Raster (`assets/logo/png/`)
Dihasilkan otomatis oleh skrip Python ke format PNG beresolusi tinggi:
- `nikahin-symbol-master.png` (1024×1024 px) & `nikahin-symbol-master-512.png` (512×512 px)
- `nikahin-symbol-black.png` (1024×1024 px) & `nikahin-symbol-black-512.png` (512×512 px)
- `nikahin-symbol-white.png` (1024×1024 px) & `nikahin-symbol-white-512.png` (512×512 px)
- `nikahin-lockup-horizontal.png` & `nikahin-lockup-horizontal-dark.png` (1200×400 px)
- `nikahin-lockup-stacked.png` & `nikahin-lockup-stacked-dark.png` (600×680 px)
- `nikahin-app-icon.png` (1024×1024 px)
- `nikahin-app-icon-fg.png` (512×512 px)
- `nikahin-app-icon-bg.png` (512×512 px)

---

### D. Ikon Seluruh Platform (Android, iOS, Windows, macOS, Web)

#### 1. Android (`android/app/src/main/res/`)
Setiap density mipmap wajib memiliki 3 berkas:
- `mipmap-mdpi/`: `ic_launcher.png` (48px), `ic_launcher_foreground.png` (108px), `ic_launcher_background.png` (108px)
- `mipmap-hdpi/`: `ic_launcher.png` (72px), `ic_launcher_foreground.png` (162px), `ic_launcher_background.png` (162px)
- `mipmap-xhdpi/`: `ic_launcher.png` (96px), `ic_launcher_foreground.png` (216px), `ic_launcher_background.png` (216px)
- `mipmap-xxhdpi/`: `ic_launcher.png` (144px), `ic_launcher_foreground.png` (324px), `ic_launcher_background.png` (324px)
- `mipmap-xxxhdpi/`: `ic_launcher.png` (192px), `ic_launcher_foreground.png` (432px), `ic_launcher_background.png` (432px)

#### 2. iOS (`ios/Runner/Assets.xcassets/AppIcon.appiconset/`)
- `Icon-App-1024x1024@1x.png`: **WAJIB Solid RGB tanpa transparansi/alpha channel** (Apple App Store akan menolak binary jika ada alpha channel).
- Seluruh ukuran perangkat iPhone & iPad yang terdaftar di `Contents.json` (20px, 29px, 40px, 60px, 76px, 83.5px).

#### 3. Windows Desktop (`windows/runner/resources/`)
- [`windows/runner/resources/app_icon.ico`](file:///c:/Rivaldi/nikahin_app/windows/runner/resources/app_icon.ico): File ICO multi-resolusi yang berisi sub-gambar 16×16, 24×24, 32×32, 48×48, 64×64, 128×128, dan 256×256 px.

#### 4. macOS Desktop (`macos/Runner/Assets.xcassets/AppIcon.appiconset/`)
- Berkas ikon Apple Mac sesuai `Contents.json`: `app_icon_16.png`, `app_icon_32.png`, `app_icon_64.png`, `app_icon_128.png`, `app_icon_256.png`, `app_icon_512.png`, `app_icon_1024.png`.

#### 5. Web Platform (`web/` dan `assets/logo/app_icon/web/`)
- `web/favicon.png` (32×32 px)
- `web/icons/Icon-192.png` & `Icon-512.png` (PWA Icons)
- `web/icons/Icon-maskable-192.png` & `Icon-maskable-512.png` (Android Chrome PWA Maskable)
- `assets/logo/app_icon/web/favicon.ico` (Multi-size 16, 32, 48 px)
- `assets/logo/app_icon/web/apple-touch-icon.png` (180×180 px)

---

## 💻 3. Berkas Kode Flutter yang Memanggil Logo & Ilustrasi

Jika mengganti nama berkas aset, pastikan memperbarui titik-titik kode berikut:

1. **Layar Onboarding**: [`lib/features/auth/welcome_screen.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/auth/welcome_screen.dart)
   ```dart
   imageAsset: 'assets/images/welcome_slide_1.png',
   imageAsset: 'assets/images/welcome_slide_2.png',
   imageAsset: 'assets/images/welcome_slide_3.png',
   ```
2. **Layar Login**: [`lib/features/auth/login_screen.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/auth/login_screen.dart)
   ```dart
   Image.asset('assets/logo/png/nikahin-symbol-master.png', width: 68, height: 68)
   ```
3. **Kartu Info Aplikasi (Pengaturan)**: [`lib/features/settings/presentation/widgets/settings_app_info_card.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/settings/presentation/widgets/settings_app_info_card.dart)
   ```dart
   Image.asset('assets/logo/png/nikahin-symbol-master.png', width: 48, height: 48)
   ```
4. **Pendaftaran Aset**: [`pubspec.yaml`](file:///c:/Rivaldi/nikahin_app/pubspec.yaml)
   ```yaml
   flutter:
     uses-material-design: true
     assets:
       - assets/images/
       - assets/logo/png/
   ```

---

## 📖 4. Berkas Dokumentasi Brand & CI/CD
- **Panduan Identitas Brand**: [`docs/BRAND_GUIDELINES.md`](file:///c:/Rivaldi/nikahin_app/docs/BRAND_GUIDELINES.md) (Wajib diperbarui narasi filosofi, palet warna HEX, dan contoh lockup).
- **Catatan Rilis**: [`RELEASE_NOTES.md`](file:///c:/Rivaldi/nikahin_app/RELEASE_NOTES.md) (Cantumkan pembaruan logo saat rilis versi baru).
- **Skrip Generator**: [`.agents/skills/flutter-brand-logo-launch/scripts/generate_flutter_brand_assets.py`](file:///c:/Rivaldi/nikahin_app/.agents/skills/flutter-brand-logo-launch/scripts/generate_flutter_brand_assets.py).

---

## 🎨 5. Aturan Desain & Safe Zone Penting
1. **Safe-Zone 66% Android Adaptive Icon**:
   - Kanvas Android Adaptive berukuran `512×512` px, tetapi hanya lingkaran berdiameter **338 px (66%)** di tengah yang dijamin tidak terpotong oleh launcher OS (seperti Samsung OneUI lingkaran atau Xiaomi squircle).
2. **App Store Zero-Alpha**:
   - iOS App Store mewajibkan latar belakang solid penuh tanpa transparansi sedikit pun pada ikon `1024×1024`.
3. **Optical Weighting**:
   - Berikan offset optik vertikal ke atas (`dy = -10` s/d `-20` px) jika simbol memiliki dasar kurva atau melingkar agar terlihat seimbang sempurna di mata manusia.
