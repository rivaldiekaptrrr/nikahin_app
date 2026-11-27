---
name: production-safe-staging-workflow
description: Standar alur kerja isolasi pengujian (staging/preview) sebelum merilis perubahan besar atau fitur baru ke lingkungan produksi Nikahin agar pengguna aktif tidak terdampak.
---

# 🛡️ Production-Safe Staging & Preview Workflow (Nikahin)

Skill ini mengatur standar wajib isolasi lingkungan pengembangan dan pengujian (*staging/preview*) setiap kali mengerjakan **perubahan besar, fitur baru, perubahan alur pembayaran, atau modifikasi arsitektur** pada ekosistem Nikahin yang sudah berjalan di tahap produksi.

---

## 🎯 Kapan Skill Ini Wajib Diterapkan?

Agen dan pengembang **WAJIB** mengikuti alur di skill ini apabila tugas mencakup salah satu dari hal berikut:
1. Penambahan fitur baru berskala besar atau perubahan alur *core* (Auth, Payment/Midtrans, Couple Sync, Voucher).
2. Penambahan atau perubahan endpoint serverless pada `TrackIt-backend/api/`.
3. Perubahan UI/UX signifikan atau *tracking* pada `landing-page/` (`getnikahin.my.id`) dan Web PWA (`nikahin-app.pages.dev`).
4. Perubahan skema Cloud Firestore atau aturan keamanan `firestore.rules`.

> [!CAUTION]
> **DILARANG KERAS** mendorong (*push*) kode fitur eksperimental yang belum diuji langsung ke cabang `master`, karena `master` terhubung langsung ke *deployment* produksi Vercel (`getnikahin.my.id` & `TrackIt-backend`).

---

## 🚀 Alur Kerja Standar 5 Lapisan (Zero-Impact Isolation)

### 1. Git Branching: Wajib Gunakan Feature Branch
Buat cabang khusus sebelum menulis kode implementasi di repositori terkait (`nikahin_app` dan/atau `TrackIt-backend`):
```bash
git checkout -b feature/<nama-fitur>
```

### 2. Backend & Landing Page: Vercel Preview Deployments
* Push branch `feature/<nama-fitur>` ke GitHub. Vercel secara otomatis membangun URL *Preview* terisolasi untuk `TrackIt-backend` dan `landing-page` tanpa menyentuh domain produksi.
* **Isolasi Pembayaran Midtrans**: Gunakan *Environment Variables* ber-scope **Preview Only** di Vercel (`MIDTRANS_IS_PRODUCTION=false` dan kunci Sandbox `SB-...`) agar uji coba transaksi di URL Preview tidak mencampuri transaksi real pengguna di Production.

### 3. Web PWA: Cloudflare Pages Branch Preview
Saat mem-build dan menguji Web PWA baru, arahkan seluruh `--dart-define` backend ke **Git Branch Alias URL** Vercel Preview yang stabil (jangan gunakan hash URL deployment sekali pakai), lalu deploy ke cabang *preview* terpisah menggunakan `--branch`:
```bash
flutter build web --release --no-wasm-dry-run --no-pub \
  --dart-define=MIDTRANS_BACKEND_URL=https://track-it-backend-git-feature-<nama-fitur>-valproject.vercel.app/api/create-snap-token \
  --dart-define=MIDTRANS_CORE_CHARGE_BACKEND_URL=https://track-it-backend-git-feature-<nama-fitur>-valproject.vercel.app/api/charge-core-api \
  --dart-define=VALIDATE_VOUCHER_BACKEND_URL=https://track-it-backend-git-feature-<nama-fitur>-valproject.vercel.app/api/validate-voucher \
  --dart-define=MIDTRANS_IS_PRODUCTION=false
npx wrangler pages deploy build/web --project-name=nikahin-app --branch=staging-<nama-fitur>
```
* Hasilnya terbit di `https://staging-<nama-fitur>.nikahin-app.pages.dev`.
* Situs produksi utama `https://nikahin-app.pages.dev` tetap aman dan tidak terganggu.

### 4. Aplikasi Mobile (Android/iOS): Debug Build Terarah
* Uji langsung di perangkat atau emulator melalui `flutter run` (atau APK *debug*) dengan mengarahkan endpoint ke URL **Vercel Preview** hanya saat mode debug (`kDebugMode`).
* **Dilarang** menaikkan versi di `pubspec.yaml` atau membuat *Git Release Tag* (`v*`) sebelum pengujian *staging* selesai 100%, agar pengguna produksi tidak menerima pop-up pembaruan *In-App Updater*.

### 5. Cloud Firestore & Security Rules: Skema Additive & Data Uji Terisolasi
* **Non-Breaking Schema**: Penambahan koleksi baru (`vouchers`, `pending_orders`, dll.) dan aturan baru di `firestore.rules` harus bersifat *additive* (menambah hak akses koleksi baru tanpa mengubah perilaku koleksi produksi yang sedang aktif seperti `users`, `weddings`, dan `pairing_codes`).
* **Anti-Enumeration pada Data Uji**: Data atau kode uji coba rahasia di Firestore wajib dilindungi aturan `allow list: if isAdmin();` sehingga pengguna produksi tidak bisa melihat atau mengakses item uji coba.
* Gunakan akun test khusus (`tesqris` atau email pengujian terpisah) saat melakukan simulasi transaksi.

---

## ✅ Gerbang Promosi ke Produksi (Merge Checklist)

Perubahan dari `feature/<nama-fitur>` hanya boleh digabungkan (*merge*) ke `master` jika seluruh poin berikut terpenuhi:
1. [ ] Seluruh alur fitur telah lulus uji *end-to-end* pada URL Preview (Vercel Preview, Cloudflare Staging, & Debug App).
2. [ ] Validasi lokal lulus 100%:
   - `flutter analyze` (0 errors)
   - `flutter test` (semua tes lulus)
   - `npm --prefix landing-page run build` (0 errors)
3. [ ] Jika ada perubahan `firestore.rules`, sudah divalidasi (`firebase_validate_security_rules`) dan di-deploy (`firebase_deploy` target `firestore`).
4. [ ] Berkas [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json) dan **MCP Memory** sudah diperbarui sesuai perubahan baru.
5. [ ] Commit dilakukan secara bertahap dan atomik (*no blanket release commit*).

---

## ⚠️ Aturan Anti-Regresi & Pelajaran Penting Staging (Lessons Learned)

Setiap kesalahan yang pernah terjadi pada uji coba staging wajib dicegah sejak awal dengan aturan tegas berikut:

1. **Wajib Pakai Vercel Git Branch Alias URL (Dilarang Hardcode Hash URL Sekali Pakai)**
   * **Masalah sebelumnya:** `build/web` sempat di-*compile* dengan hash URL Preview tertentu (mis. `track-it-backend-fijjjchkh-...vercel.app`). Saat Vercel Preview di-*redeploy*, hash URL berubah sehingga Web PWA staging masih menembak deployment lama.
   * **Aturan:** Selalu pakai URL alias cabang Git yang stabil (`https://track-it-backend-git-feature-<nama-fitur>-valproject.vercel.app`) pada `--dart-define`.

2. **Pastikan Seluruh Env Vars Khusus Nikahin & Midtrans Sandbox Aktif di Scope `Preview`**
   * **Masalah sebelumnya:**
     - `NIKAHIN_FIREBASE_PROJECT_ID`, `NIKAHIN_FIREBASE_CLIENT_EMAIL`, dan `NIKAHIN_FIREBASE_PRIVATE_KEY` hanya dicentang untuk `Production`, sehingga backend Preview jatuh ke fallback `FIREBASE_PROJECT_ID` milik proyek lain dan gagal menemukan voucher di Firestore Nikahin.
     - `MIDTRANS_SERVER_KEY` di scope `Preview` sempat tidak valid sehingga `charge-core-api` membalas `401 Unauthorized`.
   * **Aturan:** Sebelum E2E dimulai, verifikasi via `vercel env ls preview` / Vercel Dashboard bahwa:
     - Ketiga variabel `NIKAHIN_FIREBASE_*` aktif di **Preview**.
     - `MIDTRANS_IS_PRODUCTION=false` dan `MIDTRANS_SERVER_KEY` di **Preview** berisi kunci **Sandbox** valid (`SB-Mid-server-...`) dengan izin **Core API: Write** dan **Snap Checkout: Write**.
     - **Vercel Deployment Protection** untuk Preview tidak memblokir request API lintas origin (`CORS`).

3. **Daftarkan Origin Subdomain Staging di Google OAuth & Firebase Auth**
   * **Masalah sebelumnya:** Login Google di `https://staging-voucher.nikahin-app.pages.dev` terkena `Error 400: origin_mismatch` karena Google OAuth tidak mendukung wildcard (`*.nikahin-app.pages.dev`).
   * **Aturan:** Daftarkan URL origin persisnya (`https://staging-<nama-fitur>.nikahin-app.pages.dev`) ke **Google Cloud Console → Credentials → Authorized JavaScript origins** dan **Firebase Console → Authentication → Authorized domains**.

4. **Sinkronisasi Settlement & Voucher Wajib Idempoten di Webhook Maupun Status Polling**
   * **Masalah sebelumnya:** Aktivasi `users.accessLevel`, pencatatan `voucher_redemptions`, dan penambahan `vouchers.usedCount` hanya dijalankan di `midtrans-webhook`. Saat webhook Sandbox belum diarahkan ke URL Preview (atau terlambat tiba), `transaction-status` mendeteksi `settlement` tetapi data penukaran voucher tidak tercatat di Firestore.
   * **Aturan:** Logika settlement (`processSettledOrder` di `TrackIt-backend/api/_lib/settlement-helper.ts`) **WAJIB** idempoten dan dipanggil dari kedua jalur: `midtrans-webhook` dan `transaction-status`. Untuk uji webhook langsung di Sandbox, arahkan **Payment Notification URL** di Midtrans Dashboard mode **Sandbox** ke URL webhook Preview.

5. **Teruskan Harga Diskon ke Seluruh Modal/Sheet Lanjutan di UI Checkout**
   * **Masalah sebelumnya:** Halaman utama Paywall sudah menampilkan harga setelah diskon voucher, tetapi `PaymentChannelSelectionModal` masih menampilkan `BusinessConfig.lifetimePrice` secara statis.
   * **Aturan:** Seluruh modal, *bottom sheet*, atau layar rincian pembayaran wajib menerima `amount` (harga aktif) dan `originalAmount` (jika ada diskon) dari state Paywall—dilarang membaca konstanta harga default secara langsung.
