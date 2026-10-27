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
        partnerOfUid: 'u2',
        activeWeddingId: 'wedding_123',
        coupleRole: 'GROOM',
      );

      expect(updated.accessLevel, equals(AccessLevel.premium));
      expect(updated.displayName, equals('Alya & Rivaldi'));
      expect(updated.email, equals('test@example.com'));
      expect(updated.partnerOfUid, equals('u2'));
      expect(updated.activeWeddingId, equals('wedding_123'));
      expect(updated.coupleRole, equals('GROOM'));
      expect(updated.isPartnerLinked, isTrue);
    });

    test('Couple licensing & effectiveIsPremium inherits correctly without inflating revenue', () {
      final primaryUser = AppUserInfo(
        uid: 'primary_1',
        email: 'primary@wedding.com',
        accessLevel: AccessLevel.premium,
        isPrimaryPayer: true,
        activeWeddingId: 'wedding_abc',
        createdAt: 1000,
        updatedAt: 1000,
      );

      final partnerUser = AppUserInfo(
        uid: 'partner_2',
        email: 'partner@wedding.com',
        accessLevel: AccessLevel.none,
        isPrimaryPayer: false,
        partnerOfUid: 'primary_1',
        activeWeddingId: 'wedding_abc',
        createdAt: 1000,
        updatedAt: 1000,
      );

      final normalPendingUser = AppUserInfo(
        uid: 'pending_3',
        email: 'pending@wedding.com',
        accessLevel: AccessLevel.none,
        isPrimaryPayer: true,
        createdAt: 1000,
        updatedAt: 1000,
      );

      // 1. Verify partner status
      expect(primaryUser.isPartnerLinked, isFalse);
      expect(partnerUser.isPartnerLinked, isTrue);
      expect(normalPendingUser.isPartnerLinked, isFalse);

      // 2. Verify effectiveIsPremium (Partner inherits premium without modifying Firestore accessLevel)
      expect(primaryUser.effectiveIsPremium, isTrue);
      expect(partnerUser.effectiveIsPremium, isTrue);
      expect(normalPendingUser.effectiveIsPremium, isFalse);

      // 3. Verify revenue calculation: 1 primary + 1 partner + 1 pending
      final users = [primaryUser, partnerUser, normalPendingUser];
      final payingUsersCount = users.where((u) => u.accessLevel == AccessLevel.premium && u.isPrimaryPayer).length;
      final linkedPartnerCount = users.where((u) => u.isPartnerLinked || (u.accessLevel == AccessLevel.premium && !u.isPrimaryPayer)).length;
      final totalOmset = payingUsersCount * 49000.0;

      expect(payingUsersCount, equals(1));
      expect(linkedPartnerCount, equals(1));
      expect(totalOmset, equals(49000.0)); // Zero revenue inflation!
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
