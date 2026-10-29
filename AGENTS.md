# Nikahin App - Project Knowledge & Agent Guidelines

## 1. Project Overview
- **Name**: Nikahin App
- **Type**: Standalone Mobile Application (Android & iOS) for Wedding Planning & Budget Management.
- **Repository**: `rivaldiekaptrrr/nikahin_app`
- **Architecture**: Online-First Cloud-Synced with Drift (SQLite) as local offline cache and Cloud Firestore synchronization.
- **Design System**: Material 3 + Bento Grid Layout.
- **Language & Strings**: Strictly in Indonesian for user-facing UI.

---

## 2. Tech Stack & Dependencies
- **Framework**: Flutter (SDK `^3.13.5` / `3.47.6+`) & Dart 3
- **State Management**: Flutter Riverpod
- **Local Persistence**: Drift (SQLite) + `sqlite3_flutter_libs`
- **Routing**: GoRouter
- **Documents & Sharing**: `pdf`, `printing`, `share_plus`
- **Security**: `local_auth` (Biometric & PIN lock)
- **Preferences**: `shared_preferences`
- **In-App Updater**: `package_info_plus`, `open_filex`, and GitHub Releases REST API

---

## 3. Directory Structure (`lib/`)
- `lib/app/`: Configuration, router definitions (`app_router.dart`), theme setup, and platform toggles (`platform_config.dart`).
- `lib/data/`: Drift SQLite tables, DAOs, repositories, and remote sync services.
- `lib/domain/`: Domain models, entities, and business logic enums.
- `lib/features/`: Feature-first modular components:
  - `auth/`: Biometric & PIN lock protection.
  - `budget/`: Itemized expense tracking and payment terms (Belum Bayar, DP, Lunas).
  - `committee/`: Panitia management & uniform/fabric distribution.
  - `dashboard/`: Countdown D-Day, quick stats, romantic quotes.
  - `documents/`: KUA & Civil registration legal checklists.
  - `guests/`: Guest list, classification, RSVP & CSV export.
  - `rundown/`: Multi-event chronological timeline & PIC assignment.
  - `seserahan/`: Hantaran status & packing checklist.
  - `settings/`: App theme, backup/restore, updater, reminders.
  - `tasks/` & `vendors/`: Task checklists & vendor directories.
- `lib/shared/`: Formatters, reusable Bento cards, dialogs, and PDF guidebook generators.
- `lib/ui/theme/`: Colors, typography, and Bento Grid tokens.

---

## 4. CI/CD & Release Workflow
- **Workflow**: Automated GitHub Actions in `.github/workflows/multiplatform-build.yml`.
- **Golden Rule**: Always run local validation before pushing or tagging:
  1. `flutter analyze`
  2. `flutter test`
  3. `flutter build apk --release`
- **Push to `main`/`master`**: Standard commits for development; does NOT trigger GitHub Actions build to conserve runner minutes.
- **Pushing tag `v*` (e.g. `v1.0.0`)**: The dedicated trigger that executes GitHub Actions, builds release APK, creates a GitHub Release, and uses `RELEASE_NOTES.md` as the changelog.

---

## 5. Knowledge Graph & MCP Memory
Knowledge graph data and MCP configurations are versioned inside `.agents/`:
- `.agents/mcp_config.json`: Automatic MCP Memory & Maestro server registration.
- `.agents/knowledge_graph.json`: Machine-readable snapshot of entities and relations.
- `.agents/skills/flutter-environment-setup/SKILL.md`: Complete environment setup, toolchain requirements, and new machine onboarding guide.
- `.agents/skills/flutter-cicd-release-workflow/SKILL.md`: Detailed CI/CD and release workflow guide.
- `.agents/skills/maestro-testing/SKILL.md`: Complete Maestro E2E automated UI testing & MCP integration guide.
- `.agents/skills/clean-response-formatting/SKILL.md`: Standar penulisan format respon bersih, bebas dari raw LaTeX syntax ($...$, \rightarrow).
- `.agents/skills/interactive-agent-workflow/SKILL.md`: Standar alur kerja interaktif, konfirmasi sebelum eksekusi, dan larangan menjalankan tes/analisis otomatis tanpa persetujuan pengguna.
- `.agents/skills/local-knowledge-sync/SKILL.md`: Prosedur sinkronisasi pengetahuan Local-First antara .agents/knowledge_graph.json (Git) dan server MCP Memory.
- `.agents/skills/logo-design/SKILL.md`: Panduan profesional desain logo, brand-mark SVG, lockups, dan identitas visual merek.
- `.agents/skills/flutter-brand-logo-launch/SKILL.md`: Prosedur standar (SOP) end-to-end pembuatan, kurasi geometri, rendering, dan peluncuran logo/ikon ke framework Flutter.
- `.agents/skills/firebase-firestore/SKILL.md`: Panduan resmi pengelolaan Cloud Firestore, data modeling, index, dan REST/SDK operations.
- `.agents/skills/firebase-auth-basics/SKILL.md`: Panduan autentikasi Firebase, token lifecycle, dan manajemen pengguna.
- `.agents/skills/firestore-rules-creation/SKILL.md`: Panduan pembuatan dan optimasi Firestore Security Rules.
- `.agents/skills/firebase-security-rules-auditor/SKILL.md`: Panduan audit keamanan aturan Firestore & Storage.
- `.agents/skills/humanizer-indonesia/SKILL.md`: Standar penyuntingan teks bahasa Indonesia agar luwes, tidak kaku, bebas dari tell AI dan kalke terjemahan.
- `docs/MAESTRO_AND_EMULATOR_SETUP_GUIDE.md`: Complete guide for Android Emulator (CLI without Android Studio) and Maestro MCP testing.
- `docs/BRAND_GUIDELINES.md`: Panduan identitas visual resmi Nikahin App, palet warna, tipografi, dan aturan penggunaan logo.

---

## 6. Firebase & Cloud Firestore Operations
- **Mandatory Skills**: Setiap kali tugas bersinggungan dengan Firestore, Firebase Authentication, atau Security Rules, agen **WAJIB** membaca dan menerapkan pedoman dari skills Firebase resmi yang terpasang di `.agents/skills/`:
  - `firebase-firestore`: Data model, REST API calls, updateMask patterns, query & pagination.
  - `firebase-auth-basics`: ID Token exchange, user management, dan session lifecycle.
  - `firestore-rules-creation` & `firebase-security-rules-auditor`: Audit dan penyusunan security rules yang ketat.
- **Otomatis Deploy Security Rules Saat Modifikasi `firestore.rules`**: Setiap kali ada penambahan atau modifikasi aturan pada `firestore.rules`, agen **WAJIB** segera memvalidasi (`firebase_validate_security_rules`) dan mendeploy aturan tersebut ke Cloud Firestore (`firebase_deploy` dengan target `firestore`) agar server cloud Firebase selalu tersinkronisasi sebelum rilis atau pengujian aplikasi. Dilarang keras membiarkan berkas `firestore.rules` berubah hanya di lokal tanpa dideploy ke Firebase Cloud.

---

## 7. Strict Architectural & Versioning Rules
- **Online-First Cloud-Synced Architecture**: Nikahin App adalah aplikasi berbasis akun online dengan autentikasi (Firebase Auth), sinkronisasi cloud (Cloud Firestore), dan integrasi payment gateway (Midtrans). Drift (SQLite) berfungsi murni sebagai **local cache / offline persistence** ketika jaringan terputus bagi pengguna yang sudah login, dan otomatis sinkron kembali saat online. **DILARANG** menyebut atau memperlakukan arsitektur aplikasi sebagai "Offline-First".
- **Strict Prohibition on Hardcoded Version**: **DILARANG KERAS** melakukan hardcode nomor/string versi aplikasi (misalnya `'Versi 1.0.19'` atau `'v1.0.x'`) di kode UI manapun. Seluruh tampilan versi aplikasi **WAJIB** diambil secara dinamis melalui `package_info_plus` (`PackageInfo.fromPlatform()`). Hardcode versi adalah kesalahan fatal.
- **Anti-Slop Visual Design & No Pill Badge Refleks**: **DILARANG KERAS** membungkus teks subjudul, intro, tagline, atau kutipan dengan kontainer kapsul lonjong / *glass pill badge* (`borderRadius: 20`, border tipis semi-transparan). Desain wajib mengedepankan tipografi editorial yang bernapas bebas, bersih, proporsional, dan elegan tanpa kontainer kapsul buatan AI yang berulang dan klise.
- **Granular & Atomic Commits (Dilarang Blanket Release Commit)**: **DILARANG KERAS** menyatukan/merangkum seluruh pekerjaan (fitur baru, perbaikan bug, pembaruan aset brand, refactoring, dan dokumentasi) ke dalam satu commit tunggal berlabel rilis (seperti `chore(release): bump version...`). Seluruh berkas perubahan **WAJIB** di-commit secara bertahap dan atomik sesuai modul/konteks (`feat(...)`, `style(...)`, `refactor(...)`, `docs(...)`) sebagai **commit lokal biasa tanpa rilis**. Hanya pada tahap paling akhir, commit versi (`chore(release): bump version to vX.X.X and update release notes` pada `pubspec.yaml` dan `RELEASE_NOTES.md`) dieksekusi bersama push ke master dan pembuatan/push git tag rilis.
- **Otomatis Push ke Master Setiap Commit**: Setiap kali commit bertahap (fitur, perbaikan, aset, atau dokumentasi) selesai dibuat, agen **WAJIB** langsung menjalankan `git push origin master` tanpa perlu bertanya lagi kepada pengguna. Pertanyaan/konfirmasi hanya diperlukan untuk mempublikasikan tag rilis (`v*`).
- **Mandatory Humanizer Indonesia Gate (Filter Bahasa Manusia Alami)**: Agen **WAJIB** menerapkan standar dan prinsip dari `.agents/skills/humanizer-indonesia/SKILL.md` secara otomatis pada:
  1. **Seluruh string teks UI** (judul, subjudul, tombol, placeholder, tooltip, snackbar, dialog, dan pesan kesalahan/sukses). Dilarang keras menggunakan gaya bahasa kaku, istilah teknis/korporat mentah (*SLA*, *proses verifikasi aktivasi*), atau kalimat klise robotik (*"Terjadi kesalahan saat..."*).
  2. **Seluruh teks jawaban percakapan kepada pengguna**. Bahasa wajib mengalir wajar, bernada santun dan profesional, serta terbebas dari *tell AI*.
  3. **Self-Check Wajib Sebelum Commit**: Sebelum mengajukan atau membuat commit yang memuat teks bahasa Indonesia, agen wajib melakukan audit kilat: *"Apakah kalimat ini sudah luwes dan terdengar seperti tulisan manusia asli?"*.

---

## 8. Web PWA & Cloudflare Pages Guidelines
- **Production URL**: `https://nikahin-app.pages.dev` (Hosted on Cloudflare Pages, zero egress fees, global edge network).
- **Drift SQLite WebAssembly Persistence**: Menggunakan `sqlite3.wasm` (v3.8.0) dan `drift_worker.js` (v2.35.3) di `web/` yang tersimpan pada IndexedDB browser.
- **Client-Side SPA Routing**: Wajib menjaga `web/_redirects` (`/* /index.html 200`) agar deep link dan page refresh tidak menghasilkan galat HTTP 404.
- **Caching Headers**: `web/_headers` mengatur cache immutable 1 tahun (`max-age=31536000, immutable`) untuk berkas `.wasm` dan `.js`.
- **iOS Safari PWA Optimization**:
  - `viewport-fit=cover` pada meta viewport untuk tampilan fullscreen notch & Dynamic Island iPhone.
  - `apple-touch-icon.png` (180x180 px warna Warm Champagne `#FDF0DE`) untuk ikon layar utama iOS yang tajam.
  - Panduan interaktif Add to Home Screen tersedia di menu Pengaturan (`SettingsPwaInstallCard`).
- **Updater & Platform Guards**: Seluruh pengecekan APK dinonaktifkan di Web melalui `AppPlatformConfig.isApkUpdaterAvailable`, dan panggilan berkas lokal/sensor dilindungi oleh `kIsWeb`.
- **Deploy Command**: `npx wrangler pages deploy build/web --project-name=nikahin-app`.

---

## 9. Couple Sync & Pairing Code Architecture
- **Koleksi Firestore**: `weddings/{weddingId}` dan indeks pencarian `pairingCodes/{code}`.
- **Format Kode**: 6 karakter alfanumerik kapital unik (misal: `NK8X2P`).
- **Role & Relasi**: Menghubungkan dua akun terpisah (CPP dan CPW) ke dokumen pernikahan yang sama sehingga semua sub-koleksi (anggaran, checklist, tamu, panitia, seserahan) tersinkronisasi dua arah secara real-time.
- **Unlink Partner**: Pemutusan pasangan via `CoupleSyncService.unlinkPartner()` mereset `activeWeddingId` akun kembali mandiri tanpa merusak cache lokal dan mematuhi audit keamanan `firestore.rules`.
- **UI Integrasi**: Kartu Pasangan di Pengaturan (`settings_partner_card.dart`) dengan fitur salin kode cepat, status tautan aktif, QR code, dan dialog konfirmasi pemutusan akun.

---

## 10. Local Notification & Android Status Bar Standard
- **Notification Service**: `NotificationService` di `lib/data/services/notification_service.dart`.
- **Android Status Bar Icon Standard**: Wajib menggunakan ikon siluet putih murni dengan latar belakang transparan (`@drawable/ic_notification`). Dilarang menggunakan ikon berwarna penuh atau RGB tanpa transparansi karena Android status bar akan merendernya sebagai kotak abu-abu/hitam pekat kosong.
- **Web Safe Guard**: Seluruh inisialisasi dan penjadwalan notifikasi lokal wajib diproteksi `if (kIsWeb) return;` agar tidak memicu crash di peramban.


