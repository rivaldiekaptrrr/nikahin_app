import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/local/preferences_manager.dart';

/// Notifier untuk mengelola personalisasi foto latar belakang kartu utama (Hero D-Day)
class HeroCoverNotifier extends AsyncNotifier<String?> {
  final String profileId;

  HeroCoverNotifier(this.profileId);

  @override
  Future<String?> build() async {
    final photoPath = await AppPreferences.getHeroCoverPhoto(profileId);
    if (kIsWeb && photoPath != null && photoPath.startsWith('blob:')) {
      // Bersihkan blob URL kadaluarsa dari sesi sebelumnya agar tidak merusak tampilan kartu
      await AppPreferences.setHeroCoverPhoto(profileId, null);
      return null;
    }
    return photoPath;
  }

  /// Memilih foto dari galeri atau kamera dan menyimpannya secara permanen
  Future<bool> pickAndSavePhoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        imageQuality: 88,
      );

      if (picked == null) return false;

      String finalPath;
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        final base64String = base64Encode(bytes);
        final ext = picked.path.contains('.') ? picked.path.split('.').last.toLowerCase() : 'jpg';
        final mime = (ext == 'png') ? 'image/png' : 'image/jpeg';
        finalPath = 'data:$mime;base64,$base64String';
      } else {
        final appDir = await getApplicationDocumentsDirectory();
        final ext = picked.path.contains('.') ? picked.path.split('.').last : 'jpg';
        final fileName = 'hero_cover_${profileId}_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final savedFile = File('${appDir.path}/$fileName');

        // Bersihkan foto lama jika ada
        final oldPath = state.value;
        if (oldPath != null && oldPath.isNotEmpty) {
          try {
            final oldFile = File(oldPath);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          } catch (_) {}
        }

        await File(picked.path).copy(savedFile.path);
        finalPath = savedFile.path;
      }

      await AppPreferences.setHeroCoverPhoto(profileId, finalPath);
      state = AsyncData(finalPath);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Menghapus foto latar belakang kustom dan kembali ke gradasi tema bawaan
  Future<void> removePhoto() async {
    final oldPath = state.value;
    if (oldPath != null && oldPath.isNotEmpty && !kIsWeb && !oldPath.startsWith('data:')) {
      try {
        final oldFile = File(oldPath);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      } catch (_) {}
    }
    await AppPreferences.setHeroCoverPhoto(profileId, null);
    state = const AsyncData(null);
  }
}

final heroCoverNotifierProvider =
    AsyncNotifierProvider.family<HeroCoverNotifier, String?, String>(
  HeroCoverNotifier.new,
);
