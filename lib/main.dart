import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';
import 'app/config/mock_config.dart';
import 'data/local/database.dart';
import 'data/local/mock_seeder.dart';
import 'data/local/preferences_manager.dart';
import 'data/repositories/wedding_repository.dart';
import 'data/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase & Crashlytics untuk pemantauan crash lapangan (Mobile)
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();

      // Di mode debug lokal, nonaktifkan koleksi Crashlytics agar assertion pengujian tidak mengotori analitik
      if (kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      } else {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }

      // Teruskan seluruh error fatal tak tertangani dari framework Flutter ke Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      // Tangkap error asinkron tak tertangani di luar framework Flutter
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e) {
      debugPrint('[Crashlytics] Inisialisasi dilewati atau tidak aktif: $e');
    }
  }

  // Initialize Indonesian locale formatting
  await initializeDateFormatting('id_ID', null);

  // Initialize Drift Database
  final db = AppDatabase();

  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.init();

  // Reschedule daily reminder if enabled
  try {
    final isDailyEnabled = await AppPreferences.isDailyReminderEnabled();
    if (isDailyEnabled) {
      final hour = await AppPreferences.getDailyReminderHour();
      final minute = await AppPreferences.getDailyReminderMinute();
      await notificationService.scheduleDailyReminder(hour: hour, minute: minute);
    }
  } catch (_) {}

  // Seed rich mock data if toggle is active, or auto-migrate if mock profile is outdated
  try {
    final existingMockProfile = await db.getProfileById(MockSeeder.primaryMockProfileId);
    if (kUseMockData || (existingMockProfile != null && MockSeeder.isOutdated(existingMockProfile))) {
      await MockSeeder.seedAllMockData(db);
    }
  } catch (e) {
    debugPrint('[MockSeeder] Migrasi data mock dilewati: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const NikahinApp(),
    ),
  );
}
