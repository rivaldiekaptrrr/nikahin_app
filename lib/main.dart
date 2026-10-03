import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';
import 'app/config/mock_config.dart';
import 'data/local/database.dart';
import 'data/local/mock_seeder.dart';
import 'data/repositories/wedding_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Indonesian locale formatting
  await initializeDateFormatting('id_ID', null);

  // Initialize Drift Database
  final db = AppDatabase();

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
      ],
      child: const NikahinApp(),
    ),
  );
}
