import '../../app/config/business_config.dart';

/// Konfigurasi harga default global yang dikelola dinamis melalui Admin Panel (`app_config/pricing`)
class PricingConfig {
  final double defaultPrice;
  final double minAllowedPrice;
  final int? updatedAt;

  const PricingConfig({
    this.defaultPrice = BusinessConfig.lifetimePrice,
    this.minAllowedPrice = 1000.0,
    this.updatedAt,
  });

  factory PricingConfig.fromFirestoreMap(Map<String, dynamic> map) {
    return PricingConfig(
      defaultPrice: (map['defaultPrice'] as num?)?.toDouble() ?? BusinessConfig.lifetimePrice,
      minAllowedPrice: (map['minAllowedPrice'] as num?)?.toDouble() ?? 1000.0,
      updatedAt: (map['updatedAt'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'defaultPrice': defaultPrice.toInt(),
      'minAllowedPrice': minAllowedPrice.toInt(),
      'updatedAt': updatedAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  PricingConfig copyWith({
    double? defaultPrice,
    double? minAllowedPrice,
    int? updatedAt,
  }) {
    return PricingConfig(
      defaultPrice: defaultPrice ?? this.defaultPrice,
      minAllowedPrice: minAllowedPrice ?? this.minAllowedPrice,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum VoucherDiscountType {
  fixed('FIXED', 'Nominal (Rp)'),
  percent('PERCENT', 'Persentase (%)');

  final String code;
  final String label;

  const VoucherDiscountType(this.code, this.label);

  static VoucherDiscountType fromCode(String? code) {
    return code?.toUpperCase() == 'PERCENT' ? VoucherDiscountType.percent : VoucherDiscountType.fixed;
  }
}

/// Model entitas master kode voucher di Firestore (`vouchers/{code}`)
class VoucherModel {
  final String code;
  final String channel;
  final String? description;
  final VoucherDiscountType discountType;
  final double discountValue;
  final bool isActive;
  final int? maxQuota;
  final int usedCount;
  final int? validFrom;
  final int? validUntil;
  final int createdAt;
  final int updatedAt;

  const VoucherModel({
    required this.code,
    required this.channel,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.isActive = true,
    this.maxQuota,
    this.usedCount = 0,
    this.validFrom,
    this.validUntil,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Menghitung besar potongan harga dalam Rupiah dari harga default
  double calculateDiscountCut(PricingConfig pricing) {
    final basis = pricing.defaultPrice;
    if (discountType == VoucherDiscountType.percent) {
      return (basis * (discountValue / 100.0)).roundToDouble();
    }
    return discountValue;
  }

  /// Menghitung harga akhir yang harus dibayar setelah pemotongan
  double calculateFinalPrice(PricingConfig pricing) {
    final basis = pricing.defaultPrice;
    final cut = calculateDiscountCut(pricing);
    final rawFinal = basis - cut;
    if (rawFinal < pricing.minAllowedPrice) {
      return pricing.minAllowedPrice;
    }
    return rawFinal;
  }

  bool get isExpired {
    if (validUntil == null) return false;
    return DateTime.now().millisecondsSinceEpoch > validUntil!;
  }

  bool get isNotYetStarted {
    if (validFrom == null) return false;
    return DateTime.now().millisecondsSinceEpoch < validFrom!;
  }

  bool get isQuotaReached {
    if (maxQuota == null) return false;
    return usedCount >= maxQuota!;
  }

  bool get isCurrentlyUsable => isActive && !isExpired && !isNotYetStarted && !isQuotaReached;

  factory VoucherModel.fromFirestoreMap(Map<String, dynamic> map, {String? docId}) {
    final codeVal = (map['code'] as String?) ?? docId ?? '';
    return VoucherModel(
      code: codeVal.toUpperCase().trim(),
      channel: (map['channel'] as String?) ?? 'organic',
      description: map['description'] as String?,
      discountType: VoucherDiscountType.fromCode(map['discountType'] as String?),
      discountValue: (map['discountValue'] as num?)?.toDouble() ?? 0.0,
      isActive: (map['isActive'] as bool?) ?? true,
      maxQuota: (map['maxQuota'] as num?)?.toInt(),
      usedCount: (map['usedCount'] as num?)?.toInt() ?? 0,
      validFrom: (map['validFrom'] as num?)?.toInt(),
      validUntil: (map['validUntil'] as num?)?.toInt(),
      createdAt: (map['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: (map['updatedAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'code': code.toUpperCase().trim(),
      'channel': channel.trim().toLowerCase(),
      'description': description?.trim(),
      'discountType': discountType.code,
      'discountValue': discountValue.toInt(),
      'isActive': isActive,
      'maxQuota': maxQuota,
      'usedCount': usedCount,
      'validFrom': validFrom,
      'validUntil': validUntil,
      'createdAt': createdAt,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  VoucherModel copyWith({
    String? code,
    String? channel,
    String? description,
    VoucherDiscountType? discountType,
    double? discountValue,
    bool? isActive,
    int? maxQuota,
    bool clearMaxQuota = false,
    int? usedCount,
    int? validFrom,
    int? validUntil,
    bool clearValidUntil = false,
    int? createdAt,
    int? updatedAt,
  }) {
    return VoucherModel(
      code: code ?? this.code,
      channel: channel ?? this.channel,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      isActive: isActive ?? this.isActive,
      maxQuota: clearMaxQuota ? null : (maxQuota ?? this.maxQuota),
      usedCount: usedCount ?? this.usedCount,
      validFrom: validFrom ?? this.validFrom,
      validUntil: clearValidUntil ? null : (validUntil ?? this.validUntil),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Model log transaksi lunas yang menggunakan voucher (`voucher_redemptions/{orderId}`)
class VoucherRedemptionLog {
  final String orderId;
  final String userId;
  final String userEmail;
  final String voucherCode;
  final String channel;
  final double basePrice;
  final double discountAmount;
  final double paidAmount;
  final String paymentType;
  final int redeemedAt;

  const VoucherRedemptionLog({
    required this.orderId,
    required this.userId,
    required this.userEmail,
    required this.voucherCode,
    required this.channel,
    required this.basePrice,
    required this.discountAmount,
    required this.paidAmount,
    required this.paymentType,
    required this.redeemedAt,
  });

  factory VoucherRedemptionLog.fromFirestoreMap(Map<String, dynamic> map, {String? docId}) {
    return VoucherRedemptionLog(
      orderId: (map['orderId'] as String?) ?? docId ?? '',
      userId: (map['userId'] as String?) ?? '',
      userEmail: (map['userEmail'] as String?) ?? '-',
      voucherCode: (map['voucherCode'] as String?) ?? '',
      channel: (map['channel'] as String?) ?? 'organic',
      basePrice: (map['basePrice'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (map['discountAmount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (map['paidAmount'] as num?)?.toDouble() ?? 0.0,
      paymentType: (map['paymentType'] as String?) ?? 'qris',
      redeemedAt: (map['redeemedAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

/// Hasil validasi voucher dari endpoint `/api/validate-voucher`
class VoucherValidationResult {
  final bool valid;
  final String? code;
  final String? channel;
  final double basePrice;
  final double discountAmount;
  final double finalPrice;
  final String message;

  const VoucherValidationResult({
    required this.valid,
    this.code,
    this.channel,
    this.basePrice = BusinessConfig.lifetimePrice,
    this.discountAmount = 0.0,
    this.finalPrice = BusinessConfig.lifetimePrice,
    required this.message,
  });

  factory VoucherValidationResult.fromJson(Map<String, dynamic> json) {
    return VoucherValidationResult(
      valid: json['valid'] == true,
      code: json['code'] as String?,
      channel: json['channel'] as String?,
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? BusinessConfig.lifetimePrice,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? BusinessConfig.lifetimePrice,
      message: (json['message'] as String?) ?? (json['valid'] == true ? 'Voucher berhasil diterapkan!' : 'Kode promo tidak berlaku.'),
    );
  }
}
