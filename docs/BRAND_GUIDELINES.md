# Panduan Identitas Visual & Brand Guidelines: Nikahin App

> **Versi Dokumen**: 2.0.0  
> **Arah Desain**: Warm Editorial Wedding & Modern Financial Planning  
> **Aset Master**: [`assets/logo/`](file:///c:/Rivaldi/nikahin_app/assets/logo/)

---

## 1. Filosofi & Esensi Brand

**Nikahin** adalah aplikasi perencana pernikahan (*wedding planner & budget management*) yang mengusung prinsip *offline-first*, privat, dan elegan.

Identitas visual Nikahin didasarkan pada **Sinergi Cincin Emas, Grafik Pertumbuhan Finansial, dan Puncak Kasih**:
- **Cincin Emas Logam Melingkar**: Simbol ikatan sakral dan komitmen seumur hidup yang tak terputus. Cincin memiliki celah terbuka di kuadran kanan atas tempat garis grafik bertumbuh keluar melintasi batas cincin.
- **3 Pilar Diagram Batang (*Bar Chart*)**: Menggambarkan 3 pilar utama manajemen persiapan pernikahan: *Budgeting*, *Vendor Management*, dan *Rundown D-Day*. Efek kilau diagonal melambangkan transparansi dan keteraturan finansial.
- **Garis Tren Menanjak & Simpul Hati (*Love Peak*)**: Garis grafik yang menanjak ke kanan atas dan membentuk simpul hati (*heart*), menegaskan bahwa puncak dari seluruh perencanaan anggaran dan persiapan teknis adalah **cinta, komitmen, dan kebahagiaan suci**.

---

## 2. Palet Warna Resmi (Brand Colors)

| Peran Warna | Nama Warna | HEX | Kegunaan |
| :--- | :--- | :--- | :--- |
| **App Icon Plate** | Warm Champagne / Blush | `#FFFBF5` → `#FDF2E9` → `#F8E7D8` | Latar belakang ikon aplikasi, memberi kesan hangat & romantis |
| **Metallic Gold** | Multi-Tone Wedding Gold | `#D4AF37` / `#FFF3A8` / `#AA771C` | Cincin luar, aksen kemewahan, dan highlight premium |
| **Vibrant Rose** | Romantic Magenta Rose | `#B80D57` → `#DE1A66` → `#EE3B80` | Garis grafik zigzag, simpul hati, dan batang diagram finansial |
| **Primary Text** | Deep Wine / Plum | `#4A1328` | Tipografi Wordmark mode terang, header web, dan kop panduan PDF |
| **Dark Plate** | Midnight Wine | `#3D0F21` → `#1E0710` | Latar belakang lockup mode gelap |
| **Floral Cream** | Sacred Melati Cream | `#FFF3DF` | Teks judul pada latar belakang gelap |

---

## 3. Tipografi Resmi Brand

- **Wordmark ("Nikahin")**:
  - Font: **Playfair Display** (Weight: 700 / Bold)
  - Karakter: Serif editorial klasik, mewah, dan berwibawa.
  - Tracking/Letter-spacing: `-0.02em`
- **Tagline ("WEDDING PLANNER")**:
  - Font: **Plus Jakarta Sans** (Weight: 600 / SemiBold)
  - Karakter: Modern sans-serif geometris, bersih, dan sangat terbaca pada resolusi kecil.
  - Tracking/Letter-spacing: `+0.26em` s/d `+0.32em` (All-Caps)

---

## 4. Konfigurasi Lockup Resmi

Aset SVG lockup telah dipersiapkan secara presisi di direktori [`assets/logo/svg/`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/):

1. **Master Symbol**:
   - [`nikahin-symbol-master.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-master.svg) (Transparan, warna emas logam & magenta penuh).
   - Digunakan untuk favicon, watermark, avatar, dan elemen grafis standalone.
2. **Horizontal Lockup**:
   - [`nikahin-lockup-horizontal.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-horizontal.svg) (Light Background)
   - [`nikahin-lockup-horizontal-dark.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-horizontal-dark.svg) (Dark Wine Plate)
   - Rasio 3:1 (1200×400 px), ideal untuk navbar, kop surat panduan PDF, dan header web.
3. **Stacked / Vertical Lockup**:
   - [`nikahin-lockup-stacked.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-stacked.svg) (Light Background)
   - [`nikahin-lockup-stacked-dark.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-lockup-stacked-dark.svg) (Dark Wine Plate)
   - Rasio vertikal (600×680 px), ideal untuk splash screen aplikasi mobile, cover panduan PDF, dan merchandise.
4. **Monochrome Form**:
   - [`nikahin-symbol-black.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-black.svg) (100% Solid Black dengan garis pembatas kontras).
   - [`nikahin-symbol-white.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-white.svg) (100% Solid White untuk media gelap/fotografi).

---

## 5. Ruang Aman (Clear Space) & Ukuran Minimum

- **Clear Space**: Jarak bebas di sekeliling logo minimal setara dengan 10% dari tinggi logo. Tidak boleh ada teks, tombol, atau garis yang memotong area ini.
- **Ukuran Minimum Digital**:
  - Simbol Saja: 16 × 16 px (Favicon browser), 24 × 24 px (In-app icon).
  - Horizontal Lockup: Lebar minimum 120 px.
  - Stacked Lockup: Lebar minimum 80 px.

---

## 6. Matriks File & Integrasi Aplikasi

| Ekstensi / Target | Lokasi File | Deskripsi |
| :--- | :--- | :--- |
| **SVG Master** | `assets/logo/svg/` | File vektor scalable tak terbatas untuk web & cetak |
| **PNG High-Res** | `assets/logo/png/` | Raster 1024×1024, 512×512, dan 1200×400 |
| **Android Launcher** | `android/app/src/main/res/mipmap-*/` | `ic_launcher.png`, `ic_launcher_foreground.png`, `ic_launcher_background.png` |
| **iOS App Icon** | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` | Seluruh resolusi ikon iPhone & iPad + Store 1024×1024 (Latar Warm Champagne) |
| **Favicon & Web** | `assets/logo/app_icon/web/` | `favicon.ico`, `apple-touch-icon.png`, PWA webmanifest icons |
