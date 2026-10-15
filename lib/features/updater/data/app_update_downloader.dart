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
  /// Memanggil callback [onProgress] dengan nilai persentase 0.0 s/d 1.0, byte diterima, total byte, dan kecepatan (bytes/sec).
  /// Mengembalikan [File] APK yang telah selesai diunduh.
  Future<File> downloadApk({
    required String downloadUrl,
    required String fileName,
    required void Function(
      double progress,
      int received,
      int total,
      double bytesPerSecond,
    ) onProgress,
  }) async {
    final uri = Uri.parse(downloadUrl);
    final request = http.Request('GET', uri);
    request.headers.addAll({
      'Accept': 'application/octet-stream',
      'User-Agent': 'NikahinApp-Flutter',
    });

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

    final stopwatch = Stopwatch()..start();
    int lastNotifiedMs = 0;
    int lastSpeedSampleMs = 0;
    int lastReceivedForSpeed = 0;
    double currentSpeedBps = 0.0;

    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;

        final elapsedMs = stopwatch.elapsedMilliseconds;

        // Hitung estimasi kecepatan setiap ~400ms agar pembacaan stabil dan tidak fluktuatif
        if (elapsedMs - lastSpeedSampleMs >= 400) {
          final timeDeltaSec = (elapsedMs - lastSpeedSampleMs) / 1000.0;
          final bytesDelta = receivedBytes - lastReceivedForSpeed;
          if (timeDeltaSec > 0) {
            final instantSpeed = bytesDelta / timeDeltaSec;
            currentSpeedBps = currentSpeedBps == 0
                ? instantSpeed
                : (currentSpeedBps * 0.65) + (instantSpeed * 0.35);
          }
          lastSpeedSampleMs = elapsedMs;
          lastReceivedForSpeed = receivedBytes;
        }

        // Throttle pemanggilan callback ke UI (maksimal setiap 120ms) untuk mencegah jank/lag main-thread
        if (elapsedMs - lastNotifiedMs >= 120) {
          lastNotifiedMs = elapsedMs;
          final progress =
              totalBytes > 0 ? (receivedBytes / totalBytes) : -1.0;
          onProgress(progress, receivedBytes, totalBytes, currentSpeedBps);
        }
      }

      await sink.flush();

      // Notifikasi final 100% tepat setelah stream selesai
      final finalProgress = totalBytes > 0 ? 1.0 : -1.0;
      onProgress(
        finalProgress,
        receivedBytes,
        totalBytes > 0 ? totalBytes : receivedBytes,
        currentSpeedBps,
      );
    } catch (e) {
      debugPrint('[AppUpdateDownloader] Error saat streaming download: $e');
      rethrow;
    } finally {
      stopwatch.stop();
      await sink.close();
    }

    return file;
  }
}
