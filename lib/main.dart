import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if (existingMockProfile == null || existingTerms.isEmpty) {
      await MockSeeder.seedAllMockData(db);
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
