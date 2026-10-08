# Panduan Lengkap Integrasi Midtrans Core API (Native In-App Payment)

Dokumen ini menjelaskan arsitektur, konfigurasi kredensial, alur antarmuka (*UI Flow*), backend serverless Vercel, serta prosedur pengujian untuk sistem pembayaran in-app **Midtrans Core API** pada aplikasi **Nikahin** (`rivaldiekaptrrr/nikahin_app`).

---

## 📌 1. Arsitektur & Prinsip Desain

Aplikasi Nikahin menggunakan integrasi **100% Native Midtrans Core API** (tanpa ketergantungan pada Snap WebView / popup browser eksternal) untuk memberikan pengalaman pengguna (*user experience*) yang cepat, mulus, dan bertema *Bridal Luxury Bento*.

```
┌────────────────────────────────┐
│   📱 Flutter App (Nikahin)     │
│   (PendingVerificationScreen)  │
└───────────────┬────────────────┘
                │ 1. Pilih Channel (BCA / Mandiri / BNI / BRI / Permata / QRIS / GoPay)
                ▼
┌────────────────────────────────┐       2. Request Charge API       ┌────────────────────────────────┐
│  🌐 Vercel Serverless Function ├──────────────────────────────────►│  💳 Midtrans Core API Gateway  │
│  (/api/charge-core-api)        │◄──────────────────────────────────┤  (Sandbox / Production)        │
└───────────────┬────────────────┘       3. Return VA / QR / Deeplink └───────────────┬────────────────┘
                │                                                                     │
                ▼                                                                     │ 4. Pengguna Bayar
┌────────────────────────────────┐                                                    │    (m-Banking / QRIS)
│  📱 Custom Instruction Screen  │                                                    │
│  (midtrans_custom_payment)     │                                                    │
└───────────────┬────────────────┘                                                    │
                │                                                                     │
                │ 5. Auto-Polling Check & Real-time Webhook                           ▼
                │ ◄─────────────────────────────────────────────────── [5. Webhook HTTP Notification]
                ▼                                                                     │
┌────────────────────────────────┐                                                    │
│  🔥 Cloud Firestore (users/{id})│ ◄───────────────────────────────────────────────────┘
│     accessLevel: "PREMIUM"     │ (Instant Role-Based Access Control Upgrade)
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  🎉 PaymentCelebrationScreen   │
│  (Confetti & Luxury Outro)     │
└───────────────┬────────────────┘
                │ Otomatis Navigasi ke Dashboard
                ▼
┌────────────────────────────────┐
│  👰 Wedding Dashboard Screen   │
└────────────────────────────────┘
```

---

## ⚙️ 2. Konfigurasi Kredensial & Lingkungan

### A. Lokasi File Konfigurasi
Seluruh konfigurasi bisnis dan endpoint Midtrans terpusat di:
👉 [`lib/app/config/business_config.dart`](file:///c:/Project/nikahin_app/lib/app/config/business_config.dart)

```dart
class BusinessConfig {
  /// Backend URL Midtrans Core API Charge (Vercel Serverless Function)
  static const String midtransCoreChargeBackendUrl = String.fromEnvironment(
    'MIDTRANS_CORE_CHARGE_BACKEND_URL',
    defaultValue: 'https://track-it-backend-sand.vercel.app/api/charge-core-api',
  );

  /// Status Lingkungan Midtrans (false = Sandbox, true = Production)
  static const bool isProduction = bool.fromEnvironment(
    'MIDTRANS_IS_PRODUCTION', 
    defaultValue: false,
  );

  /// Server Key Midtrans Sandbox
  static const String midtransSandboxServerKey = String.fromEnvironment(
    'MIDTRANS_SANDBOX_SERVER_KEY',
    defaultValue: 'SB-Mid-server-PLACEHOLDER',
  );

  /// Server Key Midtrans Production
  static const String midtransProductionServerKey = String.fromEnvironment(
    'MIDTRANS_PRODUCTION_SERVER_KEY',
    defaultValue: 'Mid-server-PLACEHOLDER',
  );

  /// Kode Lisensi & Harga
  static const String midtransPackageCode = 'WEDDING';
  static const double lifetimePrice = 49000.0;
}
```

### B. Pengaturan GitHub Secrets (CI/CD)
Demi keamanan dari *GitHub Secret Scanning / Push Protection*, server key tidak disimpan di dalam repositori git, melainkan disuntikkan saat build CI/CD melalui **GitHub Actions Secrets**:

1. Masuk ke **Settings > Secrets and variables > Actions** di GitHub.
2. Tambahkan Secret berikut:
   - `MIDTRANS_PRODUCTION_SERVER_KEY`: Server Key Production Midtrans (`Mid-server-...`)
   - `MIDTRANS_SANDBOX_SERVER_KEY`: Server Key Sandbox Midtrans (`SB-Mid-server-...`)
3. Pipeline GitHub Actions pada [`.github/workflows/multiplatform-build.yml`](file:///c:/Project/nikahin_app/.github/workflows/multiplatform-build.yml) akan menyuntikkan argumen `--dart-define` saat membuat rilis APK resmi.

---

## 💳 3. Metode Pembayaran yang Didukung

| Saluran Pembayaran | Tipe Transaksi | Respon / Payload |
|---|---|---|
| **BCA Virtual Account** | `bank_transfer` (bca) | `va_number` (11 digit) |
| **Mandiri Bill** | `echannel` | `bill_key` & `biller_code` (`70012`) |
| **BNI Virtual Account** | `bank_transfer` (bni) | `va_number` (16 digit) |
| **BRI Virtual Account** | `bank_transfer` (bri) | `va_number` (18 digit) |
| **Permata VA** | `bank_transfer` (permata) | `permata_va_number` |
| **QRIS Dinamis** | `qris` (gopay/shopeepay) | `qr_code_url` (gambar) & raw string QRIS |
| **GoPay / ShopeePay** | `gopay` / `shopeepay` | Deeplink & QRIS fallback |

---

## 🎨 4. Komponen Antarmuka (Bridal Luxury Bento UI)

1. **Paywall & VIP Hero** ([`pending_verification_screen.dart`](file:///c:/Project/nikahin_app/lib/features/auth/presentation/pending_verification_screen.dart)):
   - Hero banner bertema pernikahan mewah (*Emerald Dark & Champagne Gold*).
   - VIP Membership Card dengan diskon lifetime (Rp 49.000 dari Rp 99.000).
   - 2x2 Bento grid fitur unggulan (Unlimited Budget, Vendor Directory, Rundown, Guest RSVP).
   - 1 tombol aksi utama: *"Aktifkan Akses Sekarang"*.

2. **Modal Pemilihan Metode Pembayaran** ([`payment_channel_selection_modal.dart`](file:///c:/Project/nikahin_app/lib/features/auth/presentation/widgets/payment_channel_selection_modal.dart)):
   - Tab kategori: *Virtual Account*, *QRIS*, dan *E-Wallet*.
   - Kartu bank dengan logo dan skema warna resmi institusi.
   - Badge *"Bebas Biaya Admin"*.

3. **Instruksi Tagihan & Status Polling** ([`midtrans_custom_payment_screen.dart`](file:///c:/Project/nikahin_app/lib/features/auth/presentation/midtrans_custom_payment_screen.dart)):
   - Desain *ticket-stub receipt* dengan batas waktu countdown 24 jam.
   - Fitur salin 1-ketukan untuk nomor VA & jumlah transfer.
   - Laser scan animation pada tampilan QRIS.
   - Panduan langkah pembayaran accordion untuk ATM, Mobile Banking, dan Internet Banking.
   - **Auto-polling status background** (setiap 3–5 detik) mengecek status transaksi ke Midtrans/Firestore.

4. **Selebrasi Pembayaran** ([`payment_celebration_screen.dart`](file:///c:/Project/nikahin_app/lib/features/auth/presentation/payment_celebration_screen.dart)):
   - Layar non-scrollable yang responsif di seluruh dimensi HP.
   - Efek konfeti bertingkat dengan transisi *natural fadeout*.
   - Kartu bukti aktivasi seumur hidup.
   - Transisi keluar (*outro fadeout*) otomatis menuju halaman utama.

---

## 🧪 5. Prosedur Pengujian (Testing di Sandbox)

### A. Pengujian Virtual Account
1. Buka aplikasi dalam mode pengujian (Sandbox).
2. Pilih bank (misal: BCA VA) dan salin nomor VA yang muncul di layar.
3. Kunjungi **Midtrans Payment Simulator**:
   👉 [https://simulator.sandbox.midtrans.com/openapi/va/index](https://simulator.sandbox.midtrans.com/openapi/va/index)
4. Masukkan nomor VA, klik **Inquire**, lalu klik **Pay**.
5. Aplikasi Nikahin akan mendeteksi status settlement secara instan dan langsung beralih ke layar selebrasi.

### B. Pengujian QRIS
1. Pilih metode QRIS di aplikasi.
2. Gunakan simulator QRIS Midtrans:
   👉 [https://simulator.sandbox.midtrans.com/qris/index](https://simulator.sandbox.midtrans.com/qris/index)
3. Masukkan QR code payload string atau upload scan QR.
4. Klik **Pay**, dan lisensi pengguna akan langsung aktif.

---

## 🛡️ 6. Keamanan & Role-Based Access Control (RBAC)

- Saat pengguna terdaftar pertama kali, nilai `accessLevel` pada Firestore adalah `NONE`.
- Begitu pembayaran berstatus `settlement` / `capture`, Webhook Serverless Function di Vercel memperbarui Firestore pengguna menjadi `PREMIUM` menggunakan Firebase Admin SDK.
- Aturan keamanan Firestore ([`firestore.rules`](file:///c:/Project/nikahin_app/firestore.rules)) memvalidasi kepemilikan data dan memberikan proteksi penuh terhadap manipulasi data dari sisi klien.
