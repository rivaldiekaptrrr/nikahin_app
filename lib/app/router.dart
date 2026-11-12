import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';
import 'shell/wedding_shell_scaffold.dart';
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/welcome_screen.dart';
import '../features/auth/presentation/pending_verification_screen.dart';
import '../features/budget/wedding_budget_screen.dart';
import '../features/committee/wedding_committee_screen.dart';
import '../features/dashboard/wedding_dashboard_screen.dart';
import '../features/documents/wedding_documents_screen.dart';
import '../features/guests/wedding_guests_screen.dart';
import '../features/onboarding/wedding_setup_screen.dart';
import '../features/rundown/wedding_rundown_screen.dart';
import '../features/seserahan/wedding_seserahan_screen.dart';
import '../features/settings/wedding_settings_screen.dart';
import '../features/tasks/wedding_tasks_screen.dart';
import '../features/vendors/wedding_vendor_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/payment_celebration_screen.dart';

/// Navigator observer yang aman untuk Firebase Analytics.
/// Mencegah crash jika Firebase belum terinisialisasi (misal di widget test atau web tanpa config).
class SafeFirebaseAnalyticsObserver extends NavigatorObserver {
  FirebaseAnalyticsObserver? _inner;

  FirebaseAnalyticsObserver? get _observer {
    if (_inner != null) return _inner;
    try {
      if (!kIsWeb && Firebase.apps.isNotEmpty) {
        _inner = FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
      }
    } catch (_) {
      // Firebase belum diinisialisasi atau dilewati
    }
    return _inner;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    try {
      _observer?.didPush(route, previousRoute);
    } catch (_) {}
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    try {
      _observer?.didPop(route, previousRoute);
    } catch (_) {}
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    try {
      _observer?.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    } catch (_) {}
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    try {
      _observer?.didRemove(route, previousRoute);
    } catch (_) {}
  }
}

final appRouter = GoRouter(
  initialLocation: '/',
  observers: [
    SafeFirebaseAnalyticsObserver(),
  ],
  redirect: (context, state) {
    final uri = state.uri;
    // Tangkap jika aplikasi dibuka via deep link kembalian pembayaran
    // baik berupa nikahin://payment-finish, nikahin:///payment-finish, atau query order_id
    final isPaymentReturn = uri.host == 'payment-finish' ||
        uri.path == '/payment-finish' ||
        (uri.queryParameters.containsKey('order_id') && uri.queryParameters['result'] == 'success');

    if (isPaymentReturn && state.matchedLocation != '/payment-finish') {
      final orderId = uri.queryParameters['order_id'] ?? '';
      return '/payment-finish?order_id=$orderId';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        // Fallback proteksi: jika root didatangi membawa order_id atau host payment-finish
        if (state.uri.host == 'payment-finish' ||
            (state.uri.queryParameters.containsKey('order_id') && state.uri.queryParameters['result'] == 'success')) {
          final orderId = state.uri.queryParameters['order_id'] ?? '';
          return PaymentCelebrationScreen(orderId: orderId);
        }
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/pending-verification',
      builder: (context, state) => const PendingVerificationScreen(),
    ),
    GoRoute(
      path: '/payment-finish',
      builder: (context, state) {
        final orderId = state.uri.queryParameters['order_id'] ?? '';
        return PaymentCelebrationScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/setup',
      builder: (context, state) => const WeddingSetupScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final profileId = state.pathParameters['profileId'] ?? '';
        final location = state.uri.path;
        return WeddingShellScaffold(
          profileId: profileId,
          location: location,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/wedding/:profileId',
          builder: (context, state) {
            final profileId = state.pathParameters['profileId']!;
            return WeddingDashboardScreen(profileId: profileId);
          },
          routes: [
            GoRoute(
              path: 'budget',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingBudgetScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'guests',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingGuestsScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'vendors',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingVendorScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'tasks',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingTasksScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'committee',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingCommitteeScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'rundown',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingRundownScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'seserahan',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingSeserahanScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'documents',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingDocumentsScreen(profileId: profileId);
              },
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) {
                final profileId = state.pathParameters['profileId']!;
                return WeddingSettingsScreen(profileId: profileId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

