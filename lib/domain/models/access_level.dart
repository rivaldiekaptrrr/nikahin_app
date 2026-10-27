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
  });

  /// Status apakah akun ini terhubung dengan pasangan utama
  bool get isPartnerLinked => partnerOfUid != null && partnerOfUid!.isNotEmpty;

  /// Hak akses efektif (otomatis Premium jika terhubung ke pasangan berbayar)
  bool get effectiveIsPremium => accessLevel.isPremium || isPartnerLinked;

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
    );
  }
}
