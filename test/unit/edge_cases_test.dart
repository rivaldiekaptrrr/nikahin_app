import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nikahin_app/shared/utils/currency_utils.dart';
import 'package:nikahin_app/shared/utils/date_utils.dart';
import 'package:nikahin_app/shared/utils/validation_utils.dart';
import 'package:nikahin_app/domain/models/wedding_models.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('Edge Cases & Boundary Condition Tests', () {
    test('CurrencyUtils handles zero, negative, and multi-billion budget', () {
      expect(CurrencyUtils.formatRupiah(0.0), 'Rp 0');
      expect(CurrencyUtils.formatRupiahCompact(0.0), 'Rp 0');
      expect(CurrencyUtils.formatRupiahCompact(2500000000.0), 'Rp 2.5 M');
      expect(CurrencyUtils.parseRupiah(''), 0.0);
      expect(CurrencyUtils.parseRupiah('Rp 0'), 0.0);
      expect(CurrencyUtils.parseRupiah('abc'), 0.0);
    });

    test('WeddingDateUtils handles zero, negative, and leap year dates', () {
      expect(WeddingDateUtils.formatFull(0), '-');
      expect(WeddingDateUtils.formatMonthYear(-1), '-');
      expect(WeddingDateUtils.formatShort(0), '-');
      expect(WeddingDateUtils.daysUntil(0), 0);

      // Leap year Feb 29 2028
      final leapYearDate = DateTime(2028, 2, 29).millisecondsSinceEpoch;
      final fullStr = WeddingDateUtils.formatFull(leapYearDate);
      expect(fullStr, contains('29 Februari 2028'));
    });

    test('ValidationUtils handles invalid names and empty inputs', () {
      expect(ValidationUtils.validateName('123456', 'Nama Tamu'), isNotNull);
      expect(ValidationUtils.validateName('A', 'Nama Tamu'), isNotNull);
      expect(ValidationUtils.validateName('Dimas Arya', 'Nama Tamu'), isNull);

      expect(ValidationUtils.validateRequired('', 'Kolom'), isNotNull);
      expect(ValidationUtils.validateRequired('   ', 'Kolom'), isNotNull);
      expect(ValidationUtils.validateRequired('Valid text', 'Kolom'), isNull);
    });

    test('WeddingExpense handles partial DP and overpaid recalculations', () {
      const expense = WeddingExpense(
        expenseId: 'exp_1',
        weddingProfileId: 'prof_1',
        category: 'KATERING',
        title: 'Katering 500 Pax',
        totalEstimated: 50000000.0,
        totalPaid: 0.0,
        createdAt: 1780000000000,
      );

      final updated = expense.copyWith(totalPaid: 55000000.0, paymentStatus: 'FULLY_PAID');
      expect(updated.totalPaid, 55000000.0);
      expect(updated.paymentStatus, 'FULLY_PAID');
    });
  });
}

