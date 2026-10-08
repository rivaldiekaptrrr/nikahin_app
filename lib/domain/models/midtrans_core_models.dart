import 'package:flutter/material.dart';

/// Pilihan Channel Pembayaran Midtrans Core API
enum PaymentChannel {
  qris(
    id: 'qris',
    name: 'QRIS (Semua Bank & E-Wallet)',
    subtitle: 'BCA, Mandiri, BRI, BNI, GoPay, OVO, Dana, ShopeePay',
    icon: Icons.qr_code_scanner_rounded,
    badge: 'INSTAN & REKOMENDASI',
    badgeColor: Color(0xFF2E7D32),
  ),
  bcaVa(
    id: 'bca_va',
    name: 'BCA Virtual Account',
    subtitle: 'Transfer via BCA Mobile, myBCA, KlikBCA, atau ATM BCA',
    icon: Icons.account_balance_rounded,
    badge: 'OTOMATIS',
    badgeColor: Color(0xFF1565C0),
  ),
  mandiriBill(
    id: 'mandiri_bill',
    name: 'Mandiri Bill Payment',
    subtitle: 'Transfer via Livin\' by Mandiri, ATM, atau Internet Banking',
    icon: Icons.account_balance_rounded,
    badge: 'OTOMATIS',
    badgeColor: Color(0xFF00695C),
  ),
  briVa(
    id: 'bri_va',
    name: 'BRI Virtual Account (BRIVA)',
    subtitle: 'Transfer via BRImo, ATM BRI, atau Internet Banking',
    icon: Icons.account_balance_rounded,
    badge: 'OTOMATIS',
    badgeColor: Color(0xFF0277BD),
  ),
  bniVa(
    id: 'bni_va',
    name: 'BNI Virtual Account',
    subtitle: 'Transfer via BNI Mobile Banking, ATM, atau SMS Banking',
    icon: Icons.account_balance_rounded,
    badge: 'OTOMATIS',
    badgeColor: Color(0xFFD84315),
  ),
  permataVa(
    id: 'permata_va',
    name: 'Permata Virtual Account',
    subtitle: 'Transfer via PermataMobile X, ATM, atau Bank Lain',
    icon: Icons.account_balance_rounded,
    badge: 'OTOMATIS',
    badgeColor: Color(0xFF4527A0),
  ),
  gopay(
    id: 'gopay',
    name: 'GoPay / Gojek',
    subtitle: 'Buka dan bayar langsung di aplikasi Gojek',
    icon: Icons.account_balance_wallet_rounded,
    badge: 'DEEPLINK',
    badgeColor: Color(0xFF00838F),
  ),
  shopeepay(
    id: 'shopeepay',
    name: 'ShopeePay',
    subtitle: 'Buka dan bayar langsung di aplikasi Shopee',
    icon: Icons.shopping_bag_rounded,
    badge: 'DEEPLINK',
    badgeColor: Color(0xFFE65100),
  );

  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final String badge;
  final Color badgeColor;

  const PaymentChannel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.badge,
    required this.badgeColor,
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
