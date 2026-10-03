import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nikahin_app/shared/utils/date_utils.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('DateUtils Tests', () {
    test('formats Indonesian date correctly', () {
      final epoch = DateTime(2026, 10, 15).millisecondsSinceEpoch;
      final formatted = WeddingDateUtils.formatFull(epoch);
      expect(formatted, contains('15'));
      expect(formatted, contains('Oktober'));
      expect(formatted, contains('2026'));
    });

    test('calculates countdown D-Day string', () {
      final now = DateTime.now();
      final target = now.add(const Duration(days: 30));
      final days = WeddingDateUtils.daysUntil(target.millisecondsSinceEpoch);
      expect(days, equals(30));
    });

    test('formats time of day', () {
      final time = WeddingDateUtils.parseTime('14:30');
      expect(time.hour, 14);
      expect(time.minute, 30);
      expect(WeddingDateUtils.formatTimeOfDay(time), '14:30');
    });
  });
}
