import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_update_checker.dart';
import '../data/app_update_downloader.dart';
import '../data/app_update_installer.dart';
import '../domain/models/app_release_info.dart';

enum UpdateStatus {
  initial,
  checking,
  available,
  upToDate,
  downloading,
  readyToInstall,
  error,
}

class UpdateState {
  final UpdateStatus status;
  final String currentVersion;
  final AppReleaseInfo? releaseInfo;
  final double downloadProgress; // 0.0 - 1.0
  final int receivedBytes;
  final int totalBytes;
  final String? downloadedFilePath;
  final String? errorMessage;

  const UpdateState({
    this.status = UpdateStatus.initial,
    this.currentVersion = '',
    this.releaseInfo,
    this.downloadProgress = 0.0,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.downloadedFilePath,
    this.errorMessage,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    String? currentVersion,
    AppReleaseInfo? releaseInfo,
    double? downloadProgress,
    int? receivedBytes,
    int? totalBytes,
    String? downloadedFilePath,
    String? errorMessage,
  }) {
    return UpdateState(
      status: status ?? this.status,
      currentVersion: currentVersion ?? this.currentVersion,
      releaseInfo: releaseInfo ?? this.releaseInfo,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      receivedBytes: receivedBytes ?? this.receivedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final appUpdateCheckerProvider = Provider<AppUpdateChecker>((ref) {
  return AppUpdateChecker();
});

final appUpdateDownloaderProvider = Provider<AppUpdateDownloader>((ref) {
  return AppUpdateDownloader();
});

final updateNotifierProvider =
    NotifierProvider<UpdateNotifier, UpdateState>(UpdateNotifier.new);

class UpdateNotifier extends Notifier<UpdateState> {
  late final AppUpdateChecker _checker;
  late final AppUpdateDownloader _downloader;

  @override
  UpdateState build() {
    _checker = ref.watch(appUpdateCheckerProvider);
    _downloader = ref.watch(appUpdateDownloaderProvider);
    Future.microtask(_loadCurrentVersion);
    return const UpdateState();
  }

  Future<void> _loadCurrentVersion() async {
    final version = await _checker.getCurrentVersion();
    state = state.copyWith(currentVersion: version);
  }

  /// Memeriksa pembaruan rilis.
  /// [silent] jika true: bila tidak ada rilis baru, tidak mengubah status jadi upToDate (agar tidak memunculkan notif/dialog)
  Future<AppReleaseInfo?> checkForUpdate({bool silent = false}) async {
    final version = await _checker.getCurrentVersion();
    state = state.copyWith(
      status: UpdateStatus.checking,
      currentVersion: version,
      errorMessage: null,
    );

    try {
      final release = await _checker.checkForUpdate();
      if (release != null) {
        state = state.copyWith(
          status: UpdateStatus.available,
          releaseInfo: release,
        );
        return release;
      } else {
        state = state.copyWith(
          status: silent ? UpdateStatus.initial : UpdateStatus.upToDate,
          releaseInfo: null,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        status: silent ? UpdateStatus.initial : UpdateStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Mengunduh APK pembaruan dan langsung memicu installer
  Future<void> startDownloadAndInstall([AppReleaseInfo? targetRelease]) async {
    final release = targetRelease ?? state.releaseInfo;
    if (release == null || !release.hasApk) {
      // Jika tidak ada aset APK langsung, buka browser ke web rilis
      await AppUpdateInstaller.openReleasesWeb(release?.apkDownloadUrl);
      return;
    }

    state = state.copyWith(
      status: UpdateStatus.downloading,
      downloadProgress: 0.0,
      receivedBytes: 0,
      totalBytes: release.apkFileSize,
      errorMessage: null,
    );

    try {
      final file = await _downloader.downloadApk(
        downloadUrl: release.apkDownloadUrl!,
        fileName: release.apkFileName ?? 'app-nikahin-${release.tagName}.apk',
        onProgress: (progress, received, total) {
          state = state.copyWith(
            downloadProgress: progress,
            receivedBytes: received,
            totalBytes: total,
          );
        },
      );

      state = state.copyWith(
        status: UpdateStatus.readyToInstall,
        downloadProgress: 1.0,
        downloadedFilePath: file.path,
      );

      // Pemicu installer otomatis
      await AppUpdateInstaller.installApk(file.path);
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: 'Gagal mengunduh berkas pembaruan: $e',
      );
    }
  }

  /// Membuka kembali installer dari berkas APK yang sudah diunduh sebelumnya
  Future<void> installExistingApk() async {
    if (state.downloadedFilePath != null) {
      await AppUpdateInstaller.installApk(state.downloadedFilePath!);
    }
  }

  /// Reset status pembaruan
  void dismiss() {
    state = state.copyWith(status: UpdateStatus.initial, errorMessage: null);
  }
}
