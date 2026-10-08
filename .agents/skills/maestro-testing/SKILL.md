---
name: maestro-testing
description: Panduan komprehensif penulisan, eksekusi, dan integrasi Maestro E2E UI Testing serta penggunaan Maestro MCP Server untuk pengujian otomatis aplikasi mobile (Android & iOS) dan Web pada proyek Nikahin.
---

# 🎭 Maestro E2E Testing & MCP Skill Guide (Nikahin App)

Skill ini menyediakan panduan lengkap, standar penulisan skrip pengujian (Flows), referensi sintaks YAML, dan alur kerja integrasi **Maestro MCP (Model Context Protocol)** pada proyek **Nikahin App**.

---

## 📑 Daftar Isi
1. [Overview & Arsitektur](#1-overview--arsitektur)
2. [Maestro MCP Tools (Untuk AI Agent)](#2-maestro-mcp-tools-untuk-ai-agent)
3. [Standar Struktur Folder Pengujian](#3-standar-struktur-folder-pengujian)
4. [Anatomi Skrip Flow Maestro (`.yaml`)](#4-anatomi-skrip-flow-maestro-yaml)
5. [Contoh Kasus Pengujian Nikahin App](#5-contoh-kasus-pengujian-nikahin-app)
6. [Best Practices Pengujian Flutter](#6-best-practices-pengujian-flutter)
7. [Perintah Eksekusi CLI](#7-perintah-eksekusi-cli)

---

## 1. Overview & Arsitektur

* **App ID Android**: `com.nikahin.app`
* **Framework**: Flutter Material 3 + Bento Grid
* **Maestro CLI Binary**: `C:\maestro\bin\maestro.bat` (v2.11.0+)
* **Maestro Viewer**: `http://127.0.0.1:9999/`
* **Target Perangkat**:
  - HP Android Fisik via USB Debugging (ID: `fd338270` atau via `adb devices`).
  - Web Browser (`chromium`).
  - Maestro Cloud (`maestro cloud`).

---

## 2. Maestro MCP Tools (Untuk AI Agent)

Saat berinteraksi dengan AI Assistant, tools berikut tersedia melalui Maestro MCP Server:

| Tool MCP | Deskripsi & Fungsi |
| :--- | :--- |
| `list_devices` | Mendeteksi semua perangkat lokal (Android/iOS/Web) yang aktif. |
| `inspect_screen` | Mengambil seluruh pohon elemen UI (*view hierarchy*) pada layar aktif. |
| `take_screenshot` | Mengambil screenshot layar perangkat secara visual. |
| `run` | Menjalankan file skrip flow `.yaml` atau inline commands secara langsung. |
| `cheat_sheet` | Menampilkan dokumentasi lengkap sintaks Maestro. |
| `open_maestro_viewer` | Membuka server viewer interaktif di browser lokal. |
| `list_cloud_devices` | Melihat daftar perangkat virtual yang tersedia di Maestro Cloud. |
| `run_on_cloud` | Mengunggah APK dan menjalankan test suite di cloud virtual device. |
| `get_cloud_run_status` | Memeriksa status eksekusi cloud run (RUNNING, PASSED, FAILED). |
| `describe_cloud_run` | Mengambil log, video URL, dan laporan detail hasil cloud test. |

---

## 3. Standar Struktur Folder Pengujian

Seluruh skrip pengujian Maestro diletakkan di dalam direktori `.maestro/`:

```
c:\Project\nikahin_app/
├── .maestro/
│   ├── config.yaml                     # Konfigurasi global & env
│   ├── 01_onboarding_demo_flow.yaml    # Uji Welcome Screen & Mode Demo
│   ├── 02_auth_login_flow.yaml         # Uji Login & Registrasi
│   ├── 03_wedding_setup_flow.yaml      # Uji Form Setup Pengantin Baru
│   ├── 04_budget_management_flow.yaml  # Uji Tambah Pengeluaran & Termin DP
│   ├── 05_guest_rsvp_flow.yaml         # Uji Input Tamu & Export CSV
│   └── 06_settings_backup_flow.yaml    # Uji Ganti Tema, Backup, & Update
```

---

## 4. Anatomi Skrip Flow Maestro (`.yaml`)

Format standar file flow pengujian:

```yaml
appId: com.nikahin.app
name: "Uji Coba Alur Demo Nikahin"
tags:
  - smoke-test
  - demo
---
- launchApp:
    clearState: false   # true jika ingin reset data aplikasi dari awal

# Assert & Interaksi Teks
- assertVisible: "Nikahin"
- tapOn: "Lewati"

# Menunggu elemen / loading selesai
- extendedWaitUntil:
    visible: "Masuk Akun"
    timeout: 5000

# Input data form
- tapOn: "Email"
- inputText: "tesuser@example.com"
- hideKeyboard

# Scrolling
- scrollUntilVisible:
    element: "Simpan"
    direction: DOWN

- tapOn: "Simpan"
```

---

## 5. Contoh Kasus Pengujian Nikahin App

### A. Uji Coba Mode Demo (`01_onboarding_demo_flow.yaml`)
```yaml
appId: com.nikahin.app
---
- launchApp
- tapOn:
    text: "Coba Mode Tamu"
    optional: true
- assertVisible: "Rivaldi & Alya"
- assertVisible: "Hitung Mundur"
```

### B. Uji Coba Setup Pernikahan Baru (`03_wedding_setup_flow.yaml`)
```yaml
appId: com.nikahin.app
---
- launchApp
- assertVisible: "Setup Rencana Pernikahan"
- tapOn: "Nama Lengkap CPP"
- inputText: "Budi Pratama"
- tapOn: "Nama Lengkap CPW"
- inputText: "Siti Rahma"
- hideKeyboard
- scrollUntilVisible:
    element: "Simpan & Lanjutkan"
    direction: DOWN
- tapOn: "Simpan & Lanjutkan"
- assertVisible: "Budi & Siti"
```

---

## 6. Best Practices Pengujian Flutter

1. **Gunakan Text Matcher yang Unik**:
   - Flutter merender Semantic Label. Pastikan matcher teks seperti `tapOn: "Simpan & Lanjutkan"` cocok persis dengan `Text('Simpan & Lanjutkan')` di widget.
2. **Gunakan `hideKeyboard` Setelah Input Form**:
   - Pada HP Android fisik, keyboard virtual sering menutupi tombol submit. Selalu panggil `- hideKeyboard` sebelum `- tapOn: "Simpan"`.
3. **Gunakan `extendedWaitUntil` untuk Operasi Asinkron**:
   - Jika ada proses simpan database SQLite / network sync, gunakan `extendedWaitUntil` dengan timeout 3000-5000ms.
4. **Hindari Hardcoded Delay**:
   - Jangan gunakan `sleep` sembarangan; gunakan assertion berbasis elemen visible.

---

## 7. Perintah Eksekusi CLI

```powershell
# 1. Jalankan test spesifik pada HP yang terhubung
& "C:\maestro\bin\maestro.bat" --device <DEVICE_ID> test .maestro/01_onboarding_demo_flow.yaml

# 2. Jalankan seluruh test suite di folder .maestro/
& "C:\maestro\bin\maestro.bat" --device <DEVICE_ID> test .maestro/

# 3. Mode Interaktif Studio / Hierarchy Viewer
& "C:\maestro\bin\maestro.bat" --device <DEVICE_ID> hierarchy

# 4. Merekam Video Pengujian
& "C:\maestro\bin\maestro.bat" --device <DEVICE_ID> record .maestro/01_onboarding_demo_flow.yaml
```
