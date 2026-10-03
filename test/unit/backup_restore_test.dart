import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/shared/utils/export_utils.dart';

void main() {
  group('Backup & Restore JSON Validation Tests', () {
    test('parseBackupJson parses valid backup structure', () {
      final validMap = {
        'format': 'NIKAHIN_BACKUP',
        'version': 1,
        'exportedAt': 1780000000000,
        'profile': {
          'id': 'profile_1',
          'groomName': 'Rivaldi',
          'brideName': 'Alya',
          'weddingDate': 1790000000000,
          'createdAt': 1780000000000,
        },
        'expenses': [],
        'paymentTerms': [],
        'guests': [],
        'vendors': [],
        'tasks': [],
        'committee': [],
        'events': [],
        'rundownItems': [],
        'seserahan': [],
        'documents': [],
      };

      final validJson = jsonEncode(validMap);
      final parsed = ExportUtils.parseBackupJson(validJson);
      expect(parsed['format'], 'NIKAHIN_BACKUP');
      expect(parsed['version'], 1);
      expect(parsed['profile']['groomName'], 'Rivaldi');
    });

    test('parseBackupJson throws FormatException for invalid format tag', () {
      final invalidJson = jsonEncode({
        'format': 'UNKNOWN_APP',
        'version': 1,
      });

      expect(() => ExportUtils.parseBackupJson(invalidJson), throwsA(isA<FormatException>()));
    });
  });
}