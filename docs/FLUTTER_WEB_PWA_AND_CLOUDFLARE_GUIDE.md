# Panduan Implementasi Flutter Web PWA & Cloudflare Pages

Dokumen ini menjelaskan arsitektur, konfigurasi teknis, dan prosedur operasional untuk merilis aplikasi Nikahin sebagai Progressive Web App (PWA) di Cloudflare Pages yang dioptimalkan untuk perangkat iPhone (iOS Safari) dan peramban desktop.

---

## 1. Latar Belakang & Tujuan Bisnis

Merilis aplikasi ke Apple App Store memerlukan:
- Biaya langganan Apple Developer Program sebesar $99 USD (~Rp 1,6 juta) per tahun.
- Laptop Mac (macOS) dan lisensi Xcode untuk mengompilasi berkas IPA.
- Proses kurasi (*App Review*) yang memakan waktu dan berisiko ditolak.

Sebagai solusi elegan, efisien, dan ramah pengguna, aplikasi Nikahin dikompilasi ke **Flutter Web Progressive Web App (PWA)** dan dihosting di **Cloudflare Pages**:
- Pengguna iPhone dapat langsung mengakses situs dan menyimpannya ke layar utama melalui fitur **"Tambah ke Layar Utama" (Add to Home Screen)** di Safari.
- Aplikasi berjalan mandiri (*standalone app*) secara layar penuh tanpa bilah URL peramban.
- Seluruh fitur inti (anggaran, tamu, rundown, sinkronisasi Cloud Firestore) tetap berjalan normal.
- Hosting di Cloudflare Pages memberikan keuntungan **kuota bandwidth keluar (egress) tanpa batas**, berbeda dengan Firebase Hosting yang membatasi 10 GB/bulan pada paket gratis.

---

## 2. Arsitektur Teknis

### A. Penyimpanan Lokal di Web (Drift SQLite WebAssembly)
Aplikasi Nikahin menggunakan Drift SQLite sebagai basis data lokal. Di lingkungan web, peramban tidak dapat mengakses SQLite C-libraries secara native. Solusi yang diimplementasikan:
1. **`web/sqlite3.wasm`** (v3.8.0, 758 KB): Mesin kompilasi SQLite dalam format WebAssembly.
2. **`web/drift_worker.js`** (v2.35.3, 361 KB): Web Worker untuk menjalankan operasi database di thread latar belakang agar UI tetap 60 FPS.
3. **Penyimpanan Berkelanjutan**: Menggunakan IndexedDB browser sehingga data tetap tersimpan saat tab ditutup atau perangkat dimatikan.

### B. Routing SPA (Single Page Application)
Flutter Web menggunakan routing sisi klien (*client-side routing*). Jika pengguna me-refresh halaman seperti `https://nikahin-app.pages.dev/settings`, peramban akan meminta berkas `/settings` ke server yang berisiko galat 404.
- **Solusi**: Disediakan berkas `web/_redirects` berisi aturan:
  ```
  /* /index.html 200
  ```
  Aturan ini menginstruksikan Cloudflare Pages untuk selalu menyajikan `index.html` dengan status 200 untuk seluruh rute URL, sehingga GoRouter Flutter dapat menangani navigasi internal dengan sempurna.

### C. Optimasi Cache & Performa
Dikonfigurasi melalui `web/_headers`:
- Berkas statis biner (`.wasm` dan `.js`) diberikan header:
  `Cache-Control: public, max-age=31536000, immutable`
  Pengguna hanya mengunduh mesin WebAssembly sekali; kunjungan berikutnya terbuka seketika (*instant load*).
- Ikon dan gambar diberikan cache 7 hari dengan `stale-while-revalidate`.

### D. Optimasi Khusus iOS Safari
- **Safe Area & Notch**: Tag meta viewport dilengkapi `viewport-fit=cover` untuk menghilangkan garis putih di area notch dan Dynamic Island:
  ```html
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
  ```
- **Ikon Layar Utama iOS**: Berkas `web/icons/apple-touch-icon.png` (180x180 px) dengan latar belakang solid *Warm Champagne* (`#FDF0DE`) dan logo cincin emas resolusi tinggi.
- **Panduan Visual di Aplikasi**: Komponen `SettingsPwaInstallCard` di menu Pengaturan yang otomatis muncul di peramban web untuk memandu pengguna iOS cara memasang aplikasi ke layar utama.

---

## 3. Isolasi Fitur Lintas Platform

Untuk mencegah aplikasi mengalami galat (*crash*) di web:
1. **In-App APK Updater**:
   - Pengecekan versi GitHub Release dinonaktifkan di Web melalui `AppPlatformConfig.isApkUpdaterAvailable`.
   - Kartu info aplikasi di Pengaturan menampilkan lencana hijau bertuliskan **"Web PWA Aktif"** menggantikan tombol cek pembaruan APK.
2. **Penanganan Berkas & Ekspor**:
   - Penggunaan `dart:io` dan `File` dilindungi dengan `if (kIsWeb)`.
   - Ekspor berkas CSV dan JSON backup di web menggunakan `XFile.fromData(bytes, ...)` bersama pustaka `share_plus`.
3. **Notifikasi Lokal**:
   - Plugin `flutter_local_notifications` dinonaktifkan di web dengan pemeriksaan `if (kIsWeb) return;`.

---

## 4. Prosedur Deployment ke Cloudflare Pages

### A. Kompilasi Web Lokal
Jalankan perintah build Flutter Web di direktori proyek:
```bash
flutter build web --release
```
Hasil kompilasi akan berada di folder `build/web/`.

### B. Deployment Langsung via Wrangler CLI
1. Pastikan sudah login ke Cloudflare:
   ```bash
   npx wrangler login
   ```
2. Unggah folder hasil build ke Cloudflare Pages:
   ```bash
   npx wrangler pages deploy build/web --project-name=nikahin-app
   ```
3. Situs Anda akan langsung terbit di alamat produksi:
   👉 **`https://nikahin-app.pages.dev`**

---

## 5. Daftar Periksa Uji Coba PWA di iPhone

1. Buka peramban Safari di iPhone dan kunjungi `https://nikahin-app.pages.dev`.
2. Ketuk tombol **Bagikan (Share)** di bagian tengah bawah.
3. Pilih menu **Tambah ke Layar Utama (Add to Home Screen)**.
4. Periksa apakah ikon cincin Nikahin tampil rapi dan nama aplikasi tertulis *"Nikahin"*.
5. Buka aplikasi dari layar utama dan pastikan:
   - Navigasi layar penuh tanpa bilah peramban.
   - Pendaftaran / login akun Google dan email berjalan mulus.
   - Data anggaran dan checklist tersimpan di memori lokal saat koneksi terputus.
