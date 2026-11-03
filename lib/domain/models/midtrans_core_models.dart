import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// Pilihan Channel Pembayaran Midtrans Core API & Snap
enum PaymentChannel {
  qris(
    id: 'qris',
    name: 'QRIS',
    subtitle: 'Semua Bank & E-Wallet',
    icon: PhosphorIconsRegular.qrCode,
    badge: 'SEGERA HADIR',
    badgeColor: Color(0xFFE65100),
    isAvailable: false,
  ),
  mandiriBill(
    id: 'mandiri_bill',
    name: 'Mandiri Bill Payment',
    subtitle: 'Virtual Account',
    icon: PhosphorIconsRegular.bank,
    badge: 'OTOMATIS 24 JAM',
    badgeColor: Color(0xFF00695C),
    isAvailable: true,
  ),
  briVa(
    id: 'bri_va',
    name: 'BRI Virtual Account',
    subtitle: 'Virtual Account',
    icon: PhosphorIconsRegular.bank,
    badge: 'OTOMATIS 24 JAM',
    badgeColor: Color(0xFF0277BD),
    isAvailable: true,
  ),
  bniVa(
    id: 'bni_va',
    name: 'BNI Virtual Account',
    subtitle: 'Virtual Account',
    icon: PhosphorIconsRegular.bank,
    badge: 'OTOMATIS 24 JAM',
    badgeColor: Color(0xFFD84315),
    isAvailable: true,
  ),
  permataVa(
    id: 'permata_va',
    name: 'Permata Virtual Account',
    subtitle: 'Virtual Account',
    icon: PhosphorIconsRegular.bank,
    badge: 'OTOMATIS 24 JAM',
    badgeColor: Color(0xFF4527A0),
    isAvailable: true,
  ),
  cimbVa(
    id: 'cimb_va',
    name: 'CIMB Niaga Virtual Account',
    subtitle: 'Virtual Account',
    icon: PhosphorIconsRegular.bank,
    badge: 'OTOMATIS 24 JAM',
    badgeColor: Color(0xFF880E4F),
    isAvailable: true,
  ),
  bsiVa(
    id: 'bsi_va',
    name: 'BSI Virtual Account',
    subtitle: 'Virtual Account',
    icon: PhosphorIconsRegular.bank,
    badge: 'SEGERA HADIR',
    badgeColor: Color(0xFF00796B),
    isAvailable: false,
  ),
  gopay(
    id: 'gopay',
    name: 'GoPay / Gojek',
    subtitle: 'Instan 1-Ketuk',
    icon: PhosphorIconsRegular.wallet,
    badge: 'DEEPLINK',
    badgeColor: Color(0xFF00838F),
    isAvailable: true,
  ),
  bcaVa(
    id: 'bca_va',
    name: 'BCA Virtual Account',
    subtitle: 'Virtual Account',
    icon: PhosphorIconsRegular.bank,
    badge: 'SEGERA HADIR',
    badgeColor: Color(0xFF757575),
    isAvailable: false,
  ),
  shopeepay(
    id: 'shopeepay',
    name: 'ShopeePay',
    subtitle: 'E-Wallet',
    icon: PhosphorIconsRegular.bag,
    badge: 'SEGERA HADIR',
    badgeColor: Color(0xFFE65100),
    isAvailable: false,
  );

  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final String badge;
  final Color badgeColor;
  final bool isAvailable;

  const PaymentChannel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.badge,
    required this.badgeColor,
    this.isAvailable = true,
  });

  static PaymentChannel fromId(String id) {
    return PaymentChannel.values.firstWhere(
      (c) => c.id == id,
      orElse: () => PaymentChannel.qris,
    );
  }
}

/// Status Transaksi Midtrans
enum MidtransTransactionStatus {
  pending('Menunggu Pembayaran', Colors.orange),
  settlement('Pembayaran Berhasil', Color(0xFF2E7D32)),
  capture('Pembayaran Berhasil', Color(0xFF2E7D32)),
  expire('Kadaluarsa', Colors.red),
  cancel('Dibatalkan', Colors.grey),
  deny('Ditolak', Colors.red),
  unknown('Status Tidak Diketahui', Colors.grey);

  final String label;
  final Color color;

  const MidtransTransactionStatus(this.label, this.color);

  bool get isSuccess => this == settlement || this == capture;
  bool get isPending => this == pending;
  bool get isFailed => this == expire || this == cancel || this == deny;

  static MidtransTransactionStatus fromString(String? status) {
    if (status == null) return unknown;
    switch (status.toLowerCase()) {
      case 'pending':
        return pending;
      case 'settlement':
        return settlement;
      case 'capture':
        return capture;
      case 'expire':
        return expire;
      case 'cancel':
        return cancel;
      case 'deny':
        return deny;
      default:
        return unknown;
    }
  }
}

/// Data Respons Charge Midtrans Core API
class MidtransChargeData {
  final String orderId;
  final String? transactionId;
  final PaymentChannel channel;
  final double grossAmount;
  final MidtransTransactionStatus status;
  final String? vaNumber;
  final String? bankName;
  final String? billerCode;
  final String? billKey;
  final String? qrCodeUrl;
  final String? qrString;
  final String? deeplinkUrl;
  final DateTime? expiryTime;
  final Map<String, dynamic> rawResponse;

  const MidtransChargeData({
    required this.orderId,
    this.transactionId,
    required this.channel,
    required this.grossAmount,
    required this.status,
    this.vaNumber,
    this.bankName,
    this.billerCode,
    this.billKey,
    this.qrCodeUrl,
    this.qrString,
    this.deeplinkUrl,
    this.expiryTime,
    required this.rawResponse,
  });

  factory MidtransChargeData.fromMidtransJson(
    Map<String, dynamic> json, {
    required PaymentChannel channel,
    required String fallbackOrderId,
    required double fallbackAmount,
  }) {
    final orderId = json['order_id'] as String? ?? fallbackOrderId;
    final transactionId = json['transaction_id'] as String?;
    final rawStatus = json['transaction_status'] as String? ?? 'pending';
    final status = MidtransTransactionStatus.fromString(rawStatus);

    double amount = fallbackAmount;
    if (json['gross_amount'] != null) {
      amount = double.tryParse(json['gross_amount'].toString()) ?? fallbackAmount;
    }

    // Parse VA Number
    String? vaNum;
    String? bank;
    if (json['va_numbers'] is List && (json['va_numbers'] as List).isNotEmpty) {
      final firstVa = (json['va_numbers'] as List).first as Map<String, dynamic>;
      vaNum = firstVa['va_number'] as String?;
      bank = (firstVa['bank'] as String?)?.toUpperCase();
    } else if (json['permata_va_number'] != null) {
      vaNum = json['permata_va_number'] as String?;
      bank = 'PERMATA';
    }

    // Parse Mandiri Bill
    final billerCode = json['biller_code'] as String?;
    final billKey = json['bill_key'] as String?;

    // Parse QRIS actions
    String? qrUrl;
    String? qrStr = json['qr_string'] as String?;
    String? deepUrl;

    if (json['actions'] is List) {
      final actions = json['actions'] as List;
      for (final a in actions) {
        if (a is Map<String, dynamic>) {
          final name = a['name'] as String?;
          final url = a['url'] as String?;
          if (name == 'generate-qr-code' && url != null) {
            qrUrl = url;
          } else if ((name == 'deeplink-redirect' || name == 'deeplink') && url != null) {
            deepUrl = url;
          }
        }
      }
    }

    // Parse Expiry Time
    DateTime? expDate;
    final expStr = json['expiry_time'] as String?;
    if (expStr != null) {
      expDate = DateTime.tryParse(expStr.replaceAll(' ', 'T'));
    }
    expDate ??= DateTime.now().add(const Duration(hours: 24));

    return MidtransChargeData(
      orderId: orderId,
      transactionId: transactionId,
      channel: channel,
      grossAmount: amount,
      status: status,
      vaNumber: vaNum,
      bankName: bank,
      billerCode: billerCode,
      billKey: billKey,
      qrCodeUrl: qrUrl,
      qrString: qrStr,
      deeplinkUrl: deepUrl,
      expiryTime: expDate,
      rawResponse: json,
    );
  }
}
