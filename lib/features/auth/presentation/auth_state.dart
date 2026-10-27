import '../../../domain/models/access_level.dart';

enum AuthStatus {
  initial,
  authenticated,
  demoMode,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final AccessLevel accessLevel;
  final bool isPrimaryPayer;
  final String? partnerOfUid;
  final String? activeWeddingId;
  final String? coupleRole;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    this.accessLevel = AccessLevel.none,
    this.isPrimaryPayer = true,
    this.partnerOfUid,
    this.activeWeddingId,
    this.coupleRole,
    this.errorMessage,
    this.isLoading = false,
  });

  bool get isDemoMode => status == AuthStatus.demoMode;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isAdmin => accessLevel.isAdmin;
  bool get isPartnerLinked => partnerOfUid != null && partnerOfUid!.isNotEmpty;
  bool get effectiveIsPremium => accessLevel.isPremium || isPartnerLinked;
  bool get isPremium => effectiveIsPremium;
  bool get isPendingVerification => isAuthenticated && accessLevel == AccessLevel.none && !isPartnerLinked;

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    AccessLevel? accessLevel,
    bool? isPrimaryPayer,
    String? partnerOfUid,
    String? activeWeddingId,
    String? coupleRole,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      accessLevel: accessLevel ?? this.accessLevel,
      isPrimaryPayer: isPrimaryPayer ?? this.isPrimaryPayer,
      partnerOfUid: partnerOfUid ?? this.partnerOfUid,
      activeWeddingId: activeWeddingId ?? this.activeWeddingId,
      coupleRole: coupleRole ?? this.coupleRole,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() =>
      'AuthState(status: $status, email: $email, accessLevel: $accessLevel, isPartnerLinked: $isPartnerLinked, isDemo: $isDemoMode, loading: $isLoading)';
}
