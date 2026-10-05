import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Service untuk mengunduh berkas APK pembaruan dari URL rilis
class AppUpdateDownloader {
  final http.Client _client;

  AppUpdateDownloader({http.Client? client})
      : _client = client ?? http.Client();

  /// Mengunduh APK dari [downloadUrl] ke direktori cache lokal.
  /// Memanggil callback [onProgress] dengan nilai persentase 0.0 s/d 1.0.
  /// Mengembalikan [File] APK yang telah selesai diunduh.
  Future<File> downloadApk({
    required String downloadUrl,
    required String fileName,
    required void Function(double progress, int received, int total)
        onProgress,
  }) async {
    final uri = Uri.parse(downloadUrl);
    final request = http.Request('GET', uri);
    final response = await _client.send(request);

    if (response.statusCode != 200) {
      throw HttpException(
        'Gagal mengunduh APK: HTTP ${response.statusCode}',
        uri: uri,
      );
    }

    final totalBytes = response.contentLength ?? 0;
    final tempDir = await getTemporaryDirectory();
    final sanitizedFileName =
        fileName.isNotEmpty ? fileName : 'nikahin_update.apk';
    final filePath = '${tempDir.path}/$sanitizedFileName';
    final file = File(filePath);

    // Hapus file lama jika sudah ada
    if (await file.exists()) {
      await file.delete();
    }

    final sink = file.openWrite();
    int receivedBytes = 0;

    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;

        if (totalBytes > 0) {
          final progress = receivedBytes / totalBytes;
          onProgress(progress, receivedBytes, totalBytes);
        } else {
          // Jika content-length tidak disediakan server
          onProgress(-1.0, receivedBytes, 0);
        }
      }
      await sink.flush();
    } catch (e) {
      debugPrint('[AppUpdateDownloader] Error saat streaming download: $e');
      rethrow;
    } finally {
      await sink.close();
    }

    return file;
  }
}
