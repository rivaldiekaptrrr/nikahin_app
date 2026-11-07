# Panduan Integrasi & Penggunaan Firebase Crashlytics (Nikahin App)

Dokumentasi teknis untuk pengembang mengenai konfigurasi, arsitektur, dan cara pemanfaatan **Firebase Crashlytics** guna memantau stabilitas dan mencatat galat (*crash reporting*) aplikasi Nikahin di lingkungan produksi.

---

## 1. Ikhtisar Arsitektur

Firebase Crashlytics bertindak sebagai sistem pemantauan performa dan galat *real-time*. Di aplikasi Nikahin, Crashlytics dikonfigurasi dengan pendekatan **Multiplatform-Safe**:

| Platform | Dukungan Crashlytics | Mekanisme Penanganan |
|---|---|---|
| **Android** | Aktif Penuh (SDK & Gradle Plugin) | Menangkap crash fatal Java/Kotlin/Dart dan mengunggah *mapping file* R8 |
| **iOS** | Aktif Penuh (SDK Native & Dart) | Menangkap crash fatal Objective-C/Swift/Dart dan simbol dSYM |
| **Web PWA** | Tidak Didukung Native oleh Firebase | Otomatis dilewati dengan aman melalui pengaman `if (!kIsWeb)` |

---

## 2. Inisialisasi Global di Kode Sumber

Inisialisasi Crashlytics dijalankan pada fungsi `main()` di [`lib/main.dart`](file:///c:/Project/nikahin_app/lib/main.dart):

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase & Crashlytics untuk pemantauan crash lapangan (Mobile)
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      
      // 1. Teruskan seluruh galat fatal framework Flutter ke Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      
      // 2. Tangkap galat asinkron tak tertangani di luar framework
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e) {
      debugPrint('[Crashlytics] Inisialisasi dilewati atau tidak aktif: $e');
    }
  }

  // Inisialisasi layanan aplikasi lainnya...
  runApp(const ProviderScope(child: NikahinApp()));
}
```

---

## 3. Panduan Penggunaan untuk Pengembang

Selain menangkap crash yang mematikan aplikasi secara otomatis (*fatal crashes*), pengembang dapat memanfaatkan Crashlytics untuk melacak galat terkontrol (*non-fatal exceptions*), rekam jejak pengguna (*breadcrumbs*), dan identitas sesi.

### A. Mencatat Galat Non-Fatal (Try-Catch)
Gunakan saat menangani kegagalan jaringan, parsing data, atau operasi database penting:

```dart
try {
  await databaseOperation();
} catch (error, stackTrace) {
  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Gagal memproses sinkronisasi lokal SQLite',
      fatal: false, // Tidak mematikan aplikasi
    );
  }
}
```

### B. Menambahkan Rekam Jejak (Breadcrumbs / Log)
Menambahkan konteks alur sebelum terjadi error agar mudah direproduksi di dashboard:

```dart
if (!kIsWeb) {
  FirebaseCrashlytics.instance.log('Pengguna membuka layar checkout Bank BRI');
}
```

### C. Mengaitkan Identitas Pengguna (User Identifier)
Membantu mencari laporan crash spesifik berdasarkan UID pengguna Firestore saat melayani keluhan pelanggan:

```dart
// Panggil setelah pengguna berhasil masuk (Login)
if (!kIsWeb) {
  FirebaseCrashlytics.instance.setUserIdentifier(currentUser.uid);
}

// Panggil saat pengguna keluar (Logout)
if (!kIsWeb) {
  FirebaseCrashlytics.instance.setUserIdentifier('');
}
```

### D. Menambahkan Atribut Kustom (Custom Keys)
Menyertakan metadata lingkungan untuk diagnosis mendalam:

```dart
if (!kIsWeb) {
  FirebaseCrashlytics.instance.setCustomKey('user_role', 'admin');
  FirebaseCrashlytics.instance.setCustomKey('active_wedding_set', true);
  FirebaseCrashlytics.instance.setCustomKey('network_status', 'cellular');
}
```

---

## 4. Konfigurasi Android & Proteksi Biner (R8)

Agar laporan crash di Firebase Console menampilkan nomor baris dan berkas sumber yang akurat (bukan nama fungsi yang tersamarkan seperti `a.b.c`), konfigurasi berikut telah diterapkan:

### A. Gradle Plugin
- `android/settings.gradle.kts`:
  ```kotlin
  id("com.google.firebase.crashlytics") version "3.0.3" apply false
  ```
- `android/app/build.gradle.kts`:
  ```kotlin
  plugins {
      id("com.android.application")
      id("dev.flutter.flutter-gradle-plugin")
      id("com.google.gms.google-services")
      id("com.google.firebase.crashlytics")
  }
  ```

### B. ProGuard Rules (`android/app/proguard-rules.pro`)
Aturan khusus untuk mempertahankan penomoran baris dan kelas exception:
```proguard
# Preservasi nomor baris dan berkas sumber untuk Crashlytics
-keepattributes SourceFile,LineNumberTable

# Preservasi kelas Exception
-keep public class * extends java.lang.Exception
```

---

## 5. Cara Menguji Crashlytics di Perangkat (Developer Verification)

Untuk memverifikasi bahwa Crashlytics sudah terhubung dengan benar ke Firebase Console:

1. Buat tombol sementara atau pemicu uji di menu pengaturan:
   ```dart
   ElevatedButton(
     onPressed: () {
       // Sengaja memicu crash untuk pengujian
       FirebaseCrashlytics.instance.crash();
     },
     child: const Text('Uji Crashlytics'),
   )
   ```
2. Jalankan aplikasi pada perangkat Android/iOS nyata.
3. Tekan tombol tersebut hingga aplikasi tertutup (*force close*).
4. **Buka kembali aplikasi** (Crashlytics mengunggah laporan crash pada saat pembukaan sesi berikutnya).
5. Buka **Firebase Console -> Kategori Build / Pemantauan -> Crashlytics**. Laporan crash uji coba akan muncul dalam waktu 2–5 menit.

> [!CAUTION]
> Jangan biarkan pemanggilan `FirebaseCrashlytics.instance.crash()` tetap aktif pada kode produksi. Hapus tombol uji coba sebelum membuat build rilis.

---

## 6. Lokasi Berkas Terkait

- Inisialisasi Root: [`lib/main.dart`](file:///c:/Project/nikahin_app/lib/main.dart)
- Konfigurasi Dependensi: [`pubspec.yaml`](file:///c:/Project/nikahin_app/pubspec.yaml)
- Pengaturan ProGuard Android: [`android/app/proguard-rules.pro`](file:///c:/Project/nikahin_app/android/app/proguard-rules.pro)
- Konfigurasi Gradle: [`android/app/build.gradle.kts`](file:///c:/Project/nikahin_app/android/app/build.gradle.kts)
