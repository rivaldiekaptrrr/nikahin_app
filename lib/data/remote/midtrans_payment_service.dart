import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../app/config/business_config.dart';
import '../../domain/models/midtrans_core_models.dart';

/// Hasil transaksi pembuatan token Midtrans Snap
sealed class MidtransPaymentResult {
  const MidtransPaymentResult();

  const factory MidtransPaymentResult.success({
    required String token,
    required String redirectUrl,
    required String orderId,
  }) = MidtransPaymentSuccess;

  const factory MidtransPaymentResult.error({
    required String message,
  }) = MidtransPaymentError;
}

class MidtransPaymentSuccess extends MidtransPaymentResult {
  final String token;
  final String redirectUrl;
  final String orderId;

  const MidtransPaymentSuccess({
    required this.token,
    required this.redirectUrl,
    required this.orderId,
  });
}

class MidtransPaymentError extends MidtransPaymentResult {
  final String message;

  const MidtransPaymentError({required this.message});
}

/// Hasil eksekusi Midtrans Core API Direct Charge
sealed class MidtransCoreChargeResult {
  const MidtransCoreChargeResult();

  const factory MidtransCoreChargeResult.success({
    required MidtransChargeData data,
  }) = MidtransCoreChargeSuccess;

  const factory MidtransCoreChargeResult.error({
    required String message,
  }) = MidtransCoreChargeError;
}

class MidtransCoreChargeSuccess extends MidtransCoreChargeResult {
  final MidtransChargeData data;

  const MidtransCoreChargeSuccess({required this.data});
}

class MidtransCoreChargeError extends MidtransCoreChargeResult {
  final String message;

  const MidtransCoreChargeError({required this.message});
}

/// Service untuk memproses transaksi Midtrans Core API & Snap
class MidtransPaymentService {
  final http.Client _client;

  MidtransPaymentService({http.Client? client}) : _client = client ?? http.Client();

  /// Server Key Midtrans
  String get _serverKey => BusinessConfig.midtransServerKey;

  /// Base URL Core API (Sandbox vs Production)
  String get _coreApiBaseUrl => BusinessConfig.isProduction
      ? 'https://api.midtrans.com/v2'
      : 'https://api.sandbox.midtrans.com/v2';

  /// Headers untuk otentikasi Midtrans Core API
  Map<String, String> get _coreHeaders {
    final basicAuth = base64Encode(utf8.encode('$_serverKey:'));
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'Authorization': 'Basic $basicAuth',
    };
  }

  /// Eksekusi Charge Midtrans Core API Langsung (100% Native Custom UI)
  Future<MidtransCoreChargeResult> chargeCoreApi({
    required PaymentChannel channel,
    required String userId,
    required String email,
    required String customerName,
    double amount = BusinessConfig.lifetimePrice,
  }) async {
    final orderId = 'NIKAHIN-CORE-${userId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').substring(0, userId.length > 5 ? 5 : userId.length).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}';

    // 1. Coba panggil via Vercel Backend jika endpoint charge tersedia
    try {
      final backendUri = Uri.parse(BusinessConfig.midtransCoreChargeBackendUrl);
      final backendPayload = jsonEncode({
        'channel': channel.id,
        'orderId': orderId,
        'userId': userId,
        'email': email,
        'customerName': customerName,
        'amount': amount.toInt(),
        'appName': 'nikahin',
      });

      final res = await _client
          .post(
            backendUri,
            headers: {'Content-Type': 'application/json'},
            body: backendPayload,
          )
          .timeout(const Duration(seconds: 12));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final chargeData = MidtransChargeData.fromMidtransJson(
          json,
          channel: channel,
          fallbackOrderId: orderId,
          fallbackAmount: amount,
        );
        return MidtransCoreChargeResult.success(data: chargeData);
      }
    } catch (_) {
      // Fallback ke direct Midtrans API call
    }

      // 2. Direct Midtrans Core API Request (Coba Sandbox lalu Production jika 401)
      final primaryUrl = _coreApiBaseUrl;
      final alternateUrl = primaryUrl.contains('sandbox')
          ? 'https://api.midtrans.com/v2'
          : 'https://api.sandbox.midtrans.com/v2';

      http.Response response;
      try {
        final uri = Uri.parse('$primaryUrl/charge');
        final payload = _buildCoreChargePayload(
          channel: channel,
          orderId: orderId,
          amount: amount,
          email: email,
          customerName: customerName,
          userId: userId,
        );

        response = await _client
            .post(
              uri,
              headers: _coreHeaders,
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 15));

        // Jika 401, coba URL alternatif (Sandbox vs Production)
        if (response.statusCode == 401) {
          final altUri = Uri.parse('$alternateUrl/charge');
          final altResponse = await _client
              .post(
                altUri,
                headers: _coreHeaders,
                body: jsonEncode(payload),
              )
              .timeout(const Duration(seconds: 15));
          if (altResponse.statusCode >= 200 && altResponse.statusCode < 300) {
            response = altResponse;
          }
        }
      } catch (netErr) {
        if (_serverKey.contains('YOUR_SANDBOX_KEY')) {
          final mockChargeData = _generateMockInteractiveChargeData(
            channel: channel,
            orderId: orderId,
            amount: amount,
          );
          return MidtransCoreChargeResult.success(data: mockChargeData);
        }
        return MidtransCoreChargeResult.error(
          message: 'Koneksi ke Midtrans gagal: ${netErr.toString().replaceAll('Exception:', '').trim()}',
        );
      }

      final body = response.body;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(body) as Map<String, dynamic>;
        final chargeData = MidtransChargeData.fromMidtransJson(
          json,
          channel: channel,
          fallbackOrderId: orderId,
          fallbackAmount: amount,
        );
        return MidtransCoreChargeResult.success(data: chargeData);
      } else {
        if (_serverKey.contains('YOUR_SANDBOX_KEY')) {
          final mockChargeData = _generateMockInteractiveChargeData(
            channel: channel,
            orderId: orderId,
            amount: amount,
          );
          return MidtransCoreChargeResult.success(data: mockChargeData);
        }

        String errorMsg = 'Gagal memproses pembayaran (HTTP ${response.statusCode})';
        try {
          final errJson = jsonDecode(body) as Map<String, dynamic>;
          errorMsg = errJson['status_message'] as String? ?? errorMsg;
        } catch (_) {}
        return MidtransCoreChargeResult.error(message: errorMsg);
      }
  }

  /// Cek Status Transaksi secara Realtime via Core API (`/v2/{order_id}/status`)
  Future<MidtransTransactionStatus> checkCoreApiStatus(String orderId) async {
    try {
      final uri = Uri.parse('$_coreApiBaseUrl/$orderId/status');
      final response = await _client.get(uri, headers: _coreHeaders).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final rawStatus = json['transaction_status'] as String?;
        return MidtransTransactionStatus.fromString(rawStatus);
      }
    } catch (_) {}
    return MidtransTransactionStatus.pending;
  }

  /// Membangun payload JSON sesuai spesifikasi Midtrans Core API
  Map<String, dynamic> _buildCoreChargePayload({
    required PaymentChannel channel,
    required String orderId,
    required double amount,
    required String email,
    required String customerName,
    required String userId,
  }) {
    final Map<String, dynamic> base = {
      'transaction_details': {
        'order_id': orderId,
        'gross_amount': amount.toInt(),
      },
      'item_details': [
        {
          'id': 'NIKAHIN-LIFETIME',
          'price': amount.toInt(),
          'quantity': 1,
          'name': BusinessConfig.packageName,
        }
      ],
      'customer_details': {
        'first_name': customerName.isNotEmpty ? customerName : 'Pengguna Nikahin',
        'email': email,
      },
      'custom_field1': userId,
      'custom_field2': 'WEDDING',
    };

    switch (channel) {
      case PaymentChannel.qris:
        base['payment_type'] = 'qris';
        base['qris'] = {'acquirer': 'gopay'};
        break;

      case PaymentChannel.bcaVa:
        base['payment_type'] = 'bank_transfer';
        base['bank_transfer'] = {'bank': 'bca'};
        break;

      case PaymentChannel.bniVa:
        base['payment_type'] = 'bank_transfer';
        base['bank_transfer'] = {'bank': 'bni'};
        break;

      case PaymentChannel.briVa:
        base['payment_type'] = 'bank_transfer';
        base['bank_transfer'] = {'bank': 'bri'};
        break;

      case PaymentChannel.mandiriBill:
        base['payment_type'] = 'echannel';
        base['echannel'] = {
          'bill_info1': 'Pembayaran:',
          'bill_info2': 'Nikahin App Lifetime',
        };
        break;

      case PaymentChannel.permataVa:
        base['payment_type'] = 'permata';
        base['bank_transfer'] = {'bank': 'permata'};
        break;

      case PaymentChannel.gopay:
        base['payment_type'] = 'gopay';
        base['gopay'] = {
          'enable_callback': true,
          'callback_url': 'nikahin://payment-finish',
        };
        break;

      case PaymentChannel.shopeepay:
        base['payment_type'] = 'shopeepay';
        base['shopeepay'] = {
          'callback_url': 'nikahin://payment-finish',
        };
        break;
    }

    return base;
  }

  /// Generator data representasi Core API untuk pengujian lokal interaktif Sandbox
  MidtransChargeData _generateMockInteractiveChargeData({
    required PaymentChannel channel,
    required String orderId,
    required double amount,
  }) {
    String? va;
    String? billerCode;
    String? billKey;
    String? qrUrl;
    String? qrStr;
    String? deepUrl;

    final now = DateTime.now();
    final randomSuffix = (now.millisecondsSinceEpoch % 100000000).toString().padLeft(8, '0');

    switch (channel) {
      case PaymentChannel.qris:
        qrUrl = 'https://api.sandbox.midtrans.com/v2/qris/sample-qr.png';
        qrStr = '00020101021226590014ID.LINKAJA.WWW01189360091800000000005204581253033605802ID5913NIKAHIN APP6007JAKARTA61051234062210117NIKAHIN-${randomSuffix}6304C92A';
        break;
      case PaymentChannel.bcaVa:
        va = '7001$randomSuffix';
        break;
      case PaymentChannel.mandiriBill:
        billerCode = '70012';
        billKey = '99$randomSuffix';
        break;
      case PaymentChannel.briVa:
        va = '8888$randomSuffix';
        break;
      case PaymentChannel.bniVa:
        va = '8808$randomSuffix';
        break;
      case PaymentChannel.permataVa:
        va = '8778$randomSuffix';
        break;
      case PaymentChannel.gopay:
        deepUrl = 'https://simulator.sandbox.midtrans.com/gopay/partner/app/payment-pin?id=gopay-$randomSuffix';
        break;
      case PaymentChannel.shopeepay:
        deepUrl = 'https://simulator.sandbox.midtrans.com/shopeepay/partner/app/payment-pin?id=spay-$randomSuffix';
        break;
    }

    return MidtransChargeData(
      orderId: orderId,
      transactionId: 'TRX-$randomSuffix',
      channel: channel,
      grossAmount: amount,
      status: MidtransTransactionStatus.pending,
      vaNumber: va,
      bankName: channel.name,
      billerCode: billerCode,
      billKey: billKey,
      qrCodeUrl: qrUrl,
      qrString: qrStr,
      deeplinkUrl: deepUrl,
      expiryTime: now.add(const Duration(hours: 24)),
      rawResponse: {'status': 'sandbox_mock', 'order_id': orderId},
    );
  }

  /// Membuat transaksi Midtrans Snap (Legacy Fallback)
  Future<MidtransPaymentResult> createSnapTransaction({
    required String userId,
    required String email,
    String accessLevel = BusinessConfig.midtransPackageCode,
  }) async {
    try {
      final uri = Uri.parse(BusinessConfig.midtransBackendUrl);
      final payload = jsonEncode({
        'userId': userId,
        'email': email,
        'accessLevel': accessLevel,
        'appName': 'nikahin',
      });

      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
            body: payload,
          )
          .timeout(const Duration(seconds: 15));

      final body = response.body;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(body) as Map<String, dynamic>;
        final token = data['token'] as String? ?? '';
        final redirectUrl = data['redirect_url'] as String? ?? '';
        final orderId = data['orderId'] as String? ?? '';

        if (token.isNotEmpty && redirectUrl.isNotEmpty) {
          return MidtransPaymentResult.success(
            token: token,
            redirectUrl: redirectUrl,
            orderId: orderId,
          );
        } else {
          return const MidtransPaymentResult.error(
            message: 'Respons dari server pembayaran Midtrans tidak lengkap.',
          );
        }
      } else {
        String errorMsg = 'Gagal memproses pembayaran (HTTP ${response.statusCode})';
        try {
          final errJson = jsonDecode(body) as Map<String, dynamic>;
          final msg = errJson['error'] as String?;
          final details = errJson['details'] as String?;
          if (msg != null && msg.isNotEmpty) {
            errorMsg = details != null && details.isNotEmpty ? '$msg ($details)' : msg;
          }
        } catch (_) {}
        return MidtransPaymentResult.error(message: errorMsg);
      }
    } catch (e) {
      return MidtransPaymentResult.error(
        message: 'Gagal terhubung ke gateway pembayaran: ${e.toString().replaceAll('Exception:', '').trim()}',
      );
    }
  }
}

/// Provider instance untuk MidtransPaymentService
final midtransPaymentServiceProvider = Provider<MidtransPaymentService>((ref) {
  return MidtransPaymentService();
});
