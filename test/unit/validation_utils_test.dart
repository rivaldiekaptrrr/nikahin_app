import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/shared/utils/validation_utils.dart';

void main() {
  group('ValidationUtils Tests', () {
    test('validateRequired handles null, empty, whitespace, and length', () {
      expect(ValidationUtils.validateRequired(null, 'Nama'), 'Nama wajib diisi');
      expect(ValidationUtils.validateRequired('', 'Nama'), 'Nama wajib diisi');
      expect(ValidationUtils.validateRequired('   ', 'Nama'), 'Nama wajib diisi');
      expect(ValidationUtils.validateRequired('ab', 'Nama', minLength: 3), 'Nama minimal 3 karakter');
      expect(ValidationUtils.validateRequired('abc', 'Nama', minLength: 3), isNull);
    });

    test('validateName checks alphabet presence and length', () {
      expect(ValidationUtils.validateName(null, 'Nama'), 'Nama wajib diisi');
      expect(ValidationUtils.validateName('a', 'Nama'), 'Nama minimal 2 karakter');
      expect(ValidationUtils.validateName('12345', 'Nama'), 'Nama harus mengandung huruf alfabet');
      expect(ValidationUtils.validateName('Rivaldi & Sarah', 'Nama Pengantin'), isNull);
      expect(ValidationUtils.validateName('Budi', 'Nama Tamu'), isNull);
    });

    test('validateEmail checks standard RFC email format', () {
      expect(ValidationUtils.validateEmail(null, isRequired: true), 'Email wajib diisi');
      expect(ValidationUtils.validateEmail(null, isRequired: false), isNull);
      expect(ValidationUtils.validateEmail('', isRequired: false), isNull);
      expect(ValidationUtils.validateEmail('invalid-email'), contains('Format email tidak valid'));
      expect(ValidationUtils.validateEmail('user@domain'), contains('Format email tidak valid'));
      expect(ValidationUtils.validateEmail('test.user@example.com'), isNull);
      expect(ValidationUtils.validateEmail('user_123@mail.co.id'), isNull);
    });

    test('validatePassword checks minimum length and presence', () {
      expect(ValidationUtils.validatePassword(null), 'Password wajib diisi');
      expect(ValidationUtils.validatePassword(''), 'Password wajib diisi');
      expect(ValidationUtils.validatePassword('12345'), 'Password minimal 6 karakter');
      expect(ValidationUtils.validatePassword('123456'), isNull);
      expect(ValidationUtils.validatePassword('strongPassword123!'), isNull);
    });

    test('validatePhoneIndo checks Indonesian telephone format', () {
      expect(ValidationUtils.validatePhoneIndo(null, isRequired: true), 'Nomor WhatsApp / HP wajib diisi');
      expect(ValidationUtils.validatePhoneIndo(null, isRequired: false), isNull);
      expect(ValidationUtils.validatePhoneIndo('', isRequired: false), isNull);
      expect(ValidationUtils.validatePhoneIndo('1234567'), contains('terlalu pendek'));
      expect(ValidationUtils.validatePhoneIndo('081234567890123456'), contains('terlalu panjang'));
      expect(ValidationUtils.validatePhoneIndo('07123456789'), contains('diawali 08, 62, atau +62'));
      expect(ValidationUtils.validatePhoneIndo('081234567890'), isNull);
      expect(ValidationUtils.validatePhoneIndo('+6281234567890'), isNull);
      expect(ValidationUtils.validatePhoneIndo('6281234567890'), isNull);
      expect(ValidationUtils.validatePhoneIndo('0812-3456-7890'), isNull);
    });

    test('validateUrl checks scheme and valid prefix', () {
      expect(ValidationUtils.validateUrl(null, isRequired: true), 'Tautan URL wajib diisi');
      expect(ValidationUtils.validateUrl(null, isRequired: false), isNull);
      expect(ValidationUtils.validateUrl('ftp://invalid.com'), contains('diawali http:// atau https://'));
      expect(ValidationUtils.validateUrl('www.google.com'), contains('diawali http:// atau https://'));
      expect(ValidationUtils.validateUrl('https://instagram.com/nikahin'), isNull);
      expect(ValidationUtils.validateUrl('http://mysite.com/detail'), isNull);
    });

    test('validateMinNumber checks numeric ranges', () {
      expect(ValidationUtils.validateMinNumber(null, 1, 'Jumlah'), 'Jumlah wajib diisi angka');
      expect(ValidationUtils.validateMinNumber(0, 1, 'Jumlah Pax', unit: 'orang'), 'Jumlah Pax minimal 1 orang');
      expect(ValidationUtils.validateMinNumber(2, 1, 'Jumlah Pax', unit: 'orang'), isNull);
      expect(ValidationUtils.validateMinNumber(50000, 1000, 'Nominal'), isNull);
    });

    test('validateFutureOrTodayDate checks date boundaries', () {
      expect(ValidationUtils.validateFutureOrTodayDate(null, 'Tanggal'), 'Tanggal belum dipilih');
      expect(ValidationUtils.validateFutureOrTodayDate(0, 'Tanggal'), 'Tanggal belum dipilih');

      final pastDate = DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch;
      expect(ValidationUtils.validateFutureOrTodayDate(pastDate, 'Tanggal Acara'), 'Tanggal Acara tidak boleh di masa lampau');

      final today = DateTime.now().millisecondsSinceEpoch;
      expect(ValidationUtils.validateFutureOrTodayDate(today, 'Tanggal Acara'), isNull);

      final futureDate = DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch;
      expect(ValidationUtils.validateFutureOrTodayDate(futureDate, 'Tanggal Acara'), isNull);
    });
  });
}
