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
      // Cari aset berformat .apk
      for (final asset in assets) {
        final name = (asset['name'] as String?) ?? '';
        if (name.toLowerCase().endsWith('.apk')) {
          apkUrl = asset['browser_download_url'] as String?;
          apkName = name;
          apkSize = (asset['size'] as int?) ?? 0;
          break;
        }
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
