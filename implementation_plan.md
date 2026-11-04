# Blueprint Implementasi — Nikahin Landing Page & Distribusi Aplikasi

Dokumen ini merupakan rencana implementasi resmi untuk membangun **Landing Page Pemasaran & Distribusi Aplikasi Nikahin** (`getnikahin.my.id`), yang terintegrasi secara dinamis dengan alur rilis GitHub Releases dan Flutter Web PWA.

---

## 1. Arsitektur Sistem & Pemetaan Domain

Sistem distribusi dipisahkan secara independen antara halaman pemasaran (Landing Page) dan aplikasi utama (PWA & APK Android) untuk memastikan pembaruan pemasaran dapat dilakukan kapan saja tanpa perlu membangun ulang aplikasi Flutter.

```
                    ┌──────────────────────────────────────────────┐
                    │               getnikahin.my.id               │
                    │         (Next.js on Vercel Edge CDN)         │
                    └──────────────────────┬───────────────────────┘
                                           │
                  ┌────────────────────────┴────────────────────────┐
                  │ Deteksi Otomatis Perangkat (Client User-Agent)  │
                  └────────────┬───────────────────────┬────────────┘
                               │                       │
                     [ Android Detected ]      [ iOS / Safari Detected ]
                               │                       │
                               ▼                       ▼
                    ┌─────────────────────┐ ┌──────────────────────┐
                    │ Unduh APK Langsung  │ │ Modal Panduan Safari │
                    │   (GitHub Release)  │ │   3 Langkah Mudah    │
                    └──────────┬──────────┘ └──────────┬───────────┘
                               │                       │
                               ▼                       ▼
                  api.github.com/repos/...    nikahin-app.pages.dev
                  (Versi & Aset Dinamis)       (Flutter Web PWA)
```

### Pemetaan URL & Infrastruktur:
| Komponen | Domain / Target URL | Hosting / Penyedia | Fungsi |
| :--- | :--- | :--- | :--- |
| **Landing Page** | `https://getnikahin.my.id` | **Vercel** (Global Edge CDN) | Halaman muka pemasaran, fitur, FAQ, deteksi perangkat, & link distribusi. |
| **Aplikasi Web (PWA)** | `https://nikahin-app.pages.dev` | **Cloudflare Pages** | Aplikasi Flutter Web untuk pengguna iOS (Safari Add to Home Screen) & browser. |
| **Paket APK Android** | `github.com/rivaldiekaptrrr/nikahin_app/releases/latest` | **GitHub Releases CDN** | Distribusi berkas APK rilis resmi (`nikahin-app-universal-release.apk`). |

---

## 2. Tech Stack & Dependensi Proyek

Proyek landing page dibuat dengan pendekatan **Monorepo** di dalam subdirektori `/landing-page` pada repositori `nikahin_app`.

| Komponen | Pilihan Teknologi | Alasan Pemilihan |
| :--- | :--- | :--- |
| **Framework** | **Next.js 15+ (App Router)** | SEO-friendly, pre-rendering instan, Server Components, dan integrasi native Vercel. |
| **Styling** | **Tailwind CSS v4** | Cepat, konsisten, dan mudah menyesuaikan palet warna resmi brand Nikahin. |
| **Animasi** | **Framer Motion** | Animasi scroll halus, transisi modal interaktif, dan efek micro-interaction premium. |
| **Ikonografi** | **Lucide Icons (`lucide-react`)** | Ikon rapi, ringan, modern, dan standar ekosistem React/Tailwind. |
| **Komponen UI** | **Radix UI / Shadcn UI patterns** | Aksesibilitas (a11y) tinggi, dialog modal bebas bug, dan performa optimal. |
| **Metadata API** | **Next.js ISR (`fetch` revalidate 300s)** | Mengambil versi dan ukuran APK langsung dari GitHub Releases secara otomatis. |

---

## 3. Identitas Visual & Bahasa Brand (Anti-Slop Luxury)

Mengacu pada `docs/BRAND_GUIDELINES.md` dan prinsip *Anti-Slop*:
- **Warna Utama**:
  - Primary Rose: `#D81B60` (Elegan & Hangat)
  - Secondary Rose: `#AD1457` (Kontras & Berwibawa)
  - Warm Champagne: `#FDF0DE` / Soft Pink `#FFF9FA` (Latar Belakang Bersih & Bernapas)
  - Slate Dark: `#0F172A` (Tipografi Utama Berkontras Tajam)
- **Karakter Visual**:
  - *No-Pill-Badge Refleks*: Menghindari kapsul AI generik dengan border semi-transparan berlebih.
  - Tipografi Editorial: Tipografi judul yang tegas, bersih, dan berjarak lega.
  - Mockup Interaktif CSS: Tampilan smartphone dengan bezel tipis yang merender komponen asli Nikahin (bukan screenshot gambar buram).
- **Bahasa Indonesia Natural (*Humanizer-Indonesia*)**:
  - Lugas, santun, hangat, dan relevan dengan calon pengantin Indonesia. Bebas dari istilah teknis kaku (*Cloud Firestore*, *SLA*, *Integrasi Framework*).

---

## 4. Struktur Halaman & Komponen Landing Page

```
landing-page/
├── app/
│   ├── layout.tsx             # Root layout, font Inter/Plus Jakarta Sans, SEO OpenGraph, GA4
│   ├── page.tsx               # Single-page marketing: Hero, Features, Mockup, Download, FAQ, Footer
│   ├── icon.png               # Favicon & PWA icon
│   └── opengraph-image.png    # Preview kartu media sosial (WhatsApp, IG, Twitter)
├── components/
│   ├── Navbar.tsx             # Logo Nikahin, link navigasi halus, tombol CTA cepat
│   ├── HeroSection.tsx        # Headline emosional, trust badge, tombol aksi adaptif perangkat
│   ├── DeviceCta.tsx          # Deteksi perangkat pintar (Android / iPhone / Desktop)
│   ├── AppPreviewMockup.tsx   # Frame ponsel CSS interaktif dengan fitur-fitur inti
│   ├── FeatureBentoGrid.tsx   # Grid fitur (Anggaran, Rundown & PIC, Buku Tamu, Seserahan, KUA)
│   ├── CoupleSyncBanner.tsx   # Sorotan sinkronisasi 2 akun (Kode Unik Pasangan)
│   ├── IosPwaModal.tsx        # Modal instruksi 3 langkah mudah Safari (Add to Home Screen)
│   ├── DesktopQrModal.tsx     # Modal QR Code untuk pengguna laptop/PC yang ingin buka di HP
│   ├── FaqAccordion.tsx       # FAQ calon pengantin (lisensi, keamanan, perangkat)
│   └── Footer.tsx             # Kebijakan privasi, syarat ketentuan, dan copyright Nikahin
├── lib/
│   ├── github-release.ts      # Fetcher API GitHub Releases dengan ISR caching (5 menit)
│   └── device-detector.ts     # Utilitas deteksi User-Agent (Android, iOS, Desktop)
└── public/
    └── assets/                # Logo master PNG/SVG, ilustrasi pendukung
```

---

## 5. Alur Deteksi Perangkat & Logika Distribusi

Landing page secara cerdas mendeteksi perangkat pengunjung untuk menampilkan tombol aksi yang paling relevan:

```typescript
// lib/device-detector.ts
export type DeviceType = 'android' | 'ios' | 'desktop';

export function detectDevice(userAgent: string): DeviceType {
  if (/Android/i.test(userAgent)) return 'android';
  if (/iPhone|iPad|iPod/i.test(userAgent)) return 'ios';
  return 'desktop';
}
```

### Perilaku Berdasarkan Perangkat:
1. **Pengguna Android**:
   - **Tombol Utama**: *"Unduh Aplikasi (APK v1.1.x)"* — Mengunduh berkas APK rilis langsung dari CDN GitHub Release.
   - **Informasi Tambahan**: Menampilkan ukuran berkas (`~35 MB`) dan tanggal pembaruan terkini.
   - **Tombol Sekunder**: *"Atau Buka Versi Web"* → Mengarah ke `https://nikahin-app.pages.dev`.

2. **Pengguna iPhone (iOS / iPadOS)**:
   - **Tombol Utama**: *"Buka di iPhone"* — Membuka **Modal Interaktif Panduan Safari**:
     1. Langkah 1: Buka tautan di peramban **Safari**.
     2. Langkah 2: Ketuk ikon **Bagikan (*Share*)** di bagian bawah.
     3. Langkah 3: Pilih **"Tambah ke Layar Utama" (*Add to Home Screen*)**.
   - Tombol di dalam modal langsung mengarahkan ke `https://nikahin-app.pages.dev`.

3. **Pengguna Komputer / Laptop (Desktop)**:
   - Menampilkan **dua tombol berdampingan** (Unduh APK & Buka Web).
   - Menampilkan **QR Code Interaktif**: Pengguna bisa memindai dengan kamera ponsel mereka untuk langsung membuka halaman download di perangkat masing-masing.

---

## 6. Integrasi Otomatis GitHub Releases (Zero Maintenance)

Landing page tidak menanam tautan download APK statis di kode sumber. Sebagai gantinya, Next.js Server Component mengambil informasi rilis secara otomatis dari REST API publik repositori:

```typescript
// lib/github-release.ts
export interface ReleaseMetadata {
  version: string;
  apkUrl: string;
  fileSizeMb: string;
  publishedAt: string;
  changelog: string[];
}

export async function getLatestRelease(): Promise<ReleaseMetadata> {
  const res = await fetch(
    'https://api.github.com/repos/rivaldiekaptrrr/nikahin_app/releases/latest',
    { next: { revalidate: 300 } } // ISR: Cache 5 menit di Vercel Edge
  );

  if (!res.ok) {
    // Fallback aman jika API terkena limit atau offline
    return {
      version: 'v1.1.12',
      apkUrl: 'https://github.com/rivaldiekaptrrr/nikahin_app/releases/latest',
      fileSizeMb: '38 MB',
      publishedAt: 'Terbaru',
      changelog: ['Penyempurnaan aktivasi lisensi & stabilitas'],
    };
  }

  const data = await res.json();
  const universalApk = data.assets?.find((asset: any) =>
    asset.name.includes('universal') || asset.name.endsWith('.apk')
  );

  return {
    version: data.tag_name ?? 'v1.1.12',
    apkUrl: universalApk?.browser_download_url ?? data.html_url,
    fileSizeMb: universalApk ? (universalApk.size / (1024 * 1024)).toFixed(1) + ' MB' : '38 MB',
    publishedAt: new Date(data.published_at).toLocaleDateString('id-ID', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
    }),
    changelog: data.body ? data.body.split('\n').filter((l: string) => l.trim().length > 0) : [],
  };
}
```

**Keunggulan Utama**:
Setiap kali kamu merilis versi baru (misal `v1.1.13`) melalui Git tag, GitHub Actions akan membuat rilis, dan landing page di `getnikahin.my.id` **otomatis menampilkan versi baru dan mengunduh APK terbaru tanpa perlu redeploy Next.js!**

---

## 7. Mockup Fitur Interaktif CSS

Alih-alih tangkapan layar statis yang rawan buram di layar retina, kita membuat **Bingkai Mockup Smartphone CSS** yang tajam dengan tab interaktif untuk menampilkan 4 fitur andalan Nikahin:

1. **Tab 1 — Anggaran & Pembayaran Vendor**:
   - Kartu ringkasan total anggaran vs realisasi.
   - Indikator status pembayaran termin (*Lunas*, *DP*, *Belum Bayar*).
2. **Tab 2 — Susunan Acara (Rundown) & PIC**:
   - Garis waktu kronologis acara akad & resepsi.
   - Penanggung jawab (PIC) dan nomor kontak panitia terkait.
3. **Tab 3 — Daftar Tamu & Buku Tamu**:
   - Klasifikasi tamu (VIP, Reguler, Keluarga CPP/CPW).
   - Penghitung kehadiran real-time & RSVP.
4. **Tab 4 — Sinkronisasi Pasangan (Couple Sync)**:
   - Visual koneksi 2 akun menggunakan kode unik 6 digit (`NK-XXXXXX`).

---

## 8. Panduan Deployment Vercel & Domain `getnikahin.my.id`

### Langkah 1 — Inisialisasi Proyek Next.js Lokal
```bash
# Di root folder nikahin_app
npx create-next-app@latest landing-page --typescript --tailwind --app --src-dir=false --import-alias="@/*"
cd landing-page
npm install lucide-react framer-motion clsx tailwind-merge qrcode.react
```

### Langkah 2 — Setup Proyek di Vercel
1. Hubungkan repositori GitHub `rivaldiekaptrrr/nikahin_app` ke Vercel.
2. Atur **Root Directory** ke `landing-page`.
3. Biarkan framework preset terdeteksi otomatis sebagai **Next.js**.

### Langkah 3 — Konfigurasi DNS Domain `getnikahin.my.id`
Di panel penyedia domain DNS `getnikahin.my.id`:
- **CNAME Record**:
  - Name: `@` (atau root)
  - Target: `cname.vercel-dns.com.`
- **CNAME Record (www)**:
  - Name: `www`
  - Target: `cname.vercel-dns.com.`

---

## 9. Rencana Kerja Bertahap (Milestones)

- [ ] **Milestone 1 — Fondasi Proyek (`landing-page/`)**:
  - Inisialisasi Next.js 15, konfigurasi Tailwind CSS dengan palet warna resmi Nikahin, dan setup Lucide Icons.
- [ ] **Milestone 2 — Integrasi Data GitHub Releases**:
  - Implementasi `lib/github-release.ts` untuk mengambil data versi APK dinamis dari GitHub API dengan caching ISR.
- [ ] **Milestone 3 — Komponen Hero & Smart Device CTA**:
  - Implementasi deteksi User-Agent (Android, iOS, Desktop).
  - Pembuatan modal 3 langkah pemasangan iPhone PWA dan modal QR Code untuk desktop.
- [ ] **Milestone 4 — Visual Mockup Fitur Interaktif & Bento Grid**:
  - Pembuatan mockup smartphone CSS interaktif (Anggaran, Rundown, Tamu, Couple Sync).
  - Seksi penjelasan fitur, nilai privasi, dan keunggulan sekali bayar tanpa langganan.
- [ ] **Milestone 5 — FAQ, Footer, & SEO Metadata**:
  - Akordeon tanya jawab calon pengantin.
  - Setup OpenGraph, meta tag sosial media (WhatsApp share preview), dan favicon.
- [ ] **Milestone 6 — Deployment Vercel & Penautan Domain `getnikahin.my.id`**:
  - Setup Vercel deployment dengan root directory `landing-page`.
  - Verifikasi DNS SSL HTTPS di `getnikahin.my.id`.
  - Uji coba live dari perangkat Android & iPhone asli.
