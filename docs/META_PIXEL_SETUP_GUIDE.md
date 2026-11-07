# Panduan Integrasi Meta Pixel (Facebook Pixel) — Nikahin App

Dokumentasi ini menjelaskan arsitektur, cara konfigurasi, dan verifikasi **Meta Pixel** pada landing page resmi Nikahin ([getnikahin.my.id](https://getnikahin.my.id)) untuk mendukung kampanye iklan **Meta Ads** (Instagram & Facebook Ads).

---

## 1. Arsitektur Pelacakan Meta Pixel

Meta Pixel diintegrasikan menggunakan komponen bawaan `next/script` dengan strategi `afterInteractive` agar tidak membebani kecepatan pemuatan halaman utama (*Core Web Vitals*).

Tiga event utama yang telah terpasang secara otomatis:

| Nama Event | Tipe | Lokasi Pemicu | Kegunaan dalam Meta Ads |
|---|---|---|---|
| **`PageView`** | Standard Event | Otomatis di seluruh halaman (`RootLayout`) | Mengukur jumlah kunjungan riil (*Landing Page Views*) dibandingkan klik tautan (*Link Clicks*). |
| **`ViewContent`** | Standard Event | Otomatis saat halaman beranda dibuka (`TrackViewContent`) | Mengetahui calon pengantin yang benar-benar membaca dan melihat penawaran aplikasi. |
| **`DownloadClick`** | Custom Event | Tombol "Unduh APK" (Android) & "Pasang di iPhone" (iOS) | Mencatat intensi unduhan spesifik per platform perangkat. |
| **`Lead`** | Standard Event | Ditembakkan bersamaan dengan `DownloadClick` | Memudahkan pemilihan target konversi langsung di Meta Ads Manager tanpa setup tambahan yang rumit. |

---

## 2. Cara Memperoleh Meta Pixel ID

Jika Anda belum memiliki Pixel ID, ikuti langkah berikut:

1. Buka [Meta Events Manager](https://business.facebook.com/events_manager2).
2. Masuk menggunakan akun **Meta Business Suite** atau Facebook Anda.
3. Di bilah samping kiri, pilih menu **Hubungkan Sumber Data (Connect Data Sources)** -> Pilih **Web** -> Klik **Hubungkan (Connect)**.
4. Beri nama dataset/pixel, misalnya: `Nikahin App Web Pixel`.
5. Salin **Pixel ID** / **Dataset ID** (terdiri dari 15–16 digit angka, contoh: `9876543210987654`).

---

## 3. Cara Memasang Pixel ID

### A. Pengujian Lokal (Local Development)
1. Buka direktori `landing-page/`.
2. Buat berkas baru bernama `.env.local` (atau duplikasi dari `.env.example`):
   ```env
   NEXT_PUBLIC_FACEBOOK_PIXEL_ID=9876543210987654
   ```
3. Jalankan server lokal:
   ```bash
   npm run dev
   ```

### B. Deployment Produksi (Vercel Dashboard)
Agar Meta Pixel aktif di domain resmi `getnikahin.my.id`, daftarkan environment variable di dashboard Vercel:

1. Buka [Dashboard Vercel](https://vercel.com/) dan pilih project **nikahin-app / landing-page**.
2. Masuk ke tab **Settings** -> **Environment Variables**.
3. Tambahkan variabel baru:
   - **Key**: `NEXT_PUBLIC_FACEBOOK_PIXEL_ID`
   - **Value**: Masukkan Pixel ID Anda (contoh: `9876543210987654`)
   - **Environment**: Centang *Production*, *Preview*, dan *Development*.
4. Klik **Save**.
5. Lakukan redeploy (atau buat commit baru ke branch `master`), maka Meta Pixel akan langsung aktif di live domain.

---

## 4. Cara Menguji dan Memverifikasi Event

### Metode 1: Menggunakan Ekstensi Chrome "Meta Pixel Helper"
1. Pasang ekstensi [Meta Pixel Helper](https://chromewebstore.google.com/detail/meta-pixel-helper/fdgfkebogiimcoedlicjlajpkdmockpc) di Google Chrome.
2. Buka situs [https://getnikahin.my.id](https://getnikahin.my.id).
3. Klik ikon ekstensi Meta Pixel Helper di pojok kanan atas peramban:
   - Pastikan terdapat tanda centang hijau untuk event **`PageView`** dan **`ViewContent`**.
4. Klik tombol **"Unduh APK"** atau **"Pasang di iPhone"**:
   - Pastikan muncul event baru **`DownloadClick`** dan **`Lead`** dengan parameter platform yang sesuai.

### Metode 2: Menggunakan Tab "Test Events" di Meta Events Manager
1. Buka Meta Events Manager -> Pilih Pixel Anda.
2. Buka tab **Test Events (Uji Peristiwa)**.
3. Masukkan URL `https://getnikahin.my.id` di kolom pengujian web, lalu klik **Buka Situs Web**.
4. Lakukan interaksi (scroll dan klik tombol unduh).
5. Kembali ke Events Manager, seluruh log event (`PageView`, `ViewContent`, `DownloadClick`, `Lead`) akan tampil secara langsung (*real-time*).

---

## 5. Tips Konfigurasi Kampanye Meta Ads (Traffic & Conversion)

1. **Pilih Optimasi Landing Page Views**:
   - Saat membuat kampanye dengan objektif **Traffic**, pada bagian **Ad Set (Kumpulan Iklan)** -> **Optimization for ad delivery**, pilih **Landing Page Views** (bukan *Link Clicks*).
   - Ini memastikan algoritma Meta memprioritaskan orang yang benar-benar membuka landing page sampai selesai termuat.
2. **Gunakan Event `Lead` untuk Optimasi Lebih Lanjut**:
   - Setelah pixel mengumpulkan beberapa data unduhan, Anda bisa mencoba kampanye dengan objektif **Leads** atau **Sales** dengan memilih event `Lead` sebagai tujuan konversi.
3. **Penyusunan Retargeting Audience**:
   - Di menu *Audiences*, Anda dapat membuat **Custom Audience** berisi pengguna yang memicu `ViewContent` tetapi belum memicu `DownloadClick` dalam 30 hari terakhir untuk diberikan iklan pengingat bertema promo spesial.

