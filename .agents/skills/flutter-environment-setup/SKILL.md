---
name: flutter-environment-setup
description: Panduan lengkap prasyarat environment, konfigurasi SDK (Flutter, Android SDK, JDK 17, NDK, CMake), dan langkah inisialisasi project Nikahin di laptop/mesin baru.
---

# 💻 Panduan Setup Environment & Inisialisasi Laptop Baru (Nikahin App)

Dokumentasi standar dan checklist lengkap untuk menyiapkan lingkungan pengembangan (*development environment*) dari nol di komputer/laptop baru agar proyek **Nikahin App** (`rivaldiekaptrrr/nikahin_app`) dapat langsung dijalankan dan di-build tanpa kendala versi.

---

## 📋 1. Spesifikasi Standar Toolchain

Pastikan komponen-komponen berikut terpasang dengan versi yang sesuai:

| Komponen | Versi Rekomendasi | Keterangan & Lokasi Standar |
| :--- | :--- | :--- |
| **Flutter SDK** | **`3.47.6+`** (Dart **`^3.13.5`**) | Disarankan di `C:\src\flutter` (Channel `stable`). |
| **Java JDK** | **JDK 17** (Temurin / Adoptium / OpenJDK) | `C:\Program Files\Eclipse Adoptium\jdk-17.x` |
| **Android SDK Platform** | **Android 36 & 35** (`platforms;android-36`, `platforms;android-35`) | `C:\Android\sdk` atau `%LOCALAPPDATA%\Android\Sdk` |
| **Android Build-Tools** | **`36.0.0`** & `35.0.0` | Diperlukan oleh Gradle & plugin Android modern. |
| **Android NDK & CMake** | **NDK `r28c`** (`28.2.x`) & **CMake `3.22.1`** | Wajib untuk kompilasi library native C++ `sqlite3_flutter_libs`. |
| **Git & Node.js** | Versi terbaru | Digunakan untuk version control dan eksekusi MCP memory. |

---

## ⚙️ 2. Konfigurasi Environment Variables (Windows)

Daftarkan variabel sistem / user environment berikut ke Windows:

```powershell
# 1. Set System/User Environment Variables
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot", [EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Android\sdk", [EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", "C:\Android\sdk", [EnvironmentVariableTarget]::User)

# 2. Tambahkan ke PATH
$newPaths = @(
    "C:\src\flutter\bin",
    "C:\Android\sdk\platform-tools",
    "C:\Android\sdk\cmdline-tools\latest\bin"
)
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
foreach ($p in $newPaths) {
    if ($currentPath -notlike "*$p*") {
        $currentPath = "$p;$currentPath"
    }
}
[Environment]::SetEnvironmentVariable("Path", $currentPath, [EnvironmentVariableTarget]::User)
```

---

## 🚀 3. Instalasi Komponen Android SDK via CLI (Jika Tanpa Android Studio GUI)

Jika menginstal Android SDK secara mandiri melalui `cmdline-tools`:

```bash
# 1. Set lokasi Android SDK ke Flutter
flutter config --android-sdk "C:\Android\sdk"

# 2. Terima semua lisensi SDK
flutter doctor --android-licenses

# 3. Unduh Platform, Build-Tools, NDK, dan CMake yang dibutuhkan
sdkmanager "platforms;android-36" "platforms;android-35" "build-tools;36.0.0" "cmake;3.22.1" "ndk;28.2.13676664"
```

---

## 📦 4. Langkah Inisialisasi Proyek di Laptop Baru

Buka terminal di direktori proyek `c:\Project\nikahin_app` lalu jalankan berurutan:

```bash
# Langkah 1: Validasi kesiapan toolchain
flutter doctor -v

# Langkah 2: Unduh semua dependensi pubspec
flutter pub get

# Langkah 3: Generate skema tabel database Drift SQLite & DAOs (Wajib!)
dart run build_runner build --delete-conflicting-outputs
```

---

## 🧪 5. Verifikasi Akhir Kualitas (*Golden Rules*)

Pastikan seluruh verifikasi lokal berhasil sebelum mulai bekerja:

```bash
# 1. Static Analysis (Harus: No issues found!)
flutter analyze

# 2. Unit & Widget Tests (Harus: All tests passed!)
flutter test

# 3. Kompilasi Release APK (Memastikan Gradle & NDK build sukses)
flutter build apk --release
```

---

## 📱 6. Menjalankan Aplikasi (*Run & Debug*)

```bash
# Cek perangkat atau emulator yang aktif
flutter devices

# Jalankan ke perangkat
flutter run
```
