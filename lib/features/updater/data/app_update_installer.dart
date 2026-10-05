import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/config/updater_config.dart';

/// Service untuk memicu instalasi file APK atau mengarahkan ke link rilis
class AppUpdateInstaller {
  /// Membuka file APK untuk diinstal oleh package installer sistem Android
  static Future<bool> installApk(String filePath) async {
    try {
      if (!Platform.isAndroid) {
        // Jika di iOS atau platform lain, buka halaman rilis di browser
        return await openReleasesWeb();
      }

      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('[AppUpdateInstaller] File APK tidak ditemukan di: $filePath');
        return false;
      }

      final result = await OpenFilex.open(
        filePath,
        type: 'application/vnd.android.package-archive',
      );

      debugPrint(
        '[AppUpdateInstaller] Hasil buka installer APK: ${result.type} - ${result.message}',
      );
      return result.type == ResultType.done;
    } catch (e) {
      debugPrint('[AppUpdateInstaller] Gagal membuka installer: $e');
      return false;
    }
  }

  /// Membuka halaman rilis resmi di browser web
  static Future<bool> openReleasesWeb([String? url]) async {
    try {
      final uri = Uri.parse(url ?? UpdaterConfig.releasesWebUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('[AppUpdateInstaller] Gagal membuka browser rilis: $e');
      return false;
    }
  }
}
