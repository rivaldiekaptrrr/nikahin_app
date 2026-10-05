import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/config/updater_config.dart';
import '../domain/models/app_release_info.dart';

/// Service untuk mengecek versi terbaru aplikasi dari GitHub Releases
class AppUpdateChecker {
  final http.Client _client;

  AppUpdateChecker({http.Client? client}) : _client = client ?? http.Client();

  /// Mendapatkan versi lokal aplikasi saat ini (misal: "1.0.0")
  Future<String> getCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (e) {
      debugPrint('[AppUpdateChecker] Gagal membaca PackageInfo: $e');
      return '1.0.0';
    }
  }

  /// Mengecek apakah ada pembaruan rilis di GitHub.
  /// Mengembalikan [AppReleaseInfo] jika versi di GitHub lebih baru dari lokal,
  /// atau `null` jika aplikasi sudah dalam versi terbaru / gagal terhubung.
  Future<AppReleaseInfo?> checkForUpdate() async {
    try {
      final currentVersion = await getCurrentVersion();
      final uri = Uri.parse(UpdaterConfig.releasesApiUrl);

      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'NikahinApp-Flutter',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        debugPrint(
          '[AppUpdateChecker] GitHub API responded with status ${response.statusCode}',
        );
        return null;
      }

      final dynamic data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        return null;
      }

      final releaseInfo = AppReleaseInfo.fromJson(data);

      if (isNewerVersion(currentVersion, releaseInfo.versionName)) {
        return releaseInfo;
      }

      return null;
    } catch (e) {
      debugPrint('[AppUpdateChecker] Error saat cek pembaruan: $e');
      return null;
    }
  }

  /// Membandingkan 2 string versi semantik (Semantic Versioning: Mayor.Minor.Patch)
  /// Mengembalikan `true` jika [remoteVersion] lebih baru daripada [currentVersion].
  static bool isNewerVersion(String currentVersion, String remoteVersion) {
    try {
      final currentParts = _parseVersion(currentVersion);
      final remoteParts = _parseVersion(remoteVersion);

      for (int i = 0; i < 3; i++) {
        if (remoteParts[i] > currentParts[i]) return true;
        if (remoteParts[i] < currentParts[i]) return false;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// Mem-parsing string versi menjadi integer list [Mayor, Minor, Patch]
  static List<int> _parseVersion(String version) {
    // Bersihkan prefix 'v' atau suffix build '+1' jika ada
    var clean = version.trim();
    if (clean.startsWith('v') || clean.startsWith('V')) {
      clean = clean.substring(1);
    }
    if (clean.contains('+')) {
      clean = clean.split('+').first;
    }
    if (clean.contains('-')) {
      clean = clean.split('-').first;
    }

    final parts = clean.split('.');
    final major = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minor = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final patch = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;

    return [major, minor, patch];
  }
}
