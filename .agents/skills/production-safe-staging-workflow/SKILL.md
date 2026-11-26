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
Saat mem-build dan menguji Web PWA baru, deploy ke cabang *preview* terpisah menggunakan flag `--branch`:
```bash
flutter build web --release
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
