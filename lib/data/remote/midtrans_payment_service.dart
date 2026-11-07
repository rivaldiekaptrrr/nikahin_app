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

  /// Eksekusi Charge Midtrans Core API via Backend Vercel Serverless Function
  /// 100% Zero-Trust: Server Key Midtrans dikelola sepenuhnya di serverless backend Vercel
  Future<MidtransCoreChargeResult> chargeCoreApi({
    required PaymentChannel channel,
    required String userId,
    required String email,
    required String customerName,
    double amount = BusinessConfig.lifetimePrice,
  }) async {
    final orderId = 'NIKAHIN-CORE-${userId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').substring(0, userId.length > 5 ? 5 : userId.length).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}';

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
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: backendPayload,
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final chargeData = MidtransChargeData.fromMidtransJson(
          json,
          channel: channel,
          fallbackOrderId: orderId,
          fallbackAmount: amount,
        );
        return MidtransCoreChargeResult.success(data: chargeData);
      } else {
        try {
          final errJson = jsonDecode(res.body) as Map<String, dynamic>;
          final errMsg = errJson['error'] ??
              errJson['status_message'] ??
              errJson['details'] ??
              'Gagal memproses pembayaran (${res.statusCode})';
          return MidtransCoreChargeResult.error(message: errMsg.toString());
        } catch (_) {
          return MidtransCoreChargeResult.error(
            message: 'Server pembayaran merespons galat (${res.statusCode}).',
          );
        }
      }
    } catch (e) {
      return MidtransCoreChargeResult.error(
        message: 'Tidak dapat terhubung ke server pembayaran. Silakan periksa koneksi internet Anda atau coba beberapa saat lagi.',
      );
    }
  }

  /// Cek Status Transaksi secara Realtime via Backend Vercel Serverless
  Future<MidtransTransactionStatus> checkCoreApiStatus(String orderId) async {
    try {
      final backendBase = BusinessConfig.midtransBackendUrl.replaceAll('/create-snap-token', '');
      final uri = Uri.parse('$backendBase/transaction-status?orderId=$orderId&appName=nikahin');
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final rawStatus = json['transaction_status'] as String?;
        return MidtransTransactionStatus.fromString(rawStatus);
      }
    } catch (_) {}
    return MidtransTransactionStatus.pending;
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
