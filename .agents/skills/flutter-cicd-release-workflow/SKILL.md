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
4. **Commit perubahan versi**:
   ```bash
   git add pubspec.yaml RELEASE_NOTES.md
   git commit -m "chore: bump version to v1.0.1 and update release notes"
   git push origin master
   ```
5. **Buat dan Push Tag Versi** ⚡ *(Memicu Rilis GitHub)*:
   ```bash
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
