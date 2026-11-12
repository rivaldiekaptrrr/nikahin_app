/// Tingkat Hak Akses Lisensi Pengguna (Role-Based Access Control)
enum AccessLevel {
  admin('ADMIN', 'Super Admin'),
  premium('PREMIUM', 'Premium Lifetime'),
  none('NONE', 'Menunggu Aktivasi');

  final String code;
  final String label;

  const AccessLevel(this.code, this.label);

  static AccessLevel fromCode(String? code) {
    if (code == null) return AccessLevel.none;
    switch (code.toUpperCase()) {
      case 'ADMIN':
        return AccessLevel.admin;
      case 'PREMIUM':
      case 'WEDDING':
      case 'BOTH':
      case 'EXPENSE':
        return AccessLevel.premium;
      default:
        return AccessLevel.none;
    }
  }

  bool get isAdmin => this == AccessLevel.admin;
  bool get isPremium => this == AccessLevel.premium || this == AccessLevel.admin;
  bool get isNone => this == AccessLevel.none;
}

class AppUserInfo {
  final String uid;
  final String email;
  final String? displayName;
  final AccessLevel accessLevel;
  final bool isPrimaryPayer;
  final String? partnerOfUid;
  final String? activeWeddingId;
  final String? coupleRole; // 'GROOM' | 'BRIDE' | null
  final int createdAt;
  final int updatedAt;
  final int? lastActiveAt;
  final String? platform; // 'android' | 'ios' | 'web'
  final String? deviceModel; // misal: 'iPhone 15 Pro' atau 'Samsung SM-A546E'
  final String? appVersion; // misal: '2.0.5+42'
  final int? weddingDateEpoch; // stempel waktu tanggal hari H

  const AppUserInfo({
    required this.uid,
    required this.email,
    this.displayName,
    this.accessLevel = AccessLevel.none,
    this.isPrimaryPayer = true,
    this.partnerOfUid,
    this.activeWeddingId,
    this.coupleRole,
    required this.createdAt,
    required this.updatedAt,
    this.lastActiveAt,
    this.platform,
    this.deviceModel,
    this.appVersion,
    this.weddingDateEpoch,
  });

  /// Status apakah akun ini terhubung dengan pasangan utama
  bool get isPartnerLinked => partnerOfUid != null && partnerOfUid!.isNotEmpty;

  /// Hak akses efektif (otomatis Premium jika terhubung ke pasangan berbayar)
  bool get effectiveIsPremium => accessLevel.isPremium || isPartnerLinked;

  /// Apakah pengguna tercatat membuka aplikasi hari ini (Daily Active User)
  bool get isActiveToday {
    if (lastActiveAt == null) return false;
    final lastActiveDate = DateTime.fromMillisecondsSinceEpoch(lastActiveAt!);
    final now = DateTime.now();
    return lastActiveDate.year == now.year &&
        lastActiveDate.month == now.month &&
        lastActiveDate.day == now.day;
  }

  /// Identifikasi platform perangkat
  bool get isAndroid => (platform ?? '').toLowerCase() == 'android';
  bool get isIos => (platform ?? '').toLowerCase() == 'ios';
  bool get isWeb => (platform ?? '').toLowerCase() == 'web';

  /// Format teks terpadu platform dan kanal distribusi
  String get platformBadgeText {
    final plat = (platform ?? '').toLowerCase();
    if (plat == 'android') {
      return 'Android (APK)';
    } else if (plat == 'ios') {
      return 'iPhone (PWA)';
    } else if (plat == 'web') {
      return 'Web Peramban';
    }
    return 'Belum Terdeteksi';
  }

  /// Format hitung mundur Hari H pernikahan
  String? get dDayFormatted {
    if (weddingDateEpoch == null) return null;
    final weddingDate = DateTime.fromMillisecondsSinceEpoch(weddingDateEpoch!);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(weddingDate.year, weddingDate.month, weddingDate.day);
    final diffDays = target.difference(today).inDays;

    if (diffDays == 0) {
      return 'Hari H (Hari Ini!)';
    } else if (diffDays > 0) {
      return 'H-$diffDays Hari';
    } else {
      return 'H+${diffDays.abs()} (Selesai)';
    }
  }

  /// Format baca manusiawi untuk waktu terakhir aktif
  String get lastActiveFormatted {
    if (lastActiveAt == null) return 'Belum ada aktivitas';
    final date = DateTime.fromMillisecondsSinceEpoch(lastActiveAt!);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (isActiveToday) {
      if (difference.inMinutes < 60) {
        final mins = difference.inMinutes;
        return mins <= 1 ? 'Aktif baru saja' : 'Aktif $mins menit lalu';
      }
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return 'Aktif hari ini, $hour:$minute';
    }

    if (difference.inDays == 1 || (now.day - date.day == 1 && difference.inHours < 48)) {
      return 'Kemarin';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    }

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Map<String, dynamic> toFirestoreMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'accessLevel': accessLevel.code,
        'isPrimaryPayer': isPrimaryPayer,
        'partnerOfUid': partnerOfUid,
        'activeWeddingId': activeWeddingId,
        'coupleRole': coupleRole,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        if (lastActiveAt != null) 'lastActiveAt': lastActiveAt,
        if (platform != null) 'platform': platform,
        if (deviceModel != null) 'deviceModel': deviceModel,
        if (appVersion != null) 'appVersion': appVersion,
        if (weddingDateEpoch != null) 'weddingDateEpoch': weddingDateEpoch,
      };

  factory AppUserInfo.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return AppUserInfo(
      uid: id,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      accessLevel: AccessLevel.fromCode(map['accessLevel']),
      isPrimaryPayer: map['isPrimaryPayer'] as bool? ?? true,
      partnerOfUid: map['partnerOfUid'] as String?,
      activeWeddingId: map['activeWeddingId'] as String?,
      coupleRole: map['coupleRole'] as String?,
      createdAt: (map['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: (map['updatedAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      lastActiveAt: (map['lastActiveAt'] as num?)?.toInt(),
      platform: map['platform'] as String?,
      deviceModel: map['deviceModel'] as String?,
      appVersion: map['appVersion'] as String?,
      weddingDateEpoch: (map['weddingDateEpoch'] as num?)?.toInt(),
    );
  }

  AppUserInfo copyWith({
    String? uid,
    String? email,
    String? displayName,
    AccessLevel? accessLevel,
    bool? isPrimaryPayer,
    String? partnerOfUid,
    String? activeWeddingId,
    String? coupleRole,
    int? createdAt,
    int? updatedAt,
    int? lastActiveAt,
    String? platform,
    String? deviceModel,
    String? appVersion,
    int? weddingDateEpoch,
  }) {
    return AppUserInfo(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      accessLevel: accessLevel ?? this.accessLevel,
      isPrimaryPayer: isPrimaryPayer ?? this.isPrimaryPayer,
      partnerOfUid: partnerOfUid ?? this.partnerOfUid,
      activeWeddingId: activeWeddingId ?? this.activeWeddingId,
      coupleRole: coupleRole ?? this.coupleRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      platform: platform ?? this.platform,
      deviceModel: deviceModel ?? this.deviceModel,
      appVersion: appVersion ?? this.appVersion,
      weddingDateEpoch: weddingDateEpoch ?? this.weddingDateEpoch,
    );
  }
}
