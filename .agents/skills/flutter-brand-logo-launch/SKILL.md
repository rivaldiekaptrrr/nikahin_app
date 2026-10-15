---
name: flutter-brand-logo-launch
description: Standard operating procedure (SOP) end-to-end pembuatan, kurasi geometri, rendering varian warna, dan peluncuran logo/ikon aplikasi ke framework Flutter (Android Adaptive Icons, iOS xcassets, Web favicon, dan pubspec registration).
---

# Flutter Brand Logo Launch - End-to-End Workflow & SOP

Skill ini mendokumentasikan panduan operasional standar (SOP) lengkap dari proses awal pembuatan logo brand, penyempurnaan geometri vektor, pembuatan varian lockup dan palet warna, ekspor raster multi-resolusi, hingga integrasi langsung ke platform mobile Flutter (Android & iOS) dan Web.

---

## 1. Alur Kerja 7 Langkah (End-to-End Roadmap)

```
[Tahap 1: Konseptualisasi]
         │
         ▼
[Tahap 2: Tinjauan & Pemilihan Konsep]
         │
         ▼
[Tahap 3: Refinement Geometri & Koreksi Optik] ──► (Audit SVG, Expand Stroke, Optical dy)
         │
         ▼
[Tahap 4: Sistem Varian & Lockup] ───────────────► (Symbol, Horizontal, Stacked, Dark/Light)
         │
         ▼
[Tahap 5: Ekspor Raster & Platform Icon Suite] ──► (Android Mipmaps, iOS xcassets, Web Favicon)
         │
         ▼
[Tahap 6: Integrasi ke Proyek Flutter] ──────────► (pubspec.yaml & flutter pub get)
         │
         ▼
[Tahap 7: Dokumentasi Brand Guidelines] ─────────► (docs/BRAND_GUIDELINES.md)
```

---

## 2. Rincian Langkah Demi Langkah

### Tahap 1: Konseptualisasi & Definisi Visual
1. Tentukan tema dan esensi aplikasi (contoh: *Warm Editorial Wedding* untuk Nikahin App).
2. Bangun 2 hingga 3 konsep logo berbeda pada kanvas viewBox `0 0 1024 1024`:
   - **Konsep A**: Monogram / Lettermark tipografis.
   - **Konsep B**: Simbol Geometris / Metafora murni.
   - **Konsep C**: Simbol Budaya / Bentuk Organik bercerita.
3. Simpan konsep awal di `assets/logo_concepts/`.

---

### Tahap 2: Tinjauan & Pemilihan Konsep
1. Render seluruh konsep awal ke resolusi setara (misal 512×512 PNG).
2. Tampilkan kepada pengguna menggunakan presentation board atau carousel artefak markdown.
3. Kumpulkan masukan dan mintalah pengguna memilih 1 konsep pemenang sebelum melangkah ke tahap produksi aset.

---

### Tahap 3: Refinement Geometri & Koreksi Optik (Wajib & Krusial)
Sebelum membuat varian ukuran, lakukan audit ketat pada vektor terpilih:
1. **Audit & Ekspansi Stroke**:
   - Jalankan audit SVG untuk memastikan tidak ada ketergantungan `stroke-width` atau `stroke-dasharray` murni yang akan rusak jika di-scale ke 16px.
   - Ubah elemen busur/lingkaran menjadi path kurva tertutup (`M ... A ... Z`) dengan `fill-rule="evenodd"`.
2. **Koreksi Optik Pusat Massa (*Optical Center of Gravity*)**:
   - Simbol dengan busur atau dasar melengkung sering mengalami ilusi optik "melorot" ke bawah jika diposisikan tepat di pusat geometris kanvas.
   - Berikan offset optik vertikal ke atas (`dy = -24 px` pada kanvas 1024) agar logo terlihat seimbang sempurna di mata manusia.
3. Simpan file master yang telah disempurnakan:
   - `assets/logo_concepts/concept_refined_master.svg`
   - `assets/logo_concepts/concept_refined_transparent.svg`

---

### Tahap 4: Sistem Varian Warna & Lockup
Strukturkan logo ke dalam standar industri di `assets/logo/svg/`:
1. **Master Symbol**:
   - `nikahin-symbol-master.svg` (Warna orisinal transparan).
   - `nikahin-symbol-black.svg` (100% Solid Black `#000000` untuk stempel & cetak nota/resi).
   - `nikahin-symbol-white.svg` (100% Solid White `#FFFFFF` untuk penempatan di latar foto/gelap).
2. **Horizontal Lockup (Rasio 3:1, 1200×400 px)**:
   - `nikahin-lockup-horizontal.svg` (Latar transparan/terang).
   - `nikahin-lockup-horizontal-dark.svg` (Dengan plate latar belakang gelap resmi).
   - Ideal untuk header web, navbar, dan kop surat dokumen PDF.
3. **Stacked / Vertical Lockup (Rasio Vertikal, 600×680 px)**:
   - `nikahin-lockup-stacked.svg` (Latar transparan/terang).
   - `nikahin-lockup-stacked-dark.svg` (Latar gelap).
   - Simbol di atas, wordmark di tengah, tagline di bawah. Ideal untuk splash screen dan poster.
4. **Master App Icon Plates**:
   - `nikahin-app-icon.svg` (Plate kotak penuh 1024×1024 untuk iOS & Store).
   - `nikahin-app-icon-fg.svg` (Simbol diatur di dalam safe-zone 66% untuk Android Adaptive Icon).
   - `nikahin-app-icon-bg.svg` (Plate background solid/gradasi untuk Android Adaptive Icon).

---

### Tahap 5: Ekspor Raster & Platform Icon Suite
Jalankan skrip otomatisasi Python (`generate_flutter_brand_assets.py`) untuk merender dan mendistribusikan aset:

1. **Rendering Master PNG (`assets/logo/png/`)**:
   - Render seluruh SVG ke PNG resolusi 1024×1024, 512×512, dan lockup 1200×400 menggunakan headless Chrome / CairoSVG.
2. **Android Adaptive & Legacy Icons (`android/app/src/main/res/`)**:
   - Turunkan ukuran ikon ke setiap density mipmap:
     * `mipmap-mdpi`: 48×48 px (legacy), 108×108 px (adaptive fg/bg).
     * `mipmap-hdpi`: 72×72 px (legacy), 162×162 px (adaptive fg/bg).
     * `mipmap-xhdpi`: 96×96 px (legacy), 216×216 px (adaptive fg/bg).
     * `mipmap-xxhdpi`: 144×144 px (legacy), 324×324 px (adaptive fg/bg).
     * `mipmap-xxxhdpi`: 192×192 px (legacy), 432×432 px (adaptive fg/bg).
3. **iOS App Icon Set (`ios/Runner/Assets.xcassets/AppIcon.appiconset/`)**:
   - **PENTING**: Apple App Store menolak ikon 1024×1024 yang memiliki transparansi/alpha channel. Kanvas master `Icon-App-1024x1024@1x.png` WAJIB berupa RGB solid tanpa alpha.
   - Baca file `Contents.json` bawaan iOS dan lakukan resize Lanczos ke seluruh ukuran iPhone & iPad (20px, 29px, 40px, 60px, 76px, 83.5px).
4. **Favicon & Web Suite (`assets/logo/app_icon/web/`)**:
   - `favicon.ico` berisi multi-resolusi (16×16, 32×32, 48×48 px).
   - `apple-touch-icon.png` (180×180 px).
   - `android-chrome-192x192.png` & `android-chrome-512x512.png` (PWA).

---

### Tahap 6: Integrasi ke Framework Flutter
1. Daftarkan folder aset PNG di `pubspec.yaml`:
   ```yaml
   flutter:
     uses-material-design: true
     assets:
       - assets/images/
       - assets/logo/png/
   ```
2. Jalankan sinkronisasi dependensi:
   ```bash
   flutter pub get
   ```
3. Logo kini siap dipanggil di kode Dart manapun:
   ```dart
   Image.asset('assets/logo/png/nikahin-lockup-horizontal.png')
   ```

---

### Tahap 7: Dokumentasi Brand Guidelines
Buat dokumen panduan resmi di `docs/BRAND_GUIDELINES.md` yang memuat:
1. Esensi & narasi simbolis.
2. Palet warna presisi (HEX, RGB, CMYK).
3. Aturan tipografi (Wordmark font, Tagline font, ukuran, dan tracking).
4. Ruang aman (*clear space*) dan batas ukuran minimum.
5. Larangan penggunaan (*misuse rules*).

---

## 3. Skrip Otomatisasi Terintegrasi
Skrip siap pakai telah disertakan di:
`.agents/skills/flutter-brand-logo-launch/scripts/generate_flutter_brand_assets.py`

Untuk menjalankan ekspor ulang kapan saja:
```bash
python .agents/skills/flutter-brand-logo-launch/scripts/generate_flutter_brand_assets.py
```
