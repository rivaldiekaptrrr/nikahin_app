import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/features/updater/data/app_update_checker.dart';
import 'package:nikahin_app/features/updater/domain/models/app_release_info.dart';

void main() {
  group('AppUpdateChecker - isNewerVersion', () {
    test('deteksi versi remote lebih baru (patch)', () {
      expect(AppUpdateChecker.isNewerVersion('1.0.0', '1.0.1'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.0.0', 'v1.0.1'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.0.0+1', 'v1.0.1'), isTrue);
    });

    test('deteksi versi remote lebih baru (minor & major)', () {
      expect(AppUpdateChecker.isNewerVersion('1.0.0', '1.1.0'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.0.0', '2.0.0'), isTrue);
      expect(AppUpdateChecker.isNewerVersion('1.2.3', '1.3.0'), isTrue);
    });

    test('versi sama tidak dianggap lebih baru', () {
      expect(AppUpdateChecker.isNewerVersion('1.0.0', '1.0.0'), isFalse);
      expect(AppUpdateChecker.isNewerVersion('1.0.1', 'v1.0.1'), isFalse);
      expect(AppUpdateChecker.isNewerVersion('1.0.1+2', 'v1.0.1'), isFalse);
    });

    test('versi remote lebih lama tidak dianggap baru', () {
      expect(AppUpdateChecker.isNewerVersion('1.1.0', '1.0.9'), isFalse);
      expect(AppUpdateChecker.isNewerVersion('2.0.0', '1.9.9'), isFalse);
    });
  });

  group('AppReleaseInfo - fromJson', () {
    test('parsing github release payload dengan benar', () {
      final mockJson = {
        'tag_name': 'v1.0.1',
        'name': 'Nikahin v1.0.1',
        'body': 'Pembaruan fitur updater',
        'published_at': '2026-10-05T14:50:37Z',
        'assets': [
          {
            'name': 'app-nikahin-v1.0.1.apk',
            'browser_download_url':
                'https://github.com/rivaldiekaptrrr/nikahin_app/releases/download/v1.0.1/app-nikahin-v1.0.1.apk',
            'size': 39352932,
          }
        ]
      };

      final info = AppReleaseInfo.fromJson(mockJson);
      expect(info.tagName, 'v1.0.1');
      expect(info.versionName, '1.0.1');
      expect(info.releaseName, 'Nikahin v1.0.1');
      expect(info.releaseNotes, 'Pembaruan fitur updater');
      expect(info.hasApk, isTrue);
      expect(info.apkFileName, 'app-nikahin-v1.0.1.apk');
      expect(info.apkFileSize, 39352932);
      expect(
        info.apkDownloadUrl,
        'https://github.com/rivaldiekaptrrr/nikahin_app/releases/download/v1.0.1/app-nikahin-v1.0.1.apk',
      );
    });
  });
}
