import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/domain/models/access_level.dart';
import 'package:nikahin_app/features/auth/presentation/auth_state.dart';

void main() {
  group('AuthState & AuthStatus Tests', () {
    test('initial state has default unauthenticated or initial values', () {
      const state = AuthState();
      expect(state.status, equals(AuthStatus.initial));
      expect(state.isDemoMode, isFalse);
      expect(state.isAuthenticated, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.userId, isNull);
      expect(state.accessLevel, equals(AccessLevel.none));
      expect(state.isAdmin, isFalse);
      expect(state.isPremium, isFalse);
      expect(state.isPendingVerification, isFalse);
    });

    test('demoMode status returns isDemoMode true and isAuthenticated false', () {
      const state = AuthState(
        status: AuthStatus.demoMode,
        displayName: 'Tamu (Demo)',
      );
      expect(state.isDemoMode, isTrue);
      expect(state.isAuthenticated, isFalse);
      expect(state.displayName, equals('Tamu (Demo)'));
    });

    test('authenticated status returns isAuthenticated true and isDemoMode false', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        userId: 'user_123',
        email: 'test@nikahin.app',
        displayName: 'test',
        accessLevel: AccessLevel.premium,
      );
      expect(state.isAuthenticated, isTrue);
      expect(state.isDemoMode, isFalse);
      expect(state.userId, equals('user_123'));
      expect(state.email, equals('test@nikahin.app'));
      expect(state.isPremium, isTrue);
      expect(state.isAdmin, isFalse);
      expect(state.isPendingVerification, isFalse);
    });

    test('authenticated user with accessLevel none is pending verification', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        userId: 'user_buyer',
        email: 'buyer@nikahin.app',
        accessLevel: AccessLevel.none,
      );
      expect(state.isAuthenticated, isTrue);
      expect(state.isPendingVerification, isTrue);
      expect(state.isPremium, isFalse);
      expect(state.isAdmin, isFalse);
    });

    test('admin accessLevel sets isAdmin to true and unlocks premium features', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        userId: 'admin_uid',
        email: 'rivaldiekaputr@gmail.com',
        accessLevel: AccessLevel.admin,
      );
      expect(state.isAdmin, isTrue);
      expect(state.isPremium, isTrue);
      expect(state.isPendingVerification, isFalse);
    });

    test('copyWith updates fields correctly', () {
      const state = AuthState(status: AuthStatus.initial);
      final updated = state.copyWith(
        status: AuthStatus.authenticated,
        email: 'rivaldi@nikahin.app',
        isLoading: true,
        accessLevel: AccessLevel.admin,
      );

      expect(updated.status, equals(AuthStatus.authenticated));
      expect(updated.email, equals('rivaldi@nikahin.app'));
      expect(updated.isLoading, isTrue);
      expect(updated.accessLevel, equals(AccessLevel.admin));
      expect(updated.isAdmin, isTrue);
    });
  });
}

