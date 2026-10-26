# Panduan Identitas Visual & Brand Guidelines: Nikahin App

> **Versi Dokumen**: 2.1.0  
> **Arah Desain**: Warm Editorial Wedding & Modern Couple Partnership  
> **Aset Master**: [`assets/logo/`](file:///c:/Rivaldi/nikahin_app/assets/logo/)

---

## 1. Filosofi & Esensi Brand

**Nikahin** adalah aplikasi perencana pernikahan (*wedding planner & budget management*) yang mengusung prinsip akun cloud-synced, privat, dan elegan dengan keandalan cache lokal.

Identitas visual Nikahin didasarkan pada **Janji Suci Akad, Genggaman Tangan Harmonis, dan Pita Cinta Abadi (*Infinity Love Ribbon & Sacred Handshake*)**:
- **Dua Tangan yang Saling Bertaut (*Sacred Handshake*)**: Melambangkan ikrar ijab kabul, janji suci akad nikah, serta kemitraan setara antara kedua mempelai dalam merencanakan masa depan dan mengelola rumah tangga bersama.
- **Pita Melingkar Tanpa Akhir (*Infinity Ribbon*)**: Lengan yang meliuk membentuk lambang tak terhingga (*infinity*), melambangkan komitmen cinta yang abadi, kesetiaan, dan doa keberkahan yang tak berujung.
- **Siluet Hati (*Heart Silhouette*)**: Keseluruhan komposisi menyatu membentuk siluet hati yang proporsional, menegaskan bahwa cinta kasih adalah poros utama dari setiap persiapan pernikahan.

---

## 2. Palet Warna Resmi (Brand Colors)

| Peran Warna | Nama Warna | HEX | Kegunaan |
| :--- | :--- | :--- | :--- |
| **App Icon Plate / Background** | Warm Champagne & Sacred Melati | `#FDF0DE` → `#E6C59E` | Latar belakang utama ikon aplikasi (Rich Champagne Silk & Melati Gold Glow), kartu identitas, dan piringan logo |
| **Romantic Coral** | Warm Coral Ribbon | `#F86D64` → `#EB5B56` | Pita atas dan tangan kanan, melambangkan kehangatan, antusiasme, dan ketegasan |
| **Soft Blush** | Sacred Blush Pink | `#FBA4A8` → `#F8969C` | Tangan kiri dan pita bawah, melambangkan kelembutan, ketulusan, dan ketenangan |
| **Dark Burgundy** | Royal Plum / Velvet Burgundy | `#91274C` → `#7D1F3F` | Simpul pita belakang dan bayangan kedalaman dimensi |
| **Primary Text (Dark)** | Deep Wine / Plum | `#4A1328` | Tipografi Wordmark pada mode terang, dokumen PDF, dan kop surat |
| **Floral Cream** | Sacred Melati Cream | `#FFF3DF` | Teks judul pada latar belakang gelap |
| **Wedding Gold** | Royal Champagne Gold | `#D4AF37` / `#AA771C` | Tagline "WEDDING PLANNER", aksen kemewahan, dan highlight bintang |

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
| **iOS App Icon** | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` | Seluruh resolusi ikon iPhone & iPad + Store 1024×1024 (Latar Solid Rich Warm Champagne `#E6C59E` / `#FDF0DE` tanpa alpha) |
| **Favicon & Web** | `assets/logo/app_icon/web/` | `favicon.ico`, `apple-touch-icon.png`, PWA webmanifest icons |
