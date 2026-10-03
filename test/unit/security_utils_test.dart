import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/shared/utils/security_utils.dart';

void main() {
  group('SecurityUtils Tests', () {
    test('maskEmail obfuscates email address while keeping domain', () {
      expect(SecurityUtils.maskEmail('dimas.arya@gmail.com'), 'd********a@gmail.com');
      expect(SecurityUtils.maskEmail('cp@kua.go.id'), 'c*@kua.go.id');
      expect(SecurityUtils.maskEmail(null), '-');
      expect(SecurityUtils.maskEmail(''), '-');
    });

    test('maskPhoneNumber hides middle digits of phone number', () {
      expect(SecurityUtils.maskPhoneNumber('081234567890'), '0812****7890');
      expect(SecurityUtils.maskPhoneNumber('0812-3456-7890'), '0812****7890');
      expect(SecurityUtils.maskPhoneNumber(null), '-');
    });

    test('sanitizeInput escapes HTML and script injection characters', () {
      final input = '<script>alert("hack")</script>';
      final sanitized = SecurityUtils.sanitizeInput(input);
      expect(sanitized, contains('&lt;script&gt;'));
      expect(sanitized, contains('&quot;'));
      expect(sanitized.contains('<'), false);
      expect(sanitized.contains('>'), false);
    });

    test('validateBackupPayload validates backup data schema', () {
      final valid = {
        'format': 'NIKAHIN_BACKUP',
        'version': 1,
        'profile': {'id': 'profile_123', 'groomName': 'Dimas'},
      };
      expect(SecurityUtils.validateBackupPayload(valid), true);

      final invalid = {
        'format': 'UNKNOWN_APP',
        'profile': {},
      };
      expect(SecurityUtils.validateBackupPayload(invalid), false);
    });
  });
}
