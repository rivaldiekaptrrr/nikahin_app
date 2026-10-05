# 🔐 Panduan Resmi Penandatanganan Aplikasi (Android Release Signing)

Dokumentasi ini menjelaskan langkah-langkah membuat kunci penandatanganan aplikasi (**Keystore/JKS**) resmi untuk aplikasi **Nikahin**, menggunakannya saat build lokal, serta mengintegrasikannya dengan **GitHub Actions CI/CD Secrets**.

---

## 📌 Mengapa Keystore Penting?
Android mewajibkan setiap aplikasi ditandatangani dengan sertifikat digital. Jika sertifikat/tanda tangan pada APK baru berbeda dengan APK yang sudah terpasang di HP, sistem Android akan menolak update dengan error:
> *"Aplikasi tidak diinstall karena paket ini bentrok dengan paket yang sudah ada."*

Dengan menggunakan Release Keystore yang sama, Anda bisa melakukan update in-app secara mulus selamanya.

---

## 🛠️ Langkah 1: Buat Keystore Pribadi Anda (Jalankan Sekali Saja)

Buka terminal **PowerShell** atau **Command Prompt** di komputer Anda, lalu jalankan perintah `keytool` berikut:

```bash
keytool -genkey -v -keystore upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias nikahin_key
```

> **Catatan Input:**
> 1. Anda akan diminta memasukkan **Password Keystore** (ingat/catat password ini!).
> 2. Anda akan ditanya data identitas (Nama, Organisasi, Kota, Negara). Anda boleh isi singkat (misal nama Anda).
> 3. File bernama `upload-keystore.jks` akan tercipta di direktori tempat Anda menjalankan perintah.

---

## 💻 Langkah 2: Konfigurasi Build Lokal (Di Komputer Anda)

1. Pindahkan berkas `upload-keystore.jks` ke dalam folder proyek:
   ```text
   nikahin_app/
   ├── android/
   │   ├── key.properties        <-- (File konfigurasi rahasia lokal)
   ├── upload-keystore.jks       <-- (File keystore Anda)
   ```
2. Buat berkas baru bernama `android/key.properties` (atau salin dari `android/key.properties.example`):
   ```properties
   storePassword=MASUKKAN_PASSWORD_KEYSTORE_ANDA
   keyPassword=MASUKKAN_PASSWORD_KEYSTORE_ANDA
   keyAlias=nikahin_key
   storeFile=../upload-keystore.jks
   ```
3. Uji build lokal bertanda tangan resmi:
   ```bash
   flutter build apk --release
   ```
   > File `upload-keystore.jks` dan `key.properties` sudah otomatis diabaikan oleh `.gitignore` sehingga aman dan tidak akan terunggah ke GitHub.

---

## ☁️ Langkah 3: Konfigurasi di GitHub Actions (Untuk Otomatisasi CI/CD)

Agar GitHub Actions juga menandatangani APK rilis dengan kunci yang sama:

### 1. Ubah berkas keystore menjadi teks Base64
Jalankan perintah ini di PowerShell pada folder tempat `upload-keystore.jks` berada:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Set-Clipboard
```
*(Teks panjang Base64 otomatis disalin ke clipboard Anda).*

### 2. Masukkan ke GitHub Repository Secrets
1. Buka repositori GitHub Anda: `https://github.com/rivaldiekaptrrr/nikahin_app/settings/secrets/actions`
2. Klik **New repository secret**, lalu tambahkan 4 secret berikut:

| Nama Secret | Nilai / Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | *Paste teks Base64 dari clipboard* |
| `ANDROID_KEYSTORE_PASSWORD` | Password keystore Anda |
| `ANDROID_KEY_ALIAS` | `nikahin_key` |
| `ANDROID_KEY_PASSWORD` | Password keystore Anda |

---

## ✅ Selesai!
Sekarang:
- Setiap kali Anda mem-build lokal (`flutter build apk --release`), APK ditandatangani dengan kunci resmi Anda.
- Setiap kali Anda push tag rilis (`v1.0.x`), GitHub Actions otomatis menandatangani APK dengan kunci yang sama persis.
- Pengguna dapat melakukan **In-App Update** kapan pun tanpa mengalami bentrok tanda tangan.
