# Nikahin

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Drift%20SQLite-410099?style=for-the-badge&logo=sqlite&logoColor=white" alt="Drift SQLite" />
  <img src="https://img.shields.io/badge/Riverpod-38B2AC?style=for-the-badge&logoColor=white" alt="Riverpod" />
  <img src="https://img.shields.io/badge/Material_3-7057FF?style=for-the-badge&logo=materialdesign&logoColor=white" alt="Material 3" />
</p>

<p align="center">
  <strong>Solusi Perencana Pernikahan Modern, Terstruktur, dan Terintegrasi untuk Mempersiapkan Momen Bahagia Anda Bersama Pasangan.</strong>
</p>

---

## 💍 Tentang Nikahin

**Nikahin** adalah aplikasi *wedding planner* komprehensif berbasis *mobile* yang dirancang khusus untuk memenuhi kebutuhan persiapan pernikahan di Indonesia (baik adat tradisi maupun nasional/modern). Aplikasi ini menggabungkan manajemen anggaran, rekanan vendor, susunan acara (*rundown*), daftar tamu & RSVP, berkas nikah KUA/Catatan Sipil, seserahan mahar, serta pembagian seragam panitia ke dalam satu wadah yang terintegrasi.

Dibangun dengan arsitektur **Offline-First** menggunakan database lokal Drift (SQLite) berkemampuan sinkronisasi cloud, Nikahin menjamin data penting Anda tetap aman, responsif, dan dapat diakses tanpa koneksi internet.

---

## ✨ Fitur-Fitur Unggulan

### 1. 📊 Dashboard & Countdown Interaktif
- **Hitung Mundur Pernikahan**: Menampilkan sisa hari, jam, dan menit menuju hari bahagia.
- **Kutipan Romantis Kustom**: Tampilkan kalimat doa atau janji cinta di dashboard dengan opsi gaya font (*Italic, Bold*) dan ukuran yang dapat diatur.
- **Ringkasan Cepat**: Status ringkas batas anggaran, estimasi pengeluaran, progress tugas persiapan, dan dokumen KUA.

### 2. 💰 Manajemen Anggaran & Rekanan Vendor
- **Pelacakan Pos Biaya**: Kategori pengeluaran mencakup Venue, Katering, Dekorasi, MUA & Busana, Dokumentasi, Seserahan, Undangan, dll.
- **Termin Pembayaran Bertahap**: Pantau pembayaran berstatus *Belum Bayar*, *DP Terbayar*, hingga *Lunas*.
- **Database Vendor**: Simpan kontak *Person in Charge* (PIC), nomor telepon, nilai kontrak, serta status kerja sama rekanan vendor.

### 3. ⏱️ Susunan Acara (Rundown Timeline)
- **Multi-Event Terjadwal**: Dukungan untuk banyak acara (Lamaran, Pengajian, Siraman, Akad Nikah, Resepsi) yang diurutkan secara kronologis otomatis.
- **Visual Node Timeline**: Tampilan garis waktu vertikal yang modern dengan durasi menit dan penanggung jawab (PIC) per sesi kegiatan.

### 4. 👥 Buku Tamu & Manajemen RSVP
- **Pengelompokan Tamu**: Kategorisasi tamu (Keluarga CPP, Keluarga CPW, Teman CPP, Teman CPW, Tamu VIP, Umum).
- **Target Sesi Undangan**: Alokasikan tamu ke sesi spesifik (*Akad Saja*, *Resepsi Saja*, atau *Keduanya*).
- **Estimasi Pax & Status Kehadiran**: Rekap jumlah porsi makanan berdasarkan konfirmasi RSVP (*Hadir, Menunggu, Tidak Hadir*).
- **Ekspor CSV**: Unduh daftar tamu dalam format *spreadsheet* CSV siap pakai untuk tim penerima tamu di meja registrasi.

### 5. 📋 Checklist Berkas Pernikahan (KUA / Catatan Sipil)
- **Persyaratan Lengkap**: Menyesuaikan kebutuhan dokumen calon pengantin pria (CPP), calon pengantin wanita (CPW), atau berkas bersama.
- **Target Deadline & Auto-Sorting**: Tentukan tanggal batas pengurusan berkas, diurutkan berdasarkan tanggal terdekat, dan dokumen yang selesai otomatis berpindah ke bawah.

### 6. 🎁 Seserahan Mahar & Panitia Keluarga
- **Daftar Hantaran & Mahar**: Pantau daftar barang seserahan CPP → CPW, balasan CPW → CPP, estimasi nilai rupiah, serta status barang (*Belum Beli, Dibeli, Sedang Dihias, Siap*).
- **Struktur Panitia & Seragam**: Catat peran anggota panitia, alokasi meteran kain seragam, dan status penjahitan.

### 7. 📄 Ekspor Buku Panduan Nikah (PDF)
- **Laporan Lengkap Siap Cetak**: Menghasilkan dokumen resmi A4 berformat tabel adaptif yang mencakup rincian anggaran, daftar vendor, susunan acara, panitia, dokumen KUA, dan seserahan.
- **Bebas Teks Terpotong**: Desain tabel proporsional dengan penanganan nomor halaman otomatis (`Halaman X dari Y`).

### 8. 🛡️ Keamanan & Kustomisasi
- **Kunci Biometrik**: Amankan akses data pernikahan dengan sensor sidik jari atau PIN perangkat.
- **Tema Fleksibel**: Pilihan mode tampilan *Sistem*, *Terang*, atau *Gelap*.
- **Pengingat Harian**: Notifikasi berkala untuk memantau sisa tugas dan berkas yang mendekati batas waktu.

---

## 🛠️ Teknologi & Arsitektur

| Komponen | Teknologi / Pustaka |
|---|---|
| **Framework** | [Flutter](https://flutter.dev) (SDK ^3.8.0) & Dart 3 |
| **State Management** | [Flutter Riverpod](https://riverpod.dev) |
| **Local Database** | [Drift](https://drift.simonbinder.eu/) (SQLite) + `sqlite3_flutter_libs` |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) |
| **Dokumen & Ekspor** | [pdf](https://pub.dev/packages/pdf), [printing](https://pub.dev/packages/printing), [share_plus](https://pub.dev/packages/share_plus) |
| **UI & Desain** | Material 3, Google Fonts, Custom Bento Design System |
| **Keamanan** | `local_auth` (Biometrik / Fingerprint) |
| **Penyimpanan Preferensi** | `shared_preferences` |

---

## 📂 Struktur Direktori

```text
lib/
├── app/
│   ├── app.dart                    # Inisialisasi MaterialApp & Theme Mode
│   ├── config/                     # Konfigurasi aplikasi
│   └── router.dart                 # Konfigurasi navigasi rute GoRouter
├── data/
│   ├── local/                      # Drift SQLite database, tabel, & DAO
│   ├── remote/                     # Sinkronisasi cloud Firestore REST
│   └── repositories/               # Repository layer (wedding data repository)
├── domain/
│   ├── enums/                      # Enum domain (kategori, status bayar, vendor, dll.)
│   └── models/                     # Model data & entity domain
├── features/
│   ├── auth/                       # Onboarding & Welcome Screen
│   ├── budget/                     # Manajemen anggaran & pengeluaran
│   ├── dashboard/                  # Dashboard utama & countdown pernikahan
│   ├── documents/                  # Checklist berkas KUA & Sipil
│   ├── guests/                     # Buku tamu undangan & RSVP
│   ├── profile_select/             # Pemilihan profil pasangan
│   ├── rundown/                    # Susunan acara timeline & multi-event
│   ├── seserahan_committee/        # Daftar seserahan & panitia seragam
│   ├── settings/                   # Pengaturan profil, tema, & ekspor
│   ├── tasks/                      # Manajemen checklist tugas persiapan
│   └── vendors/                    # Katalog rekanan vendor
├── shared/
│   ├── utils/                      # Formatter mata uang, tanggal, & generator PDF/CSV
│   └── widgets/                    # Komponen UI Bento Card, dialog panduan, picker
└── ui/
    └── theme/                      # Definisi tema warna & gaya tipografi
```

---

## 🚀 Memulai (Getting Started)

### Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) versi 3.24.0 atau yang lebih baru.
- Android Studio / VS Code dengan ekstensi Flutter & Dart.
- Perangkat Android fisik atau Emulator (min. Android 7.0 / SDK 24).

### Langkah Instalasi

1. **Clone repositori**:
   ```bash
   git clone https://github.com/username/nikahin_app.git
   cd nikahin_app
   ```

2. **Pasang dependensi**:
   ```bash
   flutter pub get
   ```

3. **Generate kode Drift / Database (opsional jika ada perubahan skema)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

---

## 📱 Build Rilis (Production)

### Android APK
```bash
flutter build apk --release
```
File APK siap instalasi akan dihasilkan di `build/app/outputs/flutter-apk/app-release.apk`.

### Android App Bundle (Google Play Store)
```bash
flutter build appbundle --release
```

---

## 📄 Lisensi

Proyek ini dikembangkan untuk penggunaan pribadi dan komersial di bawah lisensi terbuka. Silakan merujuk ke berkas `LICENSE` untuk informasi lebih lanjut.
