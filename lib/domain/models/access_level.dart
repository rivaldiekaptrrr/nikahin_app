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
  final int createdAt;
  final int updatedAt;

  const AppUserInfo({
    required this.uid,
    required this.email,
    this.displayName,
    this.accessLevel = AccessLevel.none,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestoreMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'accessLevel': accessLevel.code,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory AppUserInfo.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return AppUserInfo(
      uid: id,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      accessLevel: AccessLevel.fromCode(map['accessLevel']),
      createdAt: (map['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: (map['updatedAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  AppUserInfo copyWith({
    String? uid,
    String? email,
    String? displayName,
    AccessLevel? accessLevel,
    int? createdAt,
    int? updatedAt,
  }) {
    return AppUserInfo(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      accessLevel: accessLevel ?? this.accessLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
