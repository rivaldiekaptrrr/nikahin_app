import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/domain/models/voucher_models.dart';

void main() {
  group('PricingConfig & VoucherModel', () {
    const pricing = PricingConfig(
      defaultPrice: 99000,
      minAllowedPrice: 5000,
    );

    test('Fixed discount from default price (99000) computes exact cut & final price (39000)', () {
      final voucher = VoucherModel(
        code: 'THREADS39',
        channel: 'threads',
        discountType: VoucherDiscountType.fixed,
        discountValue: 60000,
        createdAt: 1000,
        updatedAt: 1000,
      );

      expect(voucher.calculateDiscountCut(pricing), 60000);
      expect(voucher.calculateFinalPrice(pricing), 39000);
      expect(voucher.isCurrentlyUsable, true);
    });

    test('Percent discount from default price computes rounded final price', () {
      final voucher = VoucherModel(
        code: 'IG60',
        channel: 'instagram',
        discountType: VoucherDiscountType.percent,
        discountValue: 60,
        createdAt: 1000,
        updatedAt: 1000,
      );

      expect(voucher.calculateDiscountCut(pricing), 59400);
      expect(voucher.calculateFinalPrice(pricing), 39600);
    });

    test('Clamps final price at minAllowedPrice when discount exceeds defaultPrice', () {
      final voucher = VoucherModel(
        code: 'SUPERHACK',
        channel: 'organic',
        discountType: VoucherDiscountType.fixed,
        discountValue: 500000,
        createdAt: 1000,
        updatedAt: 1000,
      );

      expect(voucher.calculateFinalPrice(pricing), 5000);
    });

    test('Quota reached & expiration flags accurately disable usability', () {
      final expiredVoucher = VoucherModel(
        code: 'OLD',
        channel: 'tiktok',
        discountType: VoucherDiscountType.fixed,
        discountValue: 5000,
        validUntil: DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        createdAt: 1000,
        updatedAt: 1000,
      );
      expect(expiredVoucher.isExpired, true);
      expect(expiredVoucher.isCurrentlyUsable, false);

      final maxedVoucher = VoucherModel(
        code: 'FULL',
        channel: 'threads',
        discountType: VoucherDiscountType.fixed,
        discountValue: 5000,
        maxQuota: 10,
        usedCount: 10,
        createdAt: 1000,
        updatedAt: 1000,
      );
      expect(maxedVoucher.isQuotaReached, true);
      expect(maxedVoucher.isCurrentlyUsable, false);
    });
  });
}
