import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/shared/utils/currency_utils.dart';

void main() {
  group('CurrencyUtils Tests', () {
    test('formats numbers into Indonesian Rupiah (IDR)', () {
      expect(CurrencyUtils.formatRupiah(0), 'Rp 0');
      expect(CurrencyUtils.formatRupiah(1500000), 'Rp 1.500.000');
      expect(CurrencyUtils.formatRupiah(50000000), 'Rp 50.000.000');
    });

    test('parses clean and formatted strings to double', () {
      expect(CurrencyUtils.parseRupiah('Rp 1.500.000'), 1500000.0);
      expect(CurrencyUtils.parseRupiah('50.000'), 50000.0);
      expect(CurrencyUtils.parseRupiah(''), 0.0);
      expect(CurrencyUtils.parseRupiah('abc'), 0.0);
    });

    test('compact IDR format for large wedding budgets', () {
      expect(CurrencyUtils.formatRupiahCompact(500000), 'Rp 500 rb');
      expect(CurrencyUtils.formatRupiahCompact(15000000), 'Rp 15.0 jt');
      expect(CurrencyUtils.formatRupiahCompact(2500000000), 'Rp 2.5 M');
    });
  });
}
