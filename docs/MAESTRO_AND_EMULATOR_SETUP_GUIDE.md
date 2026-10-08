# Panduan Setup Android Emulator (CLI) & Maestro E2E Testing (MCP)

Dokumen ini berisi panduan lengkap langkah demi langkah untuk menginstal dan mengonfigurasi **Android Virtual Device (Emulator tanpa Android Studio)** serta **Maestro CLI & Maestro MCP** untuk pengujian otomatis (E2E Automated Testing) pada proyek Nikahin App.

---

## 1. Prasyarat Sistem (Prerequisites)

1. **Java Development Kit (JDK)**: JDK 17 (Temurin / OpenJDK).
   - Pastikan path `JAVA_HOME` sudah terdaftar di sistem environment (misal: `C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot\`).
2. **Android SDK Command-Line Tools**:
   - Terpasang di direktori Android SDK (misal: `C:\Android\sdk\cmdline-tools\latest\bin\`).
   - Berisi `sdkmanager.bat` dan `avdmanager.bat`.
3. **Platform Tools (ADB)**:
   - Terpasang di `C:\Android\sdk\platform-tools\` (berisi `adb.exe`).

---

## 2. Setup Android Emulator via CLI (Tanpa Android Studio)

### Langkah 2.1: Unduh Paket Emulator & System Image
Buka PowerShell dan masuk ke folder `cmdline-tools`:
```powershell
cd C:\Android\sdk\cmdline-tools\latest\bin

# Unduh engine emulator dan ROM sistem operasi Android 14 (API 34)
.\sdkmanager.bat "emulator" "system-images;android-34;google_apis;x86_64"
```

### Langkah 2.2: Pasang Driver Akselerasi Hardware (AEHD)
*Wajib untuk Windows agar emulator berjalan lancar dan cepat:*
```powershell
# 1. Unduh paket installer AEHD
.\sdkmanager.bat "extras;google;Android_Emulator_Hypervisor_Driver"

# 2. Jalankan silent install driver
cd C:\Android\sdk\extras\google\Android_Emulator_Hypervisor_Driver
.\silent_install.bat

# 3. Verifikasi status akselerasi
C:\Android\sdk\emulator\emulator.exe -accel-check
# Output sukses: AEHD (version X.X) is installed and usable.
```

### Langkah 2.3: Buat Android Virtual Device (AVD)
Gunakan `avdmanager` untuk membuat virtual device sesuai kebutuhan resource komputer Anda (bisa dijalankan langsung dari terminal mana saja):

```powershell
# Opsi A: Standar HP Modern (Pixel 7 - Resolusi 1080x2400)
# Bagus untuk melihat layout tajam di layar modern, konsumsi RAM ~2 GB
& "C:\Android\sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n nikahin_pixel -k "system-images;android-34;google_apis;x86_64" --device "pixel_7"

# Opsi B: Emulator Super Ringan & Hemat RAM (Nexus 5 - Resolusi 720p / 1080p ringkas)
# Rekomendasi jika RAM laptop 8-16 GB agar tetap dingin dan tidak lag
& "C:\Android\sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n nikahin_lite -k "system-images;android-34;google_apis;x86_64" --device "Nexus 5"

# Opsi C: Tablet Mode (Untuk menguji tampilan responsif layar lebar)
& "C:\Android\sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n nikahin_tablet -k "system-images;android-34;google_apis;x86_64" --device "pixel_tablet"
```

> 💡 **Melihat Semua Daftar Profil Device yang Tersedia**:
> ```powershell
> & "C:\Android\sdk\cmdline-tools\latest\bin\avdmanager.bat" list device
> ```

---

### Langkah 2.4: Menjalankan Emulator via Terminal

#### Opsi 1: Menggunakan Perintah Bawaan Flutter (Paling Praktis)
```powershell
# 1. Melihat daftar emulator yang tersedia
flutter emulators

# 2. Menjalankan emulator versi ringan
flutter emulators --launch nikahin_lite

# 3. Menjalankan emulator standar Pixel 7
flutter emulators --launch nikahin_pixel
```

#### Opsi 2: Menggunakan Binary Emulator Android SDK
```powershell
& "C:\Android\sdk\emulator\emulator.exe" -avd nikahin_lite
```

#### Opsi 3: Langsung Menjalankan Aplikasi Flutter ke Emulator
```powershell
flutter run -d nikahin_lite
```
*(Flutter akan otomatis menyalakan emulator `nikahin_lite`, meng-compile kode, dan membuka aplikasi secara langsung).*

---

### Langkah 2.5: Tips Optimasi Resource (Hemat RAM & CPU)
Jika emulator terasa berat di laptop Anda:
1. **Pilih Resolusi Lebih Rendah**: Profil seperti `Nexus 5` atau `4.7in WXGA` merender piksel 50% lebih sedikit daripada `Pixel 7`, sehingga GPU & CPU bekerja jauh lebih ringan.
2. **Kustomisasi Alokasi RAM di `config.ini`**:
   Buka file konfigurasi AVD Anda di:
   `C:\Users\<Username>\.android\avd\<nama_emulator>.avd\config.ini`
   Sesuaikan parameter berikut:
   ```ini
   hw.ramSize = 1536       # Batasi RAM emulator ke 1.5 GB (default: 2048 MB)
   hw.cpu.ncore = 2        # Batasi ke 2 core CPU agar laptop tidak panas
   vm.heapSize = 256       # Batasi heap memory per aplikasi
   ```
3. **Alternatif Terbaik (Beban RAM Laptop 0 GB)**:
   Colokkan HP Android fisik via kabel data USB dengan **USB Debugging** aktif. Laptop Anda tidak akan terbebani komputasi virtual device sama sekali.

---

## 3. Setup Maestro CLI & Maestro MCP

Maestro digunakan untuk menulis dan mengeksekusi skrip pengujian UI otomatis (End-to-End Testing).

### Langkah 3.1: Lokasi Instalasi Maestro
Pastikan binary Maestro terpasang di direktori (misal: `C:\maestro\bin\`):
- File eksekusi: `C:\maestro\bin\maestro.bat`

Verifikasi versi di terminal:
```powershell
& "C:\maestro\bin\maestro.bat" --version
```

### Langkah 3.2: Daftarkan Maestro MCP Server
Agar AI Assistant dapat melihat layar dan mengontrol emulator secara langsung, daftarkan konfigurasi ke `.agents/mcp_config.json`:

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-memory"
      ]
    },
    "maestro": {
      "command": "C:\\maestro\\bin\\maestro.bat",
      "args": [
        "mcp"
      ],
      "env": {
        "JAVA_HOME": "C:\\Program Files\\Eclipse Adoptium\\jdk-17.0.17.10-hotspot"
      }
    }
  }
}
```

---

## 4. Menjalankan Pengujian (Testing Workflows)

### A. Pengujian Lokal (Gratis & Cepat)
1. Nyalakan Emulator atau hubungkan HP fisik via kabel data USB (USB Debugging ON).
2. Buat skrip flow pengujian di folder `.maestro/`, contoh `.maestro/flow_test.yaml`:
   ```yaml
   appId: com.nikahin.app
   ---
   - launchApp
   - assertVisible: "Nikahin"
   ```
3. Jalankan pengujian di terminal:
   ```powershell
   & "C:\maestro\bin\maestro.bat" test .maestro/flow_test.yaml
   ```

### B. Pengujian Interaktif dengan AI Assistant (Maestro MCP)
Anda cukup memberikan instruksi berbahasa manusia ke AI di chat:
- *"Tolong jalankan aplikasi Nikahin di emulator dan periksa apakah tombol login berfungsi."*
- *"Ambil screenshot dan view hierarchy layar saat ini."*

### C. Pengujian di Maestro Cloud
Jika ingin menjalankan tes pada server cloud Maestro:
```powershell
# 1. Login sekali ke Maestro Cloud
& "C:\maestro\bin\maestro.bat" login

# 2. Build file APK debug
flutter build apk --debug

# 3. Upload dan jalankan di cloud
& "C:\maestro\bin\maestro.bat" cloud build/app/outputs/flutter-apk/app-debug.apk .maestro/
```

---

## 5. Troubleshooting & Tips Performa

| Kendala | Solusi |
| :--- | :--- |
| `x86_64 emulation currently requires hardware acceleration` | Jalankan `C:\Android\sdk\extras\google\Android_Emulator_Hypervisor_Driver\silent_install.bat` untuk mengaktifkan driver AEHD. |
| `The Android emulator exited with code 1` (File lock / multiinstance) | Terjadi jika proses emulator sebelumnya belum tertutup sempurna. Bersihkan file lock dengan menjalankan: `Get-ChildItem -Path "C:\Users\$env:USERNAME\.android\avd\*.avd" -Filter "*.lock" -Recurse \| Remove-Item -Force -Recurse`. |
| `EXCEPTION_ACCESS_VIOLATION_EXEC` / GPU Driver Crash | Terjadi jika GPU renderer emulator tidak cocok dengan driver Intel/Windows. Atur `hw.gpu.mode = host` atau jalankan emulator dengan parameter `-gpu host`. |
| `adb devices` menampilkan daftar kosong | Pastikan emulator sudah selesai proses boot atau kabel USB terhubung dengan mode USB Debugging aktif. |
| Emulator terasa berat / memakan RAM besar | Gunakan device dengan resolusi lebih rendah (`Nexus 5`) atau gunakan HP Android fisik langsung. |
| Port server Maestro viewer | Buka `http://127.0.0.1:9999/` di browser untuk memantau tampilan interaktif Maestro. |
