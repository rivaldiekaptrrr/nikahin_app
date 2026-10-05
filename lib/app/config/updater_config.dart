/// Konfigurasi Repositori GitHub untuk In-App Updater
class UpdaterConfig {
  UpdaterConfig._();

  static const String githubOwner = 'rivaldiekaptrrr';
  static const String githubRepo = 'nikahin_app';

  /// Endpoint API GitHub Releases
  static const String releasesApiUrl =
      'https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest';

  /// URL fallback ke halaman rilis GitHub
  static const String releasesWebUrl =
      'https://github.com/$githubOwner/$githubRepo/releases';
}
