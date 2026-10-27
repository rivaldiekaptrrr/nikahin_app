import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wedding_models.dart';
import '../remote/firestore_rest_service.dart';
import '../repositories/wedding_repository.dart';

enum CouplePairingStatus {
  success,
  invalidCode,
  expiredCode,
  alreadyClaimed,
  selfPairingNotAllowed,
  rateLimited,
  networkError,
}

class CouplePairingResult {
  final CouplePairingStatus status;
  final String message;
  final String? weddingId;
  final String? creatorUid;
  final String? creatorName;

  CouplePairingResult({
    required this.status,
    required this.message,
    this.weddingId,
    this.creatorUid,
    this.creatorName,
  });

  bool get isSuccess => status == CouplePairingStatus.success;
}

class PairingCodeData {
  final String code;
  final String creatorUid;
  final String creatorName;
  final String weddingId;
  final String creatorRole; // 'GROOM' | 'BRIDE'
  final int expiresAt;
  final String status; // 'active' | 'claimed' | 'expired'
  final String? claimedByUid;
  final int createdAt;

  PairingCodeData({
    required this.code,
    required this.creatorUid,
    required this.creatorName,
    required this.weddingId,
    required this.creatorRole,
    required this.expiresAt,
    required this.status,
    this.claimedByUid,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().millisecondsSinceEpoch > expiresAt;
  bool get isActive => status == 'active' && !isExpired;

  Map<String, dynamic> toMap() => {
        'code': code,
        'creatorUid': creatorUid,
        'creatorName': creatorName,
        'weddingId': weddingId,
        'creatorRole': creatorRole,
        'expiresAt': expiresAt,
        'status': status,
        'claimedByUid': claimedByUid,
        'createdAt': createdAt,
      };

  factory PairingCodeData.fromMap(Map<String, dynamic> map, String code) {
    return PairingCodeData(
      code: code,
      creatorUid: map['creatorUid'] ?? '',
      creatorName: map['creatorName'] ?? 'Pasangan Anda',
      weddingId: map['weddingId'] ?? '',
      creatorRole: map['creatorRole'] ?? 'GROOM',
      expiresAt: (map['expiresAt'] as num?)?.toInt() ?? 0,
      status: map['status'] ?? 'active',
      claimedByUid: map['claimedByUid'],
      createdAt: (map['createdAt'] as num?)?.toInt() ?? 0,
    );
  }
}

class CouplePairingService {
  final FirestoreRestService firestore;

  // Rate Limiting (Brute Force Protection)
  static int _failedAttempts = 0;
  static int? _lastFailedTimestamp;
  static const int _maxAttempts = 5;
  static const Duration _cooldownDuration = Duration(minutes: 15);

  CouplePairingService({required this.firestore});

  /// Menormalisasi kode masukan pengguna (menghapus spasi, strip, dan prefiks NK-)
  static String normalizeCode(String input) {
    var clean = input.trim().toUpperCase().replaceAll('-', '').replaceAll(' ', '');
    if (clean.startsWith('NK')) {
      clean = clean.substring(2);
    }
    return clean;
  }

  /// Format kode untuk tampilan estetis pengguna (e.g. NK-8F2X9A)
  static String formatCodeForDisplay(String code) {
    final clean = normalizeCode(code);
    if (clean.length == 6) {
      return 'NK-${clean.substring(0, 3)}-${clean.substring(3)}';
    }
    return 'NK-$clean';
  }

  bool _isRateLimited() {
    if (_failedAttempts >= _maxAttempts) {
      if (_lastFailedTimestamp != null) {
        final elapsed = DateTime.now().millisecondsSinceEpoch - _lastFailedTimestamp!;
        if (elapsed < _cooldownDuration.inMilliseconds) {
          return true;
        } else {
          _resetFailedAttempts();
        }
      }
    }
    return false;
  }

  void _registerFailedAttempt() {
    _failedAttempts++;
    _lastFailedTimestamp = DateTime.now().millisecondsSinceEpoch;
  }

  void _resetFailedAttempts() {
    _failedAttempts = 0;
    _lastFailedTimestamp = null;
  }

  /// Membuat kode pairing 6-karakter acak dengan masa berlaku 48 jam
  Future<PairingCodeData?> generatePairingCode({
    required String creatorUid,
    required String creatorName,
    required String weddingId,
    required String creatorRole,
    WeddingProfile? profile,
  }) async {
    const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
    final rnd = Random.secure();
    final code = String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );

    final now = DateTime.now().millisecondsSinceEpoch;
    final expiresAt = DateTime.now().add(const Duration(hours: 48)).millisecondsSinceEpoch;

    final pairingData = PairingCodeData(
      code: code,
      creatorUid: creatorUid,
      creatorName: creatorName,
      weddingId: weddingId,
      creatorRole: creatorRole,
      expiresAt: expiresAt,
      status: 'active',
      createdAt: now,
    );

    // 1. Simpan kode ke koleksi pairing_codes
    final savedCode = await firestore.putDocument(
      path: 'pairing_codes/$code',
      data: pairingData.toMap(),
    );

    if (!savedCode) return null;

    // 2. Pastikan dokumen workspace pernikahan di /weddings/{weddingId} sudah ada
    final existingWedding = await firestore.getDocument(path: 'weddings/$weddingId');
    final members = (existingWedding?['members'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [creatorUid];
    if (!members.contains(creatorUid)) members.add(creatorUid);

    await firestore.putDocument(
      path: 'weddings/$weddingId',
      data: {
        'weddingId': weddingId,
        'creatorUid': creatorUid,
        'creatorName': creatorName,
        if (profile != null) ...{
          'groomName': profile.groomName,
          'brideName': profile.brideName,
          'weddingDate': profile.weddingDate,
          'totalBudgetCap': profile.totalBudgetCap,
        },
        'members': members,
        'createdAt': existingWedding?['createdAt'] ?? now,
        'updatedAt': now,
      },
    );

    if (profile != null) {
      await firestore.putDocument(
        path: 'weddings/$weddingId/wedding_profiles/${profile.id}',
        data: profile.toFirestoreMap(),
      );
    }

    // 3. Pastikan activeWeddingId tersimpan pada profil user pembuat
    await firestore.putDocument(
      path: 'users/$creatorUid',
      data: {
        'activeWeddingId': weddingId,
        'coupleRole': creatorRole,
        'updatedAt': now,
      },
      updateMask: ['activeWeddingId', 'coupleRole', 'updatedAt'],
    );

    return pairingData;
  }

  /// Mengambil data kode pairing aktif yang belum expired
  Future<PairingCodeData?> getPairingCode(String rawCode) async {
    final code = normalizeCode(rawCode);
    if (code.length != 6) return null;

    final doc = await firestore.getDocument(path: 'pairing_codes/$code');
    if (doc == null) return null;

    return PairingCodeData.fromMap(doc, code);
  }

  /// Memverifikasi dan mengklaim kode pairing oleh akun pasangan
  Future<CouplePairingResult> verifyAndClaimPairingCode({
    required String rawCode,
    required String partnerUid,
    required String partnerRole,
  }) async {
    if (_isRateLimited()) {
      return CouplePairingResult(
        status: CouplePairingStatus.rateLimited,
        message: 'Terlalu banyak percobaan gagal. Silakan tunggu 15 menit sebelum mencoba kembali.',
      );
    }

    final code = normalizeCode(rawCode);
    if (code.length != 6) {
      _registerFailedAttempt();
      return CouplePairingResult(
        status: CouplePairingStatus.invalidCode,
        message: 'Format kode tidak valid. Pastikan memasukkan 6 karakter alfanumerik.',
      );
    }

    final doc = await firestore.getDocument(path: 'pairing_codes/$code');
    if (doc == null) {
      _registerFailedAttempt();
      return CouplePairingResult(
        status: CouplePairingStatus.invalidCode,
        message: 'Kode pairing tidak ditemukan atau sudah tidak berlaku.',
      );
    }

    final pairingData = PairingCodeData.fromMap(doc, code);

    if (pairingData.creatorUid == partnerUid) {
      return CouplePairingResult(
        status: CouplePairingStatus.selfPairingNotAllowed,
        message: 'Anda tidak dapat menautkan akun dengan kode yang Anda buat sendiri.',
      );
    }

    if (pairingData.isExpired) {
      return CouplePairingResult(
        status: CouplePairingStatus.expiredCode,
        message: 'Kode pairing sudah kedaluwarsa (berlaku 48 jam). Mintalah pasangan Anda membuat kode baru.',
      );
    }

    if (pairingData.status != 'active' || pairingData.claimedByUid != null) {
      return CouplePairingResult(
        status: CouplePairingStatus.alreadyClaimed,
        message: 'Kode pairing ini sudah pernah digunakan oleh akun lain.',
      );
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final weddingId = pairingData.weddingId;

    // 1. Update status kode pairing ke 'claimed'
    final codeUpdated = await firestore.putDocument(
      path: 'pairing_codes/$code',
      data: {
        'status': 'claimed',
        'claimedByUid': partnerUid,
        'claimedAt': now,
      },
      updateMask: ['status', 'claimedByUid', 'claimedAt'],
    );

    if (!codeUpdated) {
      return CouplePairingResult(
        status: CouplePairingStatus.networkError,
        message: 'Gagal memperbarui status kode pairing. Periksa koneksi internet Anda.',
      );
    }

    // 2. Tambahkan partner ke daftar anggota workspace pernikahan (maksimum 2 anggota)
    final weddingDoc = await firestore.getDocument(path: 'weddings/$weddingId');
    final currentMembers = (weddingDoc?['members'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [pairingData.creatorUid];

    if (!currentMembers.contains(partnerUid)) {
      currentMembers.add(partnerUid);
    }

    await firestore.putDocument(
      path: 'weddings/$weddingId',
      data: {
        'members': currentMembers,
        'updatedAt': now,
      },
      updateMask: ['members', 'updatedAt'],
    );

    // 3. Perbarui profil user pasangan: tautkan ke creatorUid, set workspace, dan set isPrimaryPayer false
    await firestore.putDocument(
      path: 'users/$partnerUid',
      data: {
        'partnerOfUid': pairingData.creatorUid,
        'activeWeddingId': weddingId,
        'coupleRole': partnerRole,
        'isPrimaryPayer': false,
        'updatedAt': now,
      },
      updateMask: ['partnerOfUid', 'activeWeddingId', 'coupleRole', 'isPrimaryPayer', 'updatedAt'],
    );

    // 4. Perbarui profil user pembuat: tautkan ke partnerUid
    await firestore.putDocument(
      path: 'users/${pairingData.creatorUid}',
      data: {
        'partnerOfUid': partnerUid,
        'updatedAt': now,
      },
      updateMask: ['partnerOfUid', 'updatedAt'],
    );

    _resetFailedAttempts();

    return CouplePairingResult(
      status: CouplePairingStatus.success,
      message: 'Berhasil terhubung dengan ${pairingData.creatorName}!',
      weddingId: weddingId,
      creatorUid: pairingData.creatorUid,
      creatorName: pairingData.creatorName,
    );
  }

  /// Memutuskan tautan pasangan (Unlink)
  Future<bool> unlinkPartner({
    required String currentUid,
    required String partnerUid,
    required String weddingId,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Reset profil user saat ini
    await firestore.putDocument(
      path: 'users/$currentUid',
      data: {
        'partnerOfUid': '',
        'updatedAt': now,
      },
      updateMask: ['partnerOfUid', 'updatedAt'],
    );

    // 2. Hapus partner dari workspace pernikahan jika ada
    final weddingDoc = await firestore.getDocument(path: 'weddings/$weddingId');
    if (weddingDoc != null) {
      final members = (weddingDoc['members'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      members.remove(partnerUid);
      await firestore.putDocument(
        path: 'weddings/$weddingId',
        data: {
          'members': members,
          'updatedAt': now,
        },
        updateMask: ['members', 'updatedAt'],
      );
    }

    return true;
  }
}

final couplePairingServiceProvider = Provider<CouplePairingService>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return CouplePairingService(firestore: firestore);
});
