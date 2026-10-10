import 'package:go_router/go_router.dart';
import '../data/local/database.dart';
import '../data/local/preferences_manager.dart';
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

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        final hasSeenWelcome = await AppPreferences.hasSeenWelcome();
        if (!hasSeenWelcome) {
          return '/welcome';
        }

        final email = await AppPreferences.getUserEmail();
        if (email == null || email.isEmpty) {
          return '/login';
        }

        final accessLevel = await AppPreferences.getAccessLevel();
        if (accessLevel == 'NONE') {
          return '/pending-verification';
        }

        // User sudah premium/admin — cek apakah user ini sudah membuat profil pernikahannya sendiri
        final userId = await AppPreferences.getUserId();
        final userProfileId = await AppPreferences.getUserProfileId(userId);

        if (userProfileId == null || userProfileId.isEmpty) {
          return '/setup';
        }

        final db = AppDatabase();
        try {
          final profile = await db.getProfileById(userProfileId);
          if (profile == null) {
            return '/setup';
          }
          await AppPreferences.setActiveProfileId(userProfileId);
          return '/wedding/$userProfileId';
        } finally {
          await db.close();
        }
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

