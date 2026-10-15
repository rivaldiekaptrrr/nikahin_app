# Panduan Identitas Visual & Brand Guidelines: Nikahin App

> **Versi Dokumen**: 1.0.0  
> **Arah Desain**: Warm Editorial Wedding (Material 3 + Bento Grid)  
> **Aset Master**: [`assets/logo/`](file:///c:/Rivaldi/nikahin_app/assets/logo/)

---

## 1. Filosofi & Esensi Brand

**Nikahin** adalah aplikasi perencana pernikahan (*wedding planner & budget management*) yang mengusung prinsip *offline-first*, privat, dan elegan.

Identitas visual Nikahin didasarkan pada **Konsep C: Kuncup Melati & Janji Suci**:
- **5 Kelopak Kuncup Melati**: Simbol kemurnian, keharuman cinta, ketulusan niat, dan 5 rukun/pilar keharmonisan rumah tangga dalam tradisi pernikahan Nusantara.
- **Busur Emas Melengkung (Crescent)**: Merepresentasikan perlindungan, kehangatan, serta bahtera rumah tangga yang kokoh.
- **Cincin Permata Pusat**: Lambang ikatan sakral dan komitmen seumur hidup kedua mempelai.

---

## 2. Palet Warna Resmi (Brand Colors)

| Peran Warna | Nama Warna | HEX | RGB | CMYK | Kegunaan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Primary Brand** | Deep Wine / Plum | `#4A1328` | `rgb(74, 19, 40)` | `c:0, m:74, y:46, k:71` | Wordmark, teks utama mode terang, aksen bento |
| **Dark Plate** | Midnight Wine | `#3D0F21` → `#1E0710` | `rgb(61, 15, 33)` | `c:0, m:75, y:46, k:76` | Latar belakang app icon, dark mode splash screen |
| **Accent Gold** | Warm Wedding Gold | `#F5CE7A` → `#C47A1E` | `rgb(245, 206, 122)` | `c:0, m:16, y:50, k:4` | Busur cincin emas, tagline, highlight premium |
| **Floral Base** | Melati Cream / Gading | `#FFF3DF` | `rgb(255, 243, 223)` | `c:0, m:5, y:13, k:0` | Kelopak bunga (dark mode), teks judul dark mode |
| **Rose Petal** | Romantic Deep Rose | `#9A1F47` | `rgb(154, 31, 71)` | `c:0, m:80, y:54, k:40` | Kelopak bunga (light mode) |

---

## 3. Tipografi Resmi Brand

- **Wordmark ("Nikahin")**:
  - Font: **Playfair Display** (Weight: 700 / Bold)
  - Karakter: Serif editorial klasik, mewah, dan berwibawa.
  - Tracking/Letter-spacing: `-0.02em`
- **Tagline ("WEDDING PLANNER")**:
  - Font: **Plus Jakarta Sans** (Weight: 600 / SemiBold)
  - Karakter: Modern sans-serif geometris, bersih, dan sangat terbaca pada resolusi kecil.
  - Tracking/Letter-spacing: `+0.28em` s/d `+0.32em` (All-Caps)

---

## 4. Konfigurasi Lockup Resmi

Aset SVG lockup telah dipersiapkan secara presisi di direktori [`assets/logo/svg/`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/):

1. **Master Symbol**:
   - [`nikahin-symbol-master.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-master.svg) (Light / Transparent)
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
   - [`nikahin-symbol-black.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-black.svg) (100% Solid Black untuk stempel & cetak hitam-putih)
   - [`nikahin-symbol-white.svg`](file:///c:/Rivaldi/nikahin_app/assets/logo/svg/nikahin-symbol-white.svg) (100% Solid White untuk media gelap/fotografi)

---

## 5. Ruang Aman (Clear Space) & Ukuran Minimum

- **Clear Space**: Jarak bebas di sekeliling logo minimal setara dengan radius cincin emas tengah logo (R = 38 px pada kanvas 1024px atau ~10% dari tinggi logo). Tidak boleh ada teks, tombol, atau garis yang memotong area ini.
- **Ukuran Minimum Digital**:
  - Simbol Saja: 16 × 16 px (Favicon browser), 24 × 24 px (In-app icon).
  - Horizontal Lockup: Lebar minimum 120 px.
  - Stacked Lockup: Lebar minimum 80 px.

---

## 6. Larangan Penggunaan (Misuse Rules)

1. **Dilarang Mendistorsi Rasio**: Jangan meregangkan (*stretch*) atau memipihkan logo baik secara horizontal maupun vertikal.
2. **Dilarang Mengubah Warna Sembarangan**: Jangan memakai warna neon, hijau, biru cerah, atau gradasi yang tidak terdaftar dalam panduan warna resmi.
3. **Dilarang Menambahkan Drop Shadow Berlebihan**: Hindari efek glow atau shadow buram tebal yang merusak ketegasan geometris logo.
4. **Dilarang Menumpuk Latar Belakang Ramai**: Pastikan logo diletakkan di atas kontras yang cukup (gunakan varian dark lockup pada latar gelap, dan light lockup pada latar terang).

---

## 7. Matriks File & Integrasi Aplikasi

| Ekstensi / Target | Lokasi File | Deskripsi |
| :--- | :--- | :--- |
| **SVG Master** | `assets/logo/svg/` | File vektor scalable tak terbatas untuk web & cetak |
| **PNG High-Res** | `assets/logo/png/` | Raster 1024×1024, 512×512, dan 1200×400 |
| **Android Launcher** | `android/app/src/main/res/mipmap-*/` | `ic_launcher.png`, `ic_launcher_foreground.png`, `ic_launcher_background.png` |
| **iOS App Icon** | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` | Seluruh resolusi ikon iPhone & iPad + Store 1024×1024 |
| **Favicon & Web** | `assets/logo/app_icon/web/` | `favicon.ico`, `apple-touch-icon.png`, PWA webmanifest icons |
