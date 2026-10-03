# PRD — Nikahin (Wedding Planner Flutter App)
> **Nama Produk / Brand**: **Nikahin**  
> **Versi**: 1.0.0  
> **Tanggal**: 2026-10-03  
> **Tujuan Dokumen**: Blueprint komprehensif untuk AI Agent yang akan membangun ulang modul Wedding Planner dari aplikasi Android TrackIt (Kotlin/Compose) menjadi **aplikasi Flutter mandiri** bernama **Nikahin** yang berjalan di Android & iOS.

---

## 0. Konteks & Latar Belakang

### Sumber Kode Referensi
Proyek asal: `c:/Rivaldi/Track-app` (repo: `rivaldiekaptrrr/Track-app`)

Aplikasi TrackIt adalah **aplikasi 2-in-1**: Expense Tracker + Wedding Planner dalam satu APK Android. Tujuan migrasi adalah memisahkan Wedding Planner menjadi aplikasi Flutter lintas platform yang berdiri sendiri dengan nama brand **"Nikahin"**.

### Struktur Folder Wedding di Android (REFERENSI)
```
app/src/main/java/com/trackit/app/
├── ui/wedding/
│   ├── dashboard/          ← Layar utama (WeddingDashboardScreen.kt + ViewModel)
│   ├── budget/             ← Manajemen anggaran (WeddingBudgetScreen.kt + ViewModel)
│   ├── guests/             ← Daftar tamu (WeddingGuestsScreen.kt + ViewModel)
│   ├── vendor/             ← Manajemen vendor (WeddingVendorScreen.kt + ViewModel)
│   ├── tasks/              ← Timeline & tugas (WeddingTasksScreen.kt + ViewModel)
│   ├── committee/          ← Panitia & seragam (WeddingCommitteeScreen.kt + ViewModel)
│   ├── rundown/            ← Rundown acara (WeddingRundownScreen.kt + ViewModel)
│   ├── seserahan/          ← Seserahan & mahar (WeddingSeserahanScreen.kt + ViewModel)
│   ├── documents/          ← Dokumen pernikahan (WeddingDocumentsScreen.kt + ViewModel)
│   ├── settings/           ← Pengaturan Wedding (WeddingSettingsScreen.kt + ViewModel)
│   └── common/
│       ├── DeleteConfirmDialog.kt    ← Dialog konfirmasi hapus (reusable)
│       └── WeddingScreenGuideDialog.kt ← Dialog panduan fitur (reusable)
├── data/local/entity/
│   ├── WeddingProfileEntity.kt
│   ├── WeddingExpenseEntity.kt
│   ├── WeddingPaymentTermEntity.kt
│   ├── WeddingGuestEntity.kt
│   ├── WeddingVendorEntity.kt
│   ├── WeddingTaskEntity.kt
│   ├── WeddingCommitteeEntity.kt
│   ├── WeddingRundownEntities.kt     ← berisi WeddingEventEntity + WeddingRundownItemEntity
│   ├── WeddingSeserahanEntity.kt
│   └── WeddingDocumentEntity.kt
├── data/local/dao/
│   ├── WeddingProfileDao.kt
│   ├── WeddingExpenseDao.kt
│   ├── WeddingPaymentTermDao.kt
│   ├── WeddingGuestDao.kt
│   ├── WeddingVendorDao.kt
│   ├── WeddingTaskDao.kt
│   ├── WeddingCommitteeDao.kt
│   ├── WeddingRundownDao.kt          ← WeddingEventDao + WeddingRundownItemDao
│   ├── WeddingSeserahanDao.kt
│   └── WeddingDocumentDao.kt
├── data/repository/
│   └── WeddingProfileRepository.kt  ← (per-entity, masing-masing repo mirip)
└── util/
    ├── SyncManager.kt                ← Firestore REST sync untuk wedding
    └── FirestoreMapper.kt            ← Serialisasi entity ↔ Firestore JSON
```

---

## 1. Identitas Brand & Tujuan Produk

### 1.1 Identitas Brand
- **Nama Aplikasi / Brand**: **Nikahin**
- **Tagline**: *"Rencanakan Momen Bahagiamu Tanpa Ribet"* / *"Asisten Pintar Pernikahan Impianmu"*
- **Package ID / Bundle Identifier**: `com.nikahin.app`
- **Nuansa Desain**: Warm, elegant, romantic, modern (Rose gold / Warm Coral / Champagne Gold & Soft White/Dark Charcoal)

### 1.2 Tujuan Produk
Membangun **"Nikahin"** — aplikasi mobile Flutter standalone yang membantu calon pengantin dan pasangan di Indonesia merencanakan pernikahan secara terstruktur, teratur, dan bebas stres dengan fitur:
- Manajemen anggaran pernikahan (Wedding Budget & Payment Terms)
- Pengelolaan tamu undangan & estimasi porsi katering
- Manajemen vendor, status kontrak, dan termin pembayaran
- Timeline & to-do list persiapan (terintegrasi reminder)
- Panitia & manajemen seragam keluarga/bridesmaid/groomsmen
- Rundown acara detail per sesi (Akad/Pemberkatan, Resepsi, dll.)
- Seserahan, mahar, dan balasan adat
- Checklist kelengkapan dokumen administrasi (KUA & Dukcapil)
- Sinkronisasi cloud (Firestore) opsional untuk kolaborasi pasangan realtime

---

## 2. Target Pengguna

- Pasangan yang akan menikah di Indonesia (semua agama, berbagai adat)
- Keluarga / WO yang membantu perencanaan
- Usia: 20–35 tahun
- Platform: Android (prioritas) + iOS (sekunder via Flutter)
- Bahasa UI: **Bahasa Indonesia**

---

## 3. Arsitektur Flutter yang Direkomendasikan

### Stack Teknologi
```
Flutter (Dart)
├── State Management  : Riverpod 2.x (atau BLoC — pilih satu, konsisten)
├── Database Lokal    : Drift (SQLite, typed, reactive) atau isar
├── Backend/Cloud     : Firebase Firestore (via flutterfire) + Firebase Auth
├── DI               : Riverpod atau get_it + injectable
├── Navigation        : GoRouter
├── UI Library        : Material 3 (Flutter native)
└── Utilities         : intl (formatting), uuid, shared_preferences
```

### Struktur Folder Flutter yang Disarankan
```
lib/
├── main.dart
├── app/
│   ├── router.dart               ← GoRouter setup
│   └── theme.dart                ← Material 3 theme
├── data/
│   ├── local/
│   │   ├── database.dart         ← Drift DB schema
│   │   ├── tables/               ← Table definitions (mirip Entity Android)
│   │   └── daos/                 ← Drift DAOs
│   ├── remote/
│   │   ├── firestore_service.dart
│   │   └── sync_manager.dart     ← Push/Pull logic
│   └── repositories/             ← Abstraction over local + remote
├── domain/
│   └── models/                   ← Pure Dart model classes
├── features/
│   ├── auth/                     ← Login screen, auth state
│   ├── dashboard/                ← Wedding Dashboard
│   ├── budget/                   ← Anggaran
│   ├── guests/                   ← Tamu
│   ├── vendors/                  ← Vendor
│   ├── tasks/                    ← Timeline & Tugas
│   ├── committee/                ← Panitia
│   ├── rundown/                  ← Rundown
│   ├── seserahan/                ← Seserahan
│   ├── documents/                ← Dokumen
│   └── settings/                 ← Pengaturan
└── shared/
    ├── widgets/                  ← Shared UI components
    └── utils/                    ← Currency, date, etc.
```

---

## 4. Model Data (Domain Models)

Setiap model di bawah ini harus diimplementasi sebagai **Dart class** dan juga sebagai **Drift Table**. Gunakan `uuid` package untuk generate ID String.

---

### 4.1 WeddingProfile (Root Entity)

> **Android Source**: `WeddingProfileEntity.kt`  
> **Room Table**: `wedding_profiles`  
> **Catatan**: Ini adalah root/parent dari semua entity wedding. Semua entity lain punya FK ke `id` profil ini.

```dart
class WeddingProfile {
  final String id;               // UUID, PK
  final String groomName;        // Nama mempelai pria (CPP)
  final String brideName;        // Nama mempelai wanita (CPW)
  final int weddingDate;         // Epoch millis tanggal pernikahan
  final double totalBudgetCap;   // Total budget ceiling (default: 0.0)
  
  // Agama & Adat
  // ISLAM (→ KUA) / NON_ISLAM (→ Dukcapil)
  final String religionType;     // 'ISLAM' | 'NON_ISLAM'
  // ISLAM, KRISTEN, KATOLIK, HINDU, BUDDHA, KONGHUCU, LAINNYA
  final String? religionDetail;
  // JAWA, SUNDA, BATAK, MINANG, BUGIS_MAKASSAR, BALI, BETAWI, TIONGHOA, MODERN, LAINNYA
  final String? culturalPresetGroom;
  final String? culturalPresetBride;
  
  // Kutipan di Dashboard Hero Card
  final String? quote;
  final bool quoteEnabled;       // true = tampilkan quote
  // KECIL | SEDANG | BESAR
  final String quoteFontSize;
  // NORMAL | BOLD | ITALIC | BOLD_ITALIC
  final String quoteFontStyle;
  
  final int createdAt;           // Epoch millis (System.currentTimeMillis)
}
```

**Catatan Penting**: `religionType` menentukan alur dokumen:
- `ISLAM` → checklist dokumen untuk KUA
- `NON_ISLAM` → checklist dokumen untuk Dukcapil/Catatan Sipil

---

### 4.2 WeddingExpense

> **Android Source**: `WeddingExpenseEntity.kt`  
> **Room Table**: `wedding_expenses`  
> **Relasi**: MANY → ONE ke `WeddingProfile` (CASCADE DELETE)

```dart
class WeddingExpense {
  final String expenseId;        // UUID, PK
  final String weddingProfileId; // FK ke WeddingProfile.id

  // Kategori: VENUE, CATERING, DECOR, MUA, DOKUMENTASI,
  //           SESERAHAN, UNDANGAN, LAINNYA
  final String category;
  final String title;
  final double totalEstimated;   // Total estimasi biaya
  final double totalPaid;        // Total sudah dibayar (default: 0.0)

  // Sumber dana: TABUNGAN_CPP, TABUNGAN_CPW, ORTU_CPP, ORTU_CPW, BERSAMA
  final String paidBySource;     // default: 'BERSAMA'

  // Status: UNPAID, PARTIAL_DP, FULLY_PAID
  final String paymentStatus;    // default: 'UNPAID'
  final String? notes;
  final int createdAt;
}
```

**Business Logic**:
- `paymentStatus` dihitung otomatis dari payment terms:
  - `totalPaid == 0` → `UNPAID`
  - `0 < totalPaid < totalEstimated` → `PARTIAL_DP`
  - `totalPaid >= totalEstimated` → `FULLY_PAID`
- `totalPaid` = SUM dari `WeddingPaymentTerm.amount` yang `isPaid = true`

---

### 4.3 WeddingPaymentTerm

> **Android Source**: `WeddingPaymentTermEntity.kt`  
> **Room Table**: `wedding_payment_terms`  
> **Relasi**: MANY → ONE ke `WeddingExpense` (CASCADE DELETE)

```dart
class WeddingPaymentTerm {
  final String termId;     // UUID, PK
  final String expenseId;  // FK ke WeddingExpense.expenseId

  final String termName;   // "DP 1", "DP 2", "Pelunasan" (free text)
  final double amount;     // Nominal termin
  final int dueDate;       // Epoch millis jatuh tempo
  final bool isPaid;       // default: false
  final int? paidDate;     // Epoch millis saat lunas (nullable)
}
```

---

### 4.4 WeddingGuest

> **Android Source**: `WeddingGuestEntity.kt`  
> **Room Table**: `wedding_guests`  
> **Relasi**: MANY → ONE ke `WeddingProfile` (CASCADE DELETE)

```dart
class WeddingGuest {
  final String guestId;          // UUID, PK
  final String weddingProfileId; // FK

  final String guestName;
  final String? phoneNumber;

  // Kelompok: KELUARGA_CPP, KELUARGA_CPW, TEMAN_CPP, TEMAN_CPW, VIP
  // (dapat ditambahkan custom group oleh user)
  final String groupAllocation;  // default: 'TEMAN_CPP'

  // Sesi yang diundang: AKAD, RESEPSI, KEDUANYA
  final String sessionTarget;    // default: 'KEDUANYA'

  final int estimatedPax;        // Estimasi jumlah orang (default: 2)

  // Status RSVP: PENDING, ATTENDING, DECLINED
  final String rsvpStatus;       // default: 'PENDING'
}
```

**Fitur Import Kontak**: Di Android, ada fitur import dari kontak HP (batch multi-select). Di Flutter gunakan `contacts_service` atau `flutter_contacts` package.

---

### 4.5 WeddingVendor

> **Android Source**: `WeddingVendorEntity.kt`  
> **Room Table**: `wedding_vendors`  
> **Relasi**: MANY → ONE ke `WeddingProfile` (CASCADE DELETE)

```dart
class WeddingVendor {
  final String vendorId;         // UUID, PK
  final String weddingProfileId; // FK

  // Kategori: VENUE, CATERING, DECOR, MUA, DOKUMENTASI,
  //           MUSIK, WO, SOUVENIR, LAINNYA
  final String category;
  final String name;             // Nama vendor
  final String? picName;         // Nama contact person
  final String? phoneNumber;
  final String? instagramHandle; // Handle IG (tanpa @)
  final double contractValue;    // Nilai kontrak (default: 0.0)
  final String? notes;

  // Status: PROSPEK, TANDA_JADI, KONTRAK, SELESAI
  final String status;           // default: 'PROSPEK'
  final int createdAt;
}
```

---

### 4.6 WeddingTask

> **Android Source**: `WeddingTaskEntity.kt`  
> **Room Table**: `wedding_tasks`  
> **Relasi**: MANY → ONE ke `WeddingProfile` (CASCADE DELETE)

```dart
class WeddingTask {
  final String taskId;           // UUID, PK
  final String weddingProfileId; // FK

  // Phase: 12 = 12 bulan sebelum, 6 = 6 bulan sebelum,
  //         3 = 3 bulan, 1 = 1 bulan, 0 = Hari-H
  final int phaseMonth;
  final String title;
  final String? description;

  // PIC: GROOM, BRIDE, BOTH, FAMILY, WO
  final String pic;              // default: 'BOTH'
  final bool isCompleted;        // default: false
  final int? dueDate;            // Epoch millis (nullable)
  final int? completedDate;      // Epoch millis (nullable)
  final int sortOrder;           // default: 0 (untuk drag-reorder)
}
```

**Template Task Bawaan**: Saat WeddingProfile baru dibuat, app otomatis seed task-task template berdasarkan `culturalPreset` dan `religionType`. Lihat Bagian 7 untuk daftar template.

---

### 4.7 WeddingCommitteeMember

> **Android Source**: `WeddingCommitteeEntity.kt`  
> **Room Table**: `wedding_committee`  
> **Relasi**: MANY → ONE ke `WeddingProfile` (CASCADE DELETE)

```dart
class WeddingCommitteeMember {
  final String memberId;         // UUID, PK
  final String weddingProfileId; // FK

  final String memberName;
  // Peran bebas: Saksi, Sambutan, Doa, Meja Kado, Among Tamu,
  //             Suhut, Dongan Tubu, MC, dll.
  final String role;

  // Pihak: KELUARGA_CPP, KELUARGA_CPW, TEMAN_CPP, TEMAN_CPW
  final String side;             // default: 'KELUARGA_CPP'
  final String? phoneNumber;

  // Seragam / kain
  final String? uniformDescription; // Warna/model seragam
  final double fabricMeters;         // Jatah kain dalam meter (default: 0.0)

  // Status seragam: BELUM_DIBAGI, SEDANG_JAHIT, SIAP_PAKAI
  final String uniformStatus;    // default: 'BELUM_DIBAGI'
  final int sortOrder;           // untuk drag-reorder
}
```

---

### 4.8 WeddingEvent + WeddingRundownItem

> **Android Source**: `WeddingRundownEntities.kt`  
> **Room Tables**: `wedding_events`, `wedding_rundown_items`

#### WeddingEvent (Tab Acara)
```dart
class WeddingEvent {
  final String eventId;          // UUID, PK
  final String weddingProfileId; // FK ke WeddingProfile

  final String eventName;        // Bebas: "Akad Nikah", "Resepsi", "Sangjit", dll.
  final int eventDate;           // Epoch millis
  final String? eventLocation;   // Alamat/nama tempat
  final int sortOrder;           // urutan tab
}
```

#### WeddingRundownItem (Baris Rundown)
```dart
class WeddingRundownItem {
  final String itemId;           // UUID, PK
  final String eventId;          // FK ke WeddingEvent (CASCADE DELETE)

  final String timeStart;        // "08:00" — format HH:mm (String)
  final int durationMinutes;     // durasi sesi (default: 15)
  final String sessionTitle;     // nama sesi kegiatan
  // PIC: CPP, CPW, MC, Keluarga, WO, dll. (free text)
  final String? pic;
  final String? mcScript;        // teks panduan MC (opsional)
  final int sortOrder;           // untuk drag-reorder dalam event
}
```

---

### 4.9 WeddingSeserahan

> **Android Source**: `WeddingSeserahanEntity.kt`  
> **Room Table**: `wedding_seserahan`  
> **Relasi**: MANY → ONE ke `WeddingProfile` (CASCADE DELETE)

```dart
class WeddingSeserahan {
  final String itemId;           // UUID, PK
  final String weddingProfileId; // FK

  // Arah: SESERAHAN_CPP (CPP→CPW), BALASAN_CPW (CPW→CPP), MAHAR
  final String direction;
  final String itemName;
  final int quantity;            // default: 1
  final double estimatedPrice;   // default: 0.0

  // Status: BELUM_BELI, DIBELI, WRAPPING, SIAP
  final String status;           // default: 'BELUM_BELI'
  final String? notes;
  final int sortOrder;
}
```

---

### 4.10 WeddingDocument

> **Android Source**: `WeddingDocumentEntity.kt`  
> **Room Table**: `wedding_documents`  
> **Relasi**: MANY → ONE ke `WeddingProfile` (CASCADE DELETE)

```dart
class WeddingDocument {
  final String docId;            // UUID, PK
  final String weddingProfileId; // FK

  final String docName;          // Nama dokumen
  // Pemilik: GROOM, BRIDE, TOGETHER
  final String ownerType;        // default: 'BOTH'
  final bool isCompleted;        // default: false
  final String? localFilePath;   // File path (untuk lampiran lokal, opsional di Flutter)
  final double adminCost;        // Biaya administrasi (default: 0.0)
  final int sortOrder;
}
```

**Template Dokumen Bawaan berdasarkan `religionType`**:
- `ISLAM` → KUA: Surat Keterangan Nikah RT/RW, N1–N4, KTP, KK, Foto, dll.
- `NON_ISLAM` → Catatan Sipil: Akte Kelahiran, Surat Baptis/Pernyataan, KTP, dll.

---

## 5. Diagram Relasi Database

```
WeddingProfile (id)
├── WeddingExpense (weddingProfileId → id)  [CASCADE DELETE]
│   └── WeddingPaymentTerm (expenseId → expenseId) [CASCADE DELETE]
├── WeddingGuest (weddingProfileId → id)    [CASCADE DELETE]
├── WeddingVendor (weddingProfileId → id)   [CASCADE DELETE]
├── WeddingTask (weddingProfileId → id)     [CASCADE DELETE]
├── WeddingCommitteeMember (weddingProfileId → id) [CASCADE DELETE]
├── WeddingEvent (weddingProfileId → id)    [CASCADE DELETE]
│   └── WeddingRundownItem (eventId → eventId) [CASCADE DELETE]
├── WeddingSeserahan (weddingProfileId → id) [CASCADE DELETE]
└── WeddingDocument (weddingProfileId → id) [CASCADE DELETE]
```

**Aturan penting**: Saat `WeddingProfile` dihapus, SEMUA data turunannya ikut terhapus (CASCADE). Drift/SQLite harus dikonfigurasi dengan `PRAGMA foreign_keys = ON`.

---

## 6. Alur Aplikasi (Navigation Flow)

### 6.1 Alur Onboarding / First Launch
```
App Launch
  └── Auth Check
        ├── [Belum login] → LoginScreen (Google Sign-In atau Lanjut Offline)
        └── [Sudah login / offline] → WeddingListScreen
              ├── [Tidak ada profil] → CreateProfileScreen (wajib isi: CPP, CPW, tanggal)
              └── [Ada profil] → WeddingDashboard (activeProfile)
```

### 6.2 Navigasi Utama (GoRouter)
```
/ → WeddingListScreen         (pilih atau buat WeddingProfile)
/wedding/:profileId → WeddingDashboard
/wedding/:profileId/budget → WeddingBudgetScreen
/wedding/:profileId/guests → WeddingGuestsScreen
/wedding/:profileId/vendors → WeddingVendorScreen
/wedding/:profileId/tasks → WeddingTasksScreen
/wedding/:profileId/committee → WeddingCommitteeScreen
/wedding/:profileId/rundown → WeddingRundownScreen
/wedding/:profileId/seserahan → WeddingSeserahanScreen
/wedding/:profileId/documents → WeddingDocumentsScreen
/wedding/:profileId/settings → WeddingSettingsScreen
```

---

## 7. Spesifikasi Per-Layar

### 7.1 Wedding Dashboard

**Sumber Android**: `ui/wedding/dashboard/WeddingDashboardScreen.kt` (856 baris)  
**Sumber ViewModel**: `WeddingDashboardViewModel.kt`

**Komponen UI yang harus direplikasi**:

#### A. Hero Card (Countdown)
- Background: LinearGradient dari `primaryContainer` → `secondaryContainer`
- Top bar dalam card:
  - Kiri: Tanggal hari ini (format: "3 Oktober 2026")
  - Kanan: **Profile Pill** — klik → navigasi ke Settings, long-press → Profile Switcher
- Tengah: Angka besar "**X Hari Lagi**" (DisplayLarge font)
- Bawah: Quote yang dapat dikustomisasi (font size & style dari WeddingProfile)
  - Default quote: "Perjalanan cinta yang luar biasa dimulai dari sini."

**Kalkulasi countdown**: `(weddingDate - today) / (1000*60*60*24)` — tampilkan "Hari Ini!" jika 0, "X Hari Berlalu" jika negatif.

#### B. Financial Summary Card (Bento)
- `totalPaid` / `totalBudgetCap` (dari WeddingProfile)
- LinearProgressIndicator (horizontal, rounded)
- CircularProgressIndicator kecil di kanan menampilkan persentase
- Nilai sisa anggaran: `totalBudgetCap - totalPaid`
- Click → navigasi ke Budget

#### C. Quick Action Bento Grid (2x2 layout)
```
[Catat Pengeluaran] [Kelola Tamu]
[Cek Vendor]        [Lihat Tugas]
```

#### D. Upcoming Tasks (max 5 item)
- List tugas terdekat yang belum selesai, sorted by `dueDate ASC`
- Click → navigasi ke Tasks

#### E. Budget Mini Summary (per kategori)
- LazyRow horizontal dari chip-chip kategori expense

#### F. Navigation Menu Grid (semua fitur)
- Grid 3-kolom berisi semua 9 fitur utama
- Setiap item: ikon + label + badge count (jika relevan)

**Data yang dibutuhkan ViewModel**:
- `weddingProfile`: WeddingProfile aktif
- `daysUntilWedding`: Int
- `totalPaid`: Double (SUM WeddingExpense.totalPaid)
- `totalBudgetCap`: Double (dari WeddingProfile)
- `upcomingTasks`: List WeddingTask (max 5, isCompleted=false, sorted dueDate)
- `completedTaskCount`: Int
- `totalTaskCount`: Int
- `guestTotalPax`: Int (SUM estimatedPax)

---

### 7.2 Wedding Budget (Anggaran)

**Sumber Android**: `ui/wedding/budget/WeddingBudgetScreen.kt` (1490 baris)  
**Fitur-fitur**:

1. **Budget Summary Card** di bagian atas:
   - Total estimasi vs total tersedia (= `totalBudgetCap`)
   - Total terbayar vs total estimasi
   - Sisa dana (selisih)
   - Filter sumber dana (chip row): Semua | TABUNGAN_CPP | TABUNGAN_CPW | ORTU_CPP | ORTU_CPW | BERSAMA

2. **Daftar Expense per Kategori** (expandable):
   - Group by `category`
   - Setiap kategori: accordion dengan header (nama kategori + total estimasi + total terbayar + chip status)
   - Di dalam accordion: list `WeddingExpense` items

3. **Expense Item Card**:
   - Judul, total estimasi, total terbayar, payment status chip
   - Klik → detail + payment terms
   - Long press → edit / hapus

4. **Add/Edit Expense Dialog** (bottom sheet atau dialog):
   - Field: Kategori (dropdown enum), Judul, Total Estimasi, Sumber Dana, Catatan
   - Setelah create: langsung tawarkan "Tambah Termin Pembayaran"

5. **Payment Terms Dialog** (untuk satu Expense):
   - List termin: DP 1, DP 2, Pelunasan, dll.
   - Setiap termin: nama, nominal, due date, tombol "Tandai Lunas"
   - Add termin baru
   - Saat termin ditandai lunas: `totalPaid` pada Expense diupdate otomatis

6. **Tombol tambah kategori custom** (misal: "DEKORASI AKAD" sebagai label)

**Enums Kategori Expense**: `VENUE`, `CATERING`, `DECOR`, `MUA`, `DOKUMENTASI`, `SESERAHAN`, `UNDANGAN`, `LAINNYA`

**Enums Sumber Dana**: `TABUNGAN_CPP`, `TABUNGAN_CPW`, `ORTU_CPP`, `ORTU_CPW`, `BERSAMA`

---

### 7.3 Wedding Guests (Tamu)

**Sumber Android**: `ui/wedding/guests/WeddingGuestsScreen.kt` (1653 baris)

**Tab 1: Daftar Tamu**:
1. Summary header: total undangan, total pax estimasi
2. Filter chip row per group (KELUARGA_CPP, KELUARGA_CPW, dll.) + badge count
3. List tamu digroup berdasarkan `groupAllocation`
4. Item tamu: nama, nomor HP, estimasi pax, sesi (AKAD/RESEPSI/KEDUANYA), status RSVP chip
5. Long press → edit / hapus
6. FAB → add tamu manual

**Tab 2: Kalkulator Katering**:
- Input: jumlah pax per sesi (AKAD, RESEPSI)
- Hitung total porsi dengan buffer 10–15%
- Output: rekomendasi porsi katering

**Fitur Import Kontak** (khusus mobile):
- Tombol di AppBar → minta permission `READ_CONTACTS`
- Multi-select kontak dari daftar kontak HP
- Batch import: buat WeddingGuest dari setiap kontak yang dipilih
- Di Flutter: gunakan `flutter_contacts` package + permission_handler

**Add Tamu Dialog**:
- Field: Nama, No. HP, Group (dropdown), Sesi (dropdown), Estimasi Pax

**Group Custom**: User bisa rename group atau tambah grup baru (stored as String)

---

### 7.4 Wedding Vendors

**Sumber Android**: `ui/wedding/vendor/WeddingVendorScreen.kt`

1. Filter chip row per kategori vendor
2. List vendor digroup per kategori
3. Item vendor: nama, kategori, status chip (PROSPEK/TANDA_JADI/KONTRAK/SELESAI), nilai kontrak, IG handle
4. Detail vendor: tampilkan semua info + notes + tombol telpon/WA (buka dial/WhatsApp)
5. Status pipeline ditampilkan sebagai progress step (4 step)

**Add/Edit Vendor Dialog**:
- Field: Kategori (dropdown), Nama, PIC, No. HP, Instagram, Nilai Kontrak, Status, Catatan

**Enums Status Vendor**: `PROSPEK`, `TANDA_JADI`, `KONTRAK`, `SELESAI`

---

### 7.5 Timeline & Tugas

**Sumber Android**: `ui/wedding/tasks/WeddingTasksScreen.kt` (812 baris)

**Header**: "X/Y selesai · Z%"  
**Filter Tab/Chip per Phase**:
- 12 Bulan Sebelumnya
- 6 Bulan Sebelumnya
- 3 Bulan Sebelumnya
- 1 Bulan Sebelumnya
- Hari-H (phaseMonth = 0)

**Item Tugas**:
- Checkbox (tap → toggle isCompleted)
- Judul (strikethrough jika selesai)
- PIC badge (GROOM/BRIDE/BOTH/FAMILY/WO)
- Due date (jika ada)
- Swipe-to-delete atau long press delete

**Add/Edit Task Dialog**:
- Field: Phase (dropdown), Judul, Deskripsi, PIC, Due Date (date picker)

**Template Tasks Otomatis** (seed saat buat WeddingProfile baru):

*12 Bulan Sebelum*:
- Tentukan tanggal dan venue (PIC: BOTH)
- Tentukan konsep/tema pernikahan (PIC: BOTH)
- Buat anggaran awal (PIC: BOTH)
- Daftarkan ke KUA/Catatan Sipil (PIC: BOTH)
- Cari dan booking WO (PIC: BOTH)

*6 Bulan Sebelum*:
- Booking catering (PIC: BOTH)
- Booking fotografer & videografer (PIC: BOTH)
- Booking dekorasi (PIC: BOTH)
- Booking MUA (PIC: BRIDE)
- Desain undangan (PIC: BOTH)
- Siapkan daftar tamu (PIC: BOTH)

*3 Bulan Sebelum*:
- Cetak undangan (PIC: BOTH)
- Siapkan seserahan (PIC: GROOM)
- Fitting baju pengantin (PIC: BOTH)
- Konfirmasi semua vendor (PIC: BOTH)
- Sebarkan undangan (PIC: BOTH)

*1 Bulan Sebelum*:
- Final cek dekorasi & catering (PIC: BOTH)
- Gladi bersih rundown (PIC: BOTH)
- Bagikan seragam panitia (PIC: FAMILY)
- Siapkan uang amplop (PIC: BOTH)

*Hari-H (0)*:
- Briefing panitia (PIC: FAMILY)
- MC mulai acara (PIC: WO)

---

### 7.6 Panitia & Seragam

**Sumber Android**: `ui/wedding/committee/WeddingCommitteeScreen.kt`

1. Filter by side (KELUARGA_CPP, KELUARGA_CPW, TEMAN_CPP, TEMAN_CPW)
2. List panitia, grouped by side
3. Item: nama, peran, HP, status seragam chip
4. Filter/summary seragam: berapa yang sudah SIAP_PAKAI
5. Total kain yang dibutuhkan (SUM fabricMeters)

**Add/Edit Panitia Dialog**:
- Field: Nama, Peran (free text), Pihak (dropdown), No. HP, Deskripsi Seragam, Jatah Kain (meter), Status Seragam

**Enums Status Seragam**: `BELUM_DIBAGI`, `SEDANG_JAHIT`, `SIAP_PAKAI`

---

### 7.7 Rundown Acara

**Sumber Android**: `ui/wedding/rundown/WeddingRundownScreen.kt`

**Struktur 2-Level**:
1. **Level 1 — Event Tabs**: Tab bar berisi event-event pernikahan (cth: "Akad Nikah", "Resepsi")
   - User bisa add/edit/reorder event
   - Setiap event punya `eventDate` dan `eventLocation`

2. **Level 2 — Rundown Items** (per event):
   - Timeline view menit-ke-menit
   - Setiap item: `timeStart` (HH:mm), `durationMinutes`, `sessionTitle`, `pic`, `mcScript`
   - Drag-to-reorder items

**Add Event Dialog**: nama event (bebas), tanggal, lokasi

**Add Rundown Item Dialog**: Waktu mulai (time picker), Durasi (minutes), Nama Sesi, PIC, Teks MC (opsional, text area panjang)

**Fitur Teks MC**: `mcScript` — panduan teks untuk MC. Ditampilkan sebagai expandable section dalam item rundown.

---

### 7.8 Seserahan & Mahar

**Sumber Android**: `ui/wedding/seserahan/WeddingSeserahanScreen.kt`

**3 Tab / Section**:
1. **Seserahan CPP** (`direction = 'SESERAHAN_CPP'`): Barang dari pihak pria ke wanita
2. **Balasan CPW** (`direction = 'BALASAN_CPW'`): Barang dari pihak wanita ke pria
3. **Mahar** (`direction = 'MAHAR'`): Mahar pernikahan

**Item per section**:
- Nama barang, jumlah, harga estimasi, status chip
- Total estimasi per section
- Progress: berapa item sudah SIAP

**Add/Edit Item Dialog**: Nama, Jumlah, Harga Estimasi, Status, Catatan

**Enums Status Seserahan**: `BELUM_BELI`, `DIBELI`, `WRAPPING`, `SIAP`

---

### 7.9 Dokumen Administrasi

**Sumber Android**: `ui/wedding/documents/WeddingDocumentsScreen.kt`

1. **Checklist Dokumen** pre-seeded berdasarkan `religionType`:

   *Islam (KUA)*:
   - Surat Keterangan Belum Menikah (CPP)
   - Surat Keterangan Belum Menikah (CPW)
   - Surat Nikah N1 (CPP)
   - Surat Nikah N2 (CPP)
   - Surat Nikah N3 (Wali CPW)
   - Surat Nikah N4 (CPW)
   - KTP (CPP & CPW)
   - Kartu Keluarga (CPP & CPW)
   - Foto 2x3 & 3x4 (CPP & CPW)
   - Akte Kelahiran (CPP & CPW)
   - Surat Kesehatan/Imunisasi
   - Bimbingan Pra-Nikah (sertifikat)

   *Non-Islam (Catatan Sipil)*:
   - Akte Kelahiran (CPP & CPW)
   - Surat Baptis / Surat Pernyataan Agama
   - KTP (CPP & CPW)
   - Kartu Keluarga
   - Surat Keterangan Belum Menikah
   - Pas Foto 3x4
   - Surat Pengantar RT/RW

2. Filter by ownerType (GROOM, BRIDE, TOGETHER)
3. Progress bar: berapa dokumen sudah dilengkapi
4. Setiap item: nama, owner badge, status checkbox, biaya admin (jika ada)
5. User bisa tambah dokumen custom

---

### 7.10 Pengaturan Wedding

**Sumber Android**: `ui/wedding/settings/WeddingSettingsScreen.kt` (810 baris)

**Bagian-bagian**:

1. **Profil & Cloud Sync Card**:
   - Avatar ikon
   - Status: "Akses Pasangan Cloud" (jika login) atau "Mode Wedding Lokal"
   - Email pengguna (jika login)
   - Badge: "Synced" / "Lokal"

2. **Edit Profil Wedding** (inline form atau dialog):
   - Nama CPP, Nama CPW
   - Tanggal Pernikahan (date picker)
   - Total Budget (number input)
   - Jenis Agama (radio: ISLAM / NON_ISLAM)
   - Detail Agama (dropdown kondisional)
   - Adat CPP & CPW (dropdown)

3. **Kustomisasi Quote**:
   - Toggle: tampilkan/sembunyikan quote
   - Text field: isi quote
   - Pilih ukuran font (KECIL/SEDANG/BESAR)
   - Pilih style font (NORMAL/BOLD/ITALIC/BOLD_ITALIC)
   - Preview langsung

4. **Export Data**:
   - Export PDF wedding summary
   - Export CSV detail

5. **Danger Zone**:
   - Reset semua data wedding (hapus WeddingProfile = CASCADE semua)
   - Logout (jika online mode)

---

## 8. Sinkronisasi Firestore

### 8.1 Arsitektur Sync

Gunakan **Firestore REST API** (HTTP/REST, bukan gRPC SDK) — mengikuti pola yang sudah ada di Android untuk bypass network block.

Implementasikan `FirestoreService` atau `SyncManager` dengan pola:
- **Pull** (read dari Firestore → simpan ke Drift) saat login / app start
- **Push** (write ke Firestore) saat user CRUD data

### 8.2 Struktur Koleksi Firestore

```
Firestore Root
└── users/
    └── {userId}/                     ← Auth UID dari Firebase Auth
        ├── wedding_profiles/
        │   └── {weddingProfile.id}   ← Document ID = UUID
        ├── wedding_expenses/
        │   └── {expense.expenseId}
        ├── wedding_payment_terms/
        │   └── {term.termId}
        ├── wedding_guests/
        │   └── {guest.guestId}
        ├── wedding_vendors/
        │   └── {vendor.vendorId}
        ├── wedding_tasks/
        │   └── {task.taskId}
        ├── wedding_committee/
        │   └── {member.memberId}
        ├── wedding_events/
        │   └── {event.eventId}
        ├── wedding_rundown_items/
        │   └── {item.itemId}
        ├── wedding_seserahan/
        │   └── {seserahan.itemId}
        └── wedding_documents/
            └── {doc.docId}
```

### 8.3 Pola Push (Lokal → Firestore)

Setiap kali `insert`, `update`, atau `delete` dipanggil di repository:
```dart
// Pseudocode Flutter
Future<void> insertExpense(WeddingExpense expense) async {
  await localDao.insert(expense);           // 1. Simpan lokal dulu
  if (await isOnlineMode()) {
    await firestoreService.put(            // 2. Push ke Firestore
      'users/$userId/wedding_expenses/${expense.expenseId}',
      expense.toFirestoreMap()
    );
  }
}
```

### 8.4 Pola Pull (Firestore → Lokal)

Saat login atau `startSync()` dipanggil:
1. **Phase 1 (Parent dulu, parallel)**:
   - Pull `wedding_profiles` (PENTING: preserve `profileId` lokal jika sudah ada)
2. **Phase 2 (Children, semua parallel)**:
   - Pull semua collection lain (expenses, tasks, vendors, guests, committee, payment_terms, seserahan, documents, events, rundown_items)
   - Jika FK violation (parent belum ada) → skip/log warning

### 8.5 Serialisasi Firestore (Field Mapping)

Gunakan `camelCase` untuk field names di Firestore (sesuai konvensi existing di Android):

```dart
// WeddingProfile → Firestore Map
Map<String, dynamic> toFirestoreMap() => {
  'id': id,
  'groomName': groomName,
  'brideName': brideName,
  'weddingDate': weddingDate,
  'totalBudgetCap': totalBudgetCap,
  'religionType': religionType,
  'religionDetail': religionDetail,
  'culturalPresetGroom': culturalPresetGroom,
  'culturalPresetBride': culturalPresetBride,
  'quote': quote,
  'quoteEnabled': quoteEnabled,
  'quoteFontSize': quoteFontSize,
  'quoteFontStyle': quoteFontStyle,
  'createdAt': createdAt,
};
```

---

## 9. Fitur Utama yang WAJIB Diimplementasi

| No | Fitur | Screen | Prioritas |
|----|-------|--------|-----------|
| 1 | Dashboard dengan countdown hitung mundur hari pernikahan | Dashboard | P0 |
| 2 | Buat/edit/hapus WeddingProfile | Settings | P0 |
| 3 | Manajemen anggaran dengan kategori & status pembayaran | Budget | P0 |
| 4 | Payment terms (DP 1, DP 2, Pelunasan) per expense | Budget | P0 |
| 5 | Daftar tamu dengan estimasi pax & RSVP status | Guests | P0 |
| 6 | Import tamu dari kontak HP (batch multi-select) | Guests | P1 |
| 7 | Kalkulator katering (estimasi porsi) | Guests | P1 |
| 8 | Daftar vendor + status pipeline | Vendors | P0 |
| 9 | Timeline to-do list terorganisir per phase | Tasks | P0 |
| 10 | Seed template tasks berdasarkan adat & agama | Tasks | P1 |
| 11 | Panitia + manajemen seragam | Committee | P0 |
| 12 | Rundown multi-event dengan teks MC | Rundown | P0 |
| 13 | Seserahan 3-arah (CPP ke CPW, CPW ke CPP, Mahar) | Seserahan | P0 |
| 14 | Checklist dokumen pre-seeded (KUA/Catatan Sipil) | Documents | P0 |
| 15 | Sinkronisasi Firestore (cloud sync) | Settings | P1 |
| 16 | Mode offline-first (semua data tersimpan lokal) | Global | P0 |
| 17 | Kustomisasi quote di Dashboard | Settings | P2 |
| 18 | Export PDF/CSV summary | Settings | P2 |
| 19 | Panduan fitur per screen (guide dialog) | Global | P2 |
| 20 | Multi-profile wedding (lebih dari 1 profil nikah) | Dashboard | P2 |

---

## 10. Shared/Reusable Widgets yang Perlu Dibuat

### 10.1 DeleteConfirmDialog
```dart
showDeleteConfirmDialog({
  required BuildContext context,
  required String itemName,
  required VoidCallback onConfirm,
})
```

### 10.2 WeddingScreenGuideDialog
```dart
class WeddingGuideFeature {
  final String title;
  final String description;
  final IconData icon;
}

showWeddingGuideDialog({
  required BuildContext context,
  required String title,
  required String screenPurpose,
  required List<WeddingGuideFeature> features,
  String? proTip,
})
```

### 10.3 StatusChip
- Chip warna berdasarkan status string
- UNPAID/BELUM_BELI/PROSPEK = abu/merah
- PARTIAL_DP/SEDANG_JAHIT/TANDA_JADI = oranye/kuning
- FULLY_PAID/SIAP/SELESAI = hijau

### 10.4 CurrencyTextField
- TextField khusus Rupiah, format otomatis `Rp 1.500.000`
- Menggunakan `TextInputFormatter`

### 10.5 DateSelectorButton
- ElevatedButton yang menampilkan tanggal terpilih
- Tap → buka `showDatePicker()`

---

## 11. Utilities yang Dibutuhkan

### 11.1 CurrencyUtils
```dart
String formatRupiah(double amount);    // → "Rp 1.500.000"
double parseRupiah(String text);       // → 1500000.0
```

### 11.2 WeddingDateUtils
```dart
String formatFull(int epochMillis);     // → "Sabtu, 3 Oktober 2026"
String formatMonthYear(int epochMillis); // → "Oktober 2026"
TimeOfDay parseTime(String hhmm);       // → TimeOfDay(hour: 8, minute: 0)
int todayMillis();                      // → epoch millis tengah malam hari ini
int daysUntil(int epochMillis);         // → hari tersisa (negatif jika sudah lewat)
```

### 11.3 UuidUtils
```dart
import 'package:uuid/uuid.dart';
final _uuid = Uuid();
String generateId() => _uuid.v4();
```

---

## 12. Design System & UI Guidelines

### Warna
- Material 3 dynamic color, seed: **Rose Pink** (#E91E8C atau serupa)
- Support light mode (wajib), dark mode (opsional)

### Typography
- Font: **Poppins** atau **Plus Jakarta Sans** via Google Fonts package
- Gunakan `Theme.of(context).textTheme` secara konsisten

### Komponen Khas
- Card sudut bulat: `BorderRadius.circular(24)` (hero), `16` (biasa)
- Gradient hero card: `primaryContainer` → `secondaryContainer`
- FAB: extended dengan ikon + label, `BorderRadius.circular(16)`
- Bottom sheet untuk form add/edit (bukan full-screen untuk item sederhana)
- Chip berwarna sesuai status

### Animasi
- `AnimatedSwitcher` untuk transisi konten
- Progress indicator animasi smooth
- Hero transition antar layar (opsional)

---

## 13. Panduan Implementasi untuk AI Agent

**Urutan implementasi yang disarankan**:

```
Step 1: Setup Project
  flutter create wedding_kit --org com.weddingkit
  Tambah dependencies: drift, riverpod, go_router, firebase_core,
  firebase_auth, cloud_firestore, google_sign_in, uuid, intl,
  flutter_contacts, permission_handler, google_fonts

Step 2: Database Drift
  Definisikan 11 tabel sesuai Section 4
  Aktifkan FK dengan: @DriftDatabase(tables: [...], daos: [...])
  Override onCreate → "PRAGMA foreign_keys = ON"
  Buat semua DAO

Step 3: Domain Models + Repositories
  Dart model classes (immutable dengan copyWith)
  Repository per entity dengan local + remote

Step 4: Auth
  LoginScreen: Google Sign-In + tombol "Lanjut Tanpa Akun"
  AuthNotifier (Riverpod)

Step 5: Feature per screen (urutan: Dashboard → Budget → Guests →
  Vendors → Tasks → Committee → Rundown → Seserahan → Documents → Settings)
  Setiap feature: StateNotifier/AsyncNotifier, Screen widget, dialog-dialog

Step 6: Shared Components
  DeleteConfirmDialog, GuideDialog, StatusChip, CurrencyTextField, dll.

Step 7: Firestore Sync
  SyncManager: startSync() → pull phase 1 + phase 2
  Push pada setiap insert/update/delete di repository

Step 8: Polish
  Empty states, loading states, error handling
  Guide dialog di setiap screen (tombol Info di AppBar)
```

---

## 14. Catatan Domain Penting

1. **WeddingExpense ≠ Transaksi Keuangan**: Expense wedding adalah *tagihan ke vendor*, bukan arus kas harian. Keduanya sengaja terpisah.

2. **Religion-based customization**: Dokumen, template tasks, dan terminology berbeda tergantung `religionType` dan `culturalPreset`.

3. **Indonesia-first**: Semua label dalam Bahasa Indonesia. Format tanggal `id_ID`. Mata uang Rupiah.

4. **Offline-first**: 100% bisa jalan tanpa internet. Sync Firestore adalah bonus.

5. **Multi-profile**: Satu user bisa punya beberapa WeddingProfile.

6. **Terminologi domain**:
   - CPP = Calon Pengantin Pria (Groom)
   - CPW = Calon Pengantin Wanita (Bride)
   - WO = Wedding Organizer
   - Hari-H = Hari Pernikahan (D-Day)
   - Seserahan = Hantaran/hadiah adat dari CPP ke CPW
   - KUA = Kantor Urusan Agama (pencatatan nikah Islam)
   - Rundown = Jadwal acara menit per menit

---

## 15. Checklist Validasi untuk AI Agent

Sebelum dianggap selesai, pastikan:
- [ ] Semua 11 entity terimplementasi di Drift (1 WeddingProfile + 10 turunan)
- [ ] Cascade DELETE bekerja: hapus profil → semua child ikut terhapus
- [ ] Semua 10 screen terimplementasi dengan CRUD lengkap
- [ ] Dashboard: countdown akurat, hero card dengan gradient, quote kustomisasi
- [ ] Budget: payment terms → `totalPaid` Expense terupdate otomatis
- [ ] Guests: import kontak multi-select berfungsi
- [ ] Tasks: template tasks muncul saat buat profil baru
- [ ] Documents: checklist berbeda untuk ISLAM vs NON_ISLAM
- [ ] Semua screen punya guide dialog (tombol Info di AppBar)
- [ ] Delete selalu pakai konfirmasi dialog
- [ ] Sync Firestore: push saat write, pull saat login
- [ ] App bisa jalan offline (tanpa login, tanpa sync)
- [ ] Format Rupiah: "Rp 1.500.000"
- [ ] Format tanggal: "Sabtu, 3 Oktober 2026" (locale id_ID)
