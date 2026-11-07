// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nikahin_app/features/updater/data/app_update_downloader.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String tempPath;
  MockPathProviderPlatform(this.tempPath);

  @override
  Future<String?> getTemporaryPath() async => tempPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late MockPathProviderPlatform mockPathProvider;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nikahin_updater_test_');
    mockPathProvider = MockPathProviderPlatform(tempDir.path);
    PathProviderPlatform.instance = mockPathProvider;
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Uji Integritas & Korup In-App Updater (SHA-256 Checksum)', () {
    test('Skenario A: APK Asli dan Utuh - Berhasil diverifikasi dan disimpan', () async {
      // 1. Siapkan konten biner APK tiruan yang valid
      final genuineApkBytes = utf8.encode('VALID_NIKAHIN_APK_BINARY_V1.1.13_AUTHENTIC_STREAM');
      final validSha256 = sha256.convert(genuineApkBytes).toString().toLowerCase();

      final mockClient = MockClient((request) async {
        return http.Response.bytes(
          genuineApkBytes,
          200,
          headers: {'content-length': genuineApkBytes.length.toString()},
        );
      });

      final downloader = AppUpdateDownloader(client: mockClient);

      // 2. Eksekusi unduhan dengan mencocokkan SHA-256 yang sah
      final file = await downloader.downloadApk(
        downloadUrl: 'https://github.com/rivaldiekaptrrr/nikahin_app/releases/download/v1.1.13/app-nikahin-v1.1.13.apk',
        fileName: 'app-valid.apk',
        expectedSha256: validSha256,
        onProgress: (received, total, isDownload, message) {},
      );

      // 3. Verifikasi file berhasil tersimpan dan utuh
      expect(await file.exists(), isTrue);
      final downloadedBytes = await file.readAsBytes();
      expect(sha256.convert(downloadedBytes).toString().toLowerCase(), equals(validSha256));
    });

    test('Skenario B: APK Korup / Termodifikasi - Ditolak dan otomatis dihapus dari disk', () async {
      // 1. Konten biner yang dikirim server adalah file palsu/korup
      final corruptedApkBytes = utf8.encode('CORRUPTED_OR_TAMPERED_MALICIOUS_BYTES_INJECTED');
      // Hash resmi yang seharusnya diterima (berbeda dari konten korup)
      const officialExpectedSha256 = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

      final mockClient = MockClient((request) async {
        return http.Response.bytes(
          corruptedApkBytes,
          200,
          headers: {'content-length': corruptedApkBytes.length.toString()},
        );
      });

      final downloader = AppUpdateDownloader(client: mockClient);
      final targetFilePath = '${tempDir.path}/app-corrupted.apk';

      // 2. Eksekusi unduhan dengan hash yang tidak cocok
      expect(
        () async => await downloader.downloadApk(
          downloadUrl: 'https://github.com/rivaldiekaptrrr/nikahin_app/releases/download/v1.1.13/app-nikahin-v1.1.13.apk',
          fileName: 'app-corrupted.apk',
          expectedSha256: officialExpectedSha256,
          onProgress: (received, total, isDownload, message) {},
        ),
        throwsA(
          isA<HttpException>().having(
            (e) => e.message,
            'message',
            contains('Integritas berkas pembaruan tidak valid'),
          ),
        ),
      );

      // 3. Verifikasi berkas korup otomatis terhapus dari disk untuk mencegah instalasi
      await Future.delayed(const Duration(milliseconds: 100));
      final fileOnDisk = File(targetFilePath);
      expect(await fileOnDisk.exists(), isFalse);
    });
  });
}
