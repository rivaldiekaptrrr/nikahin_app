import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/features/updater/data/app_update_checker.dart';
import 'package:nikahin_app/features/updater/domain/models/app_release_info.dart';
import 'package:nikahin_app/features/updater/presentation/update_notifier.dart';

void main() {
  group('AppUpdateChecker - Semantic Versioning Comparison', () {
    test('isNewerVersion mendeteksi patch version lebih tinggi', () {
      expect(AppUpdateChecker.isNewerVersion('1.0.0', '1.0.1'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.0.0', 'v1.0.1'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.0.1', '1.0.0'), isFalse);
    });

    test('isNewerVersion mendeteksi minor version lebih tinggi', () {
      expect(AppUpdateChecker.isNewerVersion('1.0.5', '1.1.0'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.2.0', '1.1.9'), isFalse);
    });

    test('isNewerVersion mendeteksi major version lebih tinggi', () {
      expect(AppUpdateChecker.isNewerVersion('1.9.9', '2.0.0'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('2.0.0', '1.9.9'), isFalse);
    });

    test('isNewerVersion mengembalikan false jika versi sama', () {
      expect(AppUpdateChecker.isNewerVersion('1.0.0', '1.0.0'), isFalse);
      expect(AppUpdateChecker.isNewerVersion('v1.0.0', '1.0.0'), isFalse);
      expect(AppUpdateChecker.isNewerVersion('1.0.0+1', '1.0.0'), isFalse);
    });

    test('isNewerVersion menangani format tag dengan awalan v atau suffix build', () {
      expect(AppUpdateChecker.isNewerVersion('v1.0.0', 'v1.2.0'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.0.0+5', 'v1.0.1+1'), isTrue);
    });
  });

  group('AppReleaseInfo Model Parsing', () {
    test('fromJson mem-parsing JSON GitHub Release dengan benar', () {
      final json = {
        'tag_name': 'v1.1.0',
        'name': 'Nikahin v1.1.0',
        'body': 'Catatan rilis fitur baru',
        'published_at': '2026-10-05T12:00:00Z',
        'assets': [
          {
            'name': 'app-nikahin-v1.1.0.apk',
            'browser_download_url':
                'https://github.com/rivaldiekaptrrr/nikahin_app/releases/download/v1.1.0/app-nikahin-v1.1.0.apk',
            'size': 25000000,
          }
        ],
      };

      final release = AppReleaseInfo.fromJson(json);

      expect(release.tagName, 'v1.1.0');
      expect(release.versionName, '1.1.0');
      expect(release.releaseName, 'Nikahin v1.1.0');
      expect(release.releaseNotes, 'Catatan rilis fitur baru');
      expect(release.hasApk, isTrue);
      expect(release.apkFileName, 'app-nikahin-v1.1.0.apk');
      expect(release.apkFileSize, 25000000);
      expect(release.publishedAt, isNotNull);
    });

    test('fromJson memprioritaskan universal APK atau arm64 APK dengan cerdas', () {
      final jsonMulti = {
        'tag_name': 'v1.2.0',
        'name': 'Nikahin v1.2.0',
        'body': 'Multi-asset release',
        'assets': [
          {
            'name': 'app-nikahin-v1.2.0.apk',
            'browser_download_url': 'https://example.com/universal.apk',
            'size': 45000000,
          },
          {
            'name': 'app-nikahin-v1.2.0-arm64.apk',
            'browser_download_url': 'https://example.com/arm64.apk',
            'size': 22000000,
          },
        ],
      };

      final release = AppReleaseInfo.fromJson(jsonMulti);
      expect(release.hasApk, isTrue);
      expect(release.apkDownloadUrl, isNotEmpty);
    });
  });

  group('UpdateState Speed & Time Estimation', () {
    test('formattedSpeed memformat KB/s dan MB/s dengan benar', () {
      const stateKb = UpdateState(bytesPerSecond: 512 * 1024);
      expect(stateKb.formattedSpeed, '512 KB/s');

      const stateMb = UpdateState(bytesPerSecond: 2.5 * 1024 * 1024);
      expect(stateMb.formattedSpeed, '2.5 MB/s');

      const stateZero = UpdateState(bytesPerSecond: 0);
      expect(stateZero.formattedSpeed, isEmpty);
    });

    test('formattedRemainingTime mengestimasi sisa waktu unduhan dengan benar', () {
      // 10 MB total, 5 MB received, 1 MB/s -> sisa 5 detik
      const stateSeconds = UpdateState(
        totalBytes: 10 * 1024 * 1024,
        receivedBytes: 5 * 1024 * 1024,
        bytesPerSecond: 1 * 1024 * 1024,
      );
      expect(stateSeconds.formattedRemainingTime, 'Sisa ~5 dtk');

      // 100 MB total, 20 MB received, 1 MB/s -> sisa 80 detik = 1m 20d
      const stateMinutes = UpdateState(
        totalBytes: 100 * 1024 * 1024,
        receivedBytes: 20 * 1024 * 1024,
        bytesPerSecond: 1 * 1024 * 1024,
      );
      expect(stateMinutes.formattedRemainingTime, 'Sisa ~1m 20d');

      // Selesai atau 0 speed
      const stateDone = UpdateState(
        totalBytes: 10 * 1024 * 1024,
        receivedBytes: 10 * 1024 * 1024,
        bytesPerSecond: 1 * 1024 * 1024,
      );
      expect(stateDone.formattedRemainingTime, isEmpty);
    });
  });
}
