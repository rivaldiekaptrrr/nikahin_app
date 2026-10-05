import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// Pusat Konfigurasi & Sakelar Platform Aplikasi Nikahin
class AppPlatformConfig {
  AppPlatformConfig._();

  // ===========================================================================
  // 🔘 SAKELAR PLATFORM (Ubah true/false di sini)
  // ===========================================================================
  
  /// Aktifkan dukungan & validasi fitur Android
  static const bool enableAndroidSupport = true;

  /// Aktifkan dukungan & validasi fitur iOS
  static const bool enableIosSupport = false;

  /// Aktifkan dukungan & mode Web browser
  static const bool enableWebSupport = false;

  /// Aktifkan dukungan & mode Desktop Windows
  static const bool enableWindowsSupport = false;

  // ===========================================================================
  // 🛡️ PLATFORM GUARDS & CAPABILITY CHECKS
  // ===========================================================================

  /// Memeriksa apakah perangkat saat ini adalah Web
  static bool get isWeb => kIsWeb;

  /// Memeriksa apakah perangkat saat ini adalah Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Memeriksa apakah perangkat saat ini adalah iOS
  static bool get isIos => !kIsWeb && Platform.isIOS;

  /// Memeriksa apakah perangkat saat ini adalah Windows Desktop
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Kunci biometrik (Fingerprint/FaceID) hanya aktif jika bukan Web/Desktop
  static bool get isBiometricsAvailable => !kIsWeb && (isAndroid || isIos);

  /// Import kontak HP dari phonebook hanya aktif jika di Mobile (Android/iOS)
  static bool get isContactsImportAvailable => !kIsWeb && (isAndroid || isIos);

  /// In-App APK Updater hanya aktif di platform Android
  static bool get isApkUpdaterAvailable => isAndroid;
}
