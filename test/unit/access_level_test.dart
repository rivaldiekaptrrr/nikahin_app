import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/app/config/business_config.dart';
import 'package:nikahin_app/domain/models/access_level.dart';

void main() {
  group('AccessLevel & AppUserInfo Unit Tests', () {
    test('AccessLevel.fromCode parses correctly and handles invalid codes', () {
      expect(AccessLevel.fromCode('ADMIN'), equals(AccessLevel.admin));
      expect(AccessLevel.fromCode('admin'), equals(AccessLevel.admin));
      expect(AccessLevel.fromCode('PREMIUM'), equals(AccessLevel.premium));
      expect(AccessLevel.fromCode('premium'), equals(AccessLevel.premium));
      expect(AccessLevel.fromCode('WEDDING'), equals(AccessLevel.premium));
      expect(AccessLevel.fromCode('BOTH'), equals(AccessLevel.premium));
      expect(AccessLevel.fromCode('NONE'), equals(AccessLevel.none));
      expect(AccessLevel.fromCode('none'), equals(AccessLevel.none));
      expect(AccessLevel.fromCode('UNKNOWN_XYZ'), equals(AccessLevel.none));
      expect(AccessLevel.fromCode(null), equals(AccessLevel.none));
    });

    test('AccessLevel getters test', () {
      expect(AccessLevel.admin.isAdmin, isTrue);
      expect(AccessLevel.admin.isPremium, isTrue);
      expect(AccessLevel.admin.isNone, isFalse);

      expect(AccessLevel.premium.isAdmin, isFalse);
      expect(AccessLevel.premium.isPremium, isTrue);
      expect(AccessLevel.premium.isNone, isFalse);

      expect(AccessLevel.none.isAdmin, isFalse);
      expect(AccessLevel.none.isPremium, isFalse);
      expect(AccessLevel.none.isNone, isTrue);
    });

    test('AppUserInfo fromFirestoreMap and toFirestoreMap serialization', () {
      final map = {
        'email': 'buyer@wedding.com',
        'displayName': 'Asep & Neng',
        'accessLevel': 'PREMIUM',
        'createdAt': 1700000000000,
        'updatedAt': 1700000005000,
      };

      final user = AppUserInfo.fromFirestoreMap(map, 'user_abc');
      expect(user.uid, equals('user_abc'));
      expect(user.email, equals('buyer@wedding.com'));
      expect(user.displayName, equals('Asep & Neng'));
      expect(user.accessLevel, equals(AccessLevel.premium));
      expect(user.createdAt, equals(1700000000000));
      expect(user.updatedAt, equals(1700000005000));

      final encoded = user.toFirestoreMap();
      expect(encoded['uid'], equals('user_abc'));
      expect(encoded['email'], equals('buyer@wedding.com'));
      expect(encoded['accessLevel'], equals('PREMIUM'));
    });

    test('AppUserInfo copyWith updates properties', () {
      final user = AppUserInfo(
        uid: 'u1',
        email: 'test@example.com',
        accessLevel: AccessLevel.none,
        createdAt: 1000,
        updatedAt: 1000,
      );

      final updated = user.copyWith(
        accessLevel: AccessLevel.premium,
        displayName: 'Alya & Rivaldi',
      );

      expect(updated.accessLevel, equals(AccessLevel.premium));
      expect(updated.displayName, equals('Alya & Rivaldi'));
      expect(updated.email, equals('test@example.com'));
    });

    test('BusinessConfig WhatsApp URL generation', () {
      final uri = BusinessConfig.getWhatsAppConfirmationUri(
        userEmail: 'user@example.com',
      );

      final expectedNumber = BusinessConfig.useManualPaymentMode
          ? BusinessConfig.manualPaymentWhatsAppNumber
          : BusinessConfig.adminWhatsAppNumber;

      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('wa.me'));
      expect(uri.path, contains(expectedNumber));
      expect(uri.queryParameters['text'], contains('user@example.com'));
      expect(uri.queryParameters['text'], contains('Rp 49.000'));
    });
  });
}
