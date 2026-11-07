import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  // Seed rich mock data if toggle is active
  if (kUseMockData) {
    final existingMockProfile = await db.getProfileById(MockSeeder.primaryMockProfileId);
    final existingTerms = await db.getPaymentTermsForExpense('exp_1');
    final oldExp10 = await db.getExpenseById('exp_10');
    if (existingMockProfile == null || existingTerms.isEmpty || oldExp10 != null) {
      await MockSeeder.seedAllMockData(db);
    } else if (existingMockProfile.groomName == 'Rivaldi' || existingMockProfile.brideName == 'Alya') {
      await db.updateProfile(existingMockProfile.copyWith(
        groomName: 'Rama',
        brideName: 'Sinta',
      ));
    }
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
