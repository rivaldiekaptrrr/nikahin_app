import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/features/auth/presentation/auth_notifier.dart';
import 'package:nikahin_app/features/auth/presentation/auth_state.dart';
import 'package:nikahin_app/features/auth/presentation/widgets/demo_restriction_sheet.dart';
import 'package:nikahin_app/features/auth/presentation/widgets/demo_sticky_banner.dart';

void main() {
  group('Demo Mode Widgets Tests', () {
    testWidgets('DemoStickyBanner renders banner when isDemoMode is true', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(
              () => _TestAuthNotifier(
                const AuthState(
                  status: AuthStatus.demoMode,
                  displayName: 'Tamu (Demo)',
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DemoStickyBanner(),
            ),
          ),
        ),
      );

      expect(find.text('Mode Demo (Hanya Lihat)'), findsOneWidget);
      expect(find.text('Masuk Akun'), findsOneWidget);
    });

    testWidgets('DemoStickyBanner does not render when user is authenticated', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(
              () => _TestAuthNotifier(
                const AuthState(
                  status: AuthStatus.authenticated,
                  userId: 'user_1',
                  email: 'test@nikahin.app',
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DemoStickyBanner(),
            ),
          ),
        ),
      );

      expect(find.text('Mode Demo (Hanya Lihat)'), findsNothing);
      expect(find.text('Masuk Akun'), findsNothing);
    });

    testWidgets('showDemoRestrictionSheet displays modal sheet with action name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDemoRestrictionSheet(context, featureName: 'menambah pos anggaran'),
                child: const Text('Buka Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Mode Demo (Hanya Lihat)'), findsOneWidget);
      expect(find.textContaining('menambah pos anggaran'), findsOneWidget);
      expect(find.text('Masuk / Daftar Akun'), findsOneWidget);
    });
  });
}

class _TestAuthNotifier extends AuthNotifier {
  final AuthState _initialState;
  _TestAuthNotifier(this._initialState);

  @override
  AuthState build() => _initialState;
}
