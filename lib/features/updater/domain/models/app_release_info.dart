import 'dart:io';

/// Model data representasi rilis dari GitHub Releases API
class AppReleaseInfo {
  final String tagName;
  final String versionName;
  final String releaseName;
  final String releaseNotes;
  final String? apkDownloadUrl;
  final String? apkFileName;
  final int apkFileSize;
  final DateTime? publishedAt;

  const AppReleaseInfo({
    required this.tagName,
    required this.versionName,
    required this.releaseName,
    required this.releaseNotes,
    this.apkDownloadUrl,
    this.apkFileName,
    this.apkFileSize = 0,
    this.publishedAt,
  });

  /// Factory untuk parsing respons JSON dari GitHub Releases API
  factory AppReleaseInfo.fromJson(Map<String, dynamic> json) {
    final tagName = (json['tag_name'] as String?) ?? '';
    // Format tag biasanya "v1.0.1" -> buang "v" di depan untuk versionName
    final versionName =
        tagName.startsWith('v') || tagName.startsWith('V')
            ? tagName.substring(1).trim()
            : tagName.trim();

    final releaseName = (json['name'] as String?) ?? tagName;
    final releaseNotes = (json['body'] as String?) ?? '';

    String? apkUrl;
    String? apkName;
    int apkSize = 0;

    final assets = json['assets'] as List<dynamic>?;
    if (assets != null && assets.isNotEmpty) {
      final apkAssets = assets.where((a) {
        if (a is! Map<String, dynamic>) return false;
        final name = (a['name'] as String? ?? '').toLowerCase();
        return name.endsWith('.apk');
      }).cast<Map<String, dynamic>>().toList();

      if (apkAssets.isNotEmpty) {
        Map<String, dynamic>? selectedAsset;

        final isArm64 = Platform.version.toLowerCase().contains('arm64') ||
            Platform.version.toLowerCase().contains('aarch64');

        if (isArm64) {
          // Cari aset yang dioptimasi khusus arm64 jika perangkat mendukung 64-bit
          for (final a in apkAssets) {
            final name = (a['name'] as String? ?? '').toLowerCase();
            if (name.contains('arm64')) {
              selectedAsset = a;
              break;
            }
          }
        }

        // Jika bukan arm64 atau tidak ada aset khusus arm64, cari universal APK (tanpa label abi khusus)
        if (selectedAsset == null) {
          for (final a in apkAssets) {
            final name = (a['name'] as String? ?? '').toLowerCase();
            if (!name.contains('x86') && !name.contains('armeabi')) {
              selectedAsset = a;
              break;
            }
          }
        }

        // Fallback: gunakan aset APK pertama yang ada
        selectedAsset ??= apkAssets.first;

        apkUrl = selectedAsset['browser_download_url'] as String?;
        apkName = selectedAsset['name'] as String?;
        apkSize = (selectedAsset['size'] as int?) ?? 0;
      }
    }

    DateTime? publishedDate;
    if (json['published_at'] != null) {
      publishedDate = DateTime.tryParse(json['published_at'] as String);
    }

    return AppReleaseInfo(
      tagName: tagName,
      versionName: versionName,
      releaseName: releaseName,
      releaseNotes: releaseNotes,
      apkDownloadUrl: apkUrl,
      apkFileName: apkName,
      apkFileSize: apkSize,
      publishedAt: publishedDate,
    );
  }

  /// Memeriksa apakah berkas APK tersedia di rilis ini
  bool get hasApk => apkDownloadUrl != null && apkDownloadUrl!.isNotEmpty;
}
