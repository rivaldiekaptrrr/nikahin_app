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
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    this.accessLevel = AccessLevel.none,
    this.errorMessage,
    this.isLoading = false,
  });

  bool get isDemoMode => status == AuthStatus.demoMode;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isAdmin => accessLevel.isAdmin;
  bool get isPremium => accessLevel.isPremium;
  bool get isPendingVerification => isAuthenticated && accessLevel == AccessLevel.none;

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    AccessLevel? accessLevel,
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
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() =>
      'AuthState(status: $status, email: $email, accessLevel: $accessLevel, isDemo: $isDemoMode, loading: $isLoading)';
}
