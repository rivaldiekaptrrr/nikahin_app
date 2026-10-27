---
name: flutter-cicd-release-workflow
description: Standar alur kerja CI/CD, rilis versi baru, dan validasi lokal wajib sebelum push ke GitHub pada proyek Flutter Nikahin.
---

# 🚀 Flutter CI/CD & In-App Release Workflow (Nikahin)

Dokumentasi dan pedoman kerja standar untuk CI/CD (GitHub Actions), manajemen rilis versi, dan fitur In-App Updater pada proyek **Nikahin** (`rivaldiekaptrrr/nikahin_app`).

---

## ⚡ ATURAN EMAS: Wajib Validasi & Build Lokal Sebelum Push

Sebelum melakukan `git commit`, `git push`, atau membuat `tag` rilis baru, **WAJIB** menjalankan 3 langkah validasi lokal berikut di terminal:

```bash
# 1. Analisis statis kode (harus: No issues found!)
flutter analyze

# 2. Uji seluruh unit test & widget test (harus: All tests passed!)
flutter test

# 3. Validasi kompilasi binary APK lokal
flutter build apk --release
```

> ⚠️ **PENTING**: Jangan pernah melakukan push ke remote jika salah satu dari ketiga perintah di atas gagal di komputer lokal.

---

## ☁️ ATURAN WAJIB: Otomatis Deploy Firestore Security Rules

Setiap kali ada penambahan atau modifikasi aturan keamanan pada berkas [`firestore.rules`](file:///c:/Project/nikahin_app/firestore.rules) (seperti penambahan koleksi baru, subcollections, atau pembaruan hak akses):

1. **WAJIB Langsung Deploy ke Cloud Firestore**: Dilarang keras membiarkan berkas `firestore.rules` hanya diperbarui secara lokal di Git. Agen atau developer **WAJIB** segera mendeploy aturan tersebut ke server Firebase Cloud agar aplikasi klien tidak mengalami error `403 Forbidden / Permission Denied`.
2. **Langkah Deploy**:
   ```bash
   # Validasi sintaks aturan lokal
   firebase_validate_security_rules (source_file: "firestore.rules", type: "firestore")

   # Deploy langsung ke project Firebase aktif
   firebase_deploy (only: "firestore")
   ```
3. **Verifikasi**: Pastikan deployment berstatus `100% Success` melalui `firebase_deploy_status` sebelum rilis APK atau pengujian dijalankan.

---

## 🔄 Dua Alur Kerja CI/CD (GitHub Actions)

Workflow didefinisikan di [`.github/workflows/multiplatform-build.yml`](file:///c:/Rivaldi/nikahin_app/.github/workflows/multiplatform-build.yml).

### Alur 1: Build Internal Developer (Push ke `master` / `main`)
Gunakan saat mengembangkan fitur harian atau pengujian internal tanpa memicu notifikasi update ke pengguna:

1. Modifikasi kode seperti biasa.
2. Jalankan validasi lokal (`flutter analyze` & `flutter test`).
3. Commit dan push:
   ```bash
   git add .
   git commit -m "feat(module): deskripsi perubahan"
   git push origin master
   ```
4. **Hasil**: GitHub Actions merakit APK internal dan mengunggahnya ke bagian **Artifacts** (`app-nikahin-main.apk`). *Tidak membuat GitHub Release*.

---

### Alur 2: Rilis Resmi ke Pengguna (Push Tag `v*`)
Gunakan saat versi baru siap didistribusikan ke pengguna (memicu pop-up In-App Update di aplikasi):

1. **Naikkan versi di [`pubspec.yaml`](file:///c:/Rivaldi/nikahin_app/pubspec.yaml)**:
   ```yaml
   version: 1.0.1+2   # Format: Mayor.Minor.Patch+BuildNumber
   ```
2. **Tulis catatan rilis di [`RELEASE_NOTES.md`](file:///c:/Rivaldi/nikahin_app/RELEASE_NOTES.md)**:
   > ⚠️ **PENTING**: Gunakan **plain text ringkas** (gunakan simbol bullet `•` atau `-`), **JANGAN** gunakan format markdown kompleks (seperti heading `###`, divider `---`, tebal/miring `**`/`*`) karena isi file ini dibaca langsung sebagai teks biasa pada dialog pop-up pembaruan di dalam aplikasi Flutter. Batasi 3–5 poin utama agar mudah dibaca pengguna di layar HP.
   ```text
   • Pembaruan sistem in-app update otomatis.
   • Peningkatan stabilitas dan perbaikan izin instalasi aplikasi.
   • Optimasi performa dan perbaikan bug minor.
   ```
3. **Validasi & Build Lokal Wajib**:
   ```bash
   flutter analyze
   flutter test
   flutter build apk --release
   ```
4. **Commit Bertahap (Granular & Atomic Commits Tanpa Rilis)** ⚡:
   > ⚠️ **ATURAN INTEGRITAS COMMIT**:
   > 1. **Dilarang Blanket Commit**: Jangan menggabungkan semua perubahan ke dalam satu commit rilis.
   > 2. **Tanpa Rilis di Tahap Awal**: Tahap-tahap awal ini **HANYA** berupa commit biasa (local commits) tanpa membuat atau mem-push tag rilis sama sekali!
   > 
   > Pisahkan perubahan secara rapi sesuai ranah kerjanya:
   ```bash
   # Tahap 1: Guidelines / Docs
   git add AGENTS.md .agents/ docs/ README.md
   git commit -m "docs(guidelines): reinforce online-first architecture and ban pill badges"

   # Tahap 2: Aset Brand & Desain
   git add assets/logo/ macos/ windows/ web/ ios/ android/app/src/main/res/mipmap-*
   git commit -m "style(branding): update app icons across all platforms with warm champagne palette"

   # Tahap 3: Fitur UI Baru
   git add lib/features/splash/ android/app/src/main/res/
   git commit -m "feat(splash): add warm champagne animated luxury splash screen"

   # Tahap 4: Refactor & Perbaikan
   git add lib/features/onboarding/ lib/app/router.dart
   git commit -m "refactor(app): clean router routes and resolve deprecated properties"

   # Setelah commit modular selesai, langsung jalankan push ke master:
   git push origin master
   ```

5. **Commit Versi Rilis & Push Tag (HANYA di Tahap Terakhir)** ⚡:
   Commit terakhir ini khusus menaikkan versi dan catatan rilis, kemudian mengeksekusi push ke master serta mem-push tag rilis untuk memicu GitHub Actions:
   ```bash
   # Commit versi & catatan rilis murni
   git add pubspec.yaml RELEASE_NOTES.md
   git commit -m "chore(release): bump version to v1.0.1 and update release notes"

   # Push seluruh riwayat commit ke master
   git push origin master

   # Buat tag rilis dan push tag untuk memicu alur kerja rilis otomatis
   git tag v1.0.1
   git push origin v1.0.1
   ```

6. **Hasil**: GitHub Actions otomatis membuat **GitHub Release publik**, melampirkan file APK `app-nikahin-v1.0.1.apk`, dan memunculkan pop-up update di aplikasi pengguna.

---

## 🔘 Pusat Sakelar Platform (Platform Toggles)

Dukungan platform dikendalikan di dua tempat:

### 1. Di Kode Dart: [`lib/app/config/platform_config.dart`](file:///c:/Rivaldi/nikahin_app/lib/app/config/platform_config.dart)
```dart
class AppPlatformConfig {
  static const bool enableAndroidSupport = true;
  static const bool enableIosSupport = false;      // Ubah ke true saat siap uji di iOS
  static const bool enableWebSupport = false;      // Ubah ke true saat ingin aktifkan Web
  static const bool enableWindowsSupport = false;  // Ubah ke true saat ingin build Windows
}
```

### 2. Di CI/CD Workflow: [`.github/workflows/multiplatform-build.yml`](file:///c:/Rivaldi/nikahin_app/.github/workflows/multiplatform-build.yml)
```yaml
    steps:
      - id: toggle
        run: |
          echo "build_android=true" >> $GITHUB_OUTPUT
          echo "build_ios=false" >> $GITHUB_OUTPUT
          echo "build_web=false" >> $GITHUB_OUTPUT
          echo "build_windows=false" >> $GITHUB_OUTPUT
```

---

## 🛠️ Komponen In-App Updater

| Komponen | Lokasi File | Fungsi |
|---|---|---|
| **Config** | [`lib/app/config/updater_config.dart`](file:///c:/Rivaldi/nikahin_app/lib/app/config/updater_config.dart) | Endpoint API GitHub Releases |
| **Model** | [`lib/features/updater/domain/models/app_release_info.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/updater/domain/models/app_release_info.dart) | Parsing respon rilis JSON dari GitHub |
| **Checker** | [`lib/features/updater/data/app_update_checker.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/updater/data/app_update_checker.dart) | Komparasi versi semantik (Semantic Versioning) |
| **Downloader** | [`lib/features/updater/data/app_update_downloader.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/updater/data/app_update_downloader.dart) | Download APK streaming dengan progress bar |
| **Installer** | [`lib/features/updater/data/app_update_installer.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/updater/data/app_update_installer.dart) | Pemicu instalasi paket APK Android via `open_filex` |
| **Notifier** | [`lib/features/updater/presentation/update_notifier.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/updater/presentation/update_notifier.dart) | State notifier Riverpod untuk UI update |
| **Dialog UI** | [`lib/features/updater/presentation/widgets/update_dialog.dart`](file:///c:/Rivaldi/nikahin_app/lib/features/updater/presentation/widgets/update_dialog.dart) | Dialog pop-up pembaruan bertema Bento M3 |

---

## 🔐 Penandatanganan Aplikasi (Android Release Signing)

Untuk mencegah error bentrok paket (*signature mismatch*) saat pengguna melakukan in-app update:

1. **Format Keystore**: Gunakan `upload-keystore.jks` dan konfigurasikan `android/key.properties` (lihat template [`android/key.properties.example`](file:///c:/Rivaldi/nikahin_app/android/key.properties.example)).
2. **Panduan Lengkap**: Baca dokumentasi langkah demi langkah di [`docs/ANDROID_SIGNING_GUIDE.md`](file:///c:/Rivaldi/nikahin_app/docs/ANDROID_SIGNING_GUIDE.md).
3. **GitHub Secrets**: Simpan `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, dan `ANDROID_KEY_PASSWORD` pada Settings > Secrets GitHub agar CI/CD build otomatis menggunakan tanda tangan resmi yang sama dengan build lokal.
