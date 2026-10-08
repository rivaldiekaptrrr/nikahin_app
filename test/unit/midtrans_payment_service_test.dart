import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nikahin_app/data/remote/midtrans_payment_service.dart';
import 'package:nikahin_app/domain/models/midtrans_core_models.dart';

void main() {
  group('MidtransPaymentService Unit Tests', () {
    test('createSnapTransaction returns success result on 200 response', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, equals('POST'));
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['userId'], equals('user_123'));
        expect(body['email'], equals('buyer@test.com'));
        expect(body['accessLevel'], equals('WEDDING'));

        return http.Response(
          jsonEncode({
            'token': 'SNAP-TOKEN-12345',
            'redirect_url': 'https://app.sandbox.midtrans.com/snap/v2/vtweb/SNAP-TOKEN-12345',
            'orderId': 'ORDER-NIKAHIN-123',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = MidtransPaymentService(client: mockClient);
      final result = await service.createSnapTransaction(
        userId: 'user_123',
        email: 'buyer@test.com',
      );

      expect(result, isA<MidtransPaymentSuccess>());
      final success = result as MidtransPaymentSuccess;
      expect(success.token, equals('SNAP-TOKEN-12345'));
      expect(success.redirectUrl, contains('https://app.sandbox.midtrans.com'));
      expect(success.orderId, equals('ORDER-NIKAHIN-123'));
    });

    test('createSnapTransaction returns error result on HTTP 500 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'Midtrans Server Error',
            'details': 'Transaction amount is too small',
          }),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = MidtransPaymentService(client: mockClient);
      final result = await service.createSnapTransaction(
        userId: 'user_456',
        email: 'error@test.com',
      );

      expect(result, isA<MidtransPaymentError>());
      final error = result as MidtransPaymentError;
      expect(error.message, contains('Midtrans Server Error'));
      expect(error.message, contains('Transaction amount is too small'));
    });

    test('chargeCoreApi for BCA Virtual Account parses VA number and status correctly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'status_code': '201',
            'status_message': 'Success, Bank Transfer transaction is created',
            'transaction_id': 'trx-bca-001',
            'order_id': 'NIKAHIN-CORE-BCA-123',
            'gross_amount': '49000.00',
            'payment_type': 'bank_transfer',
            'transaction_status': 'pending',
            'va_numbers': [
              {'bank': 'bca', 'va_number': '7001081234567890'}
            ],
            'expiry_time': '2026-10-09 20:30:00'
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = MidtransPaymentService(client: mockClient);
      final result = await service.chargeCoreApi(
        channel: PaymentChannel.bcaVa,
        userId: 'user_bca',
        email: 'bca@nikahin.app',
        customerName: 'Budi Santoso',
      );

      expect(result, isA<MidtransCoreChargeSuccess>());
      final success = result as MidtransCoreChargeSuccess;
      expect(success.data.channel, equals(PaymentChannel.bcaVa));
      expect(success.data.vaNumber, equals('7001081234567890'));
      expect(success.data.grossAmount, equals(49000.0));
      expect(success.data.status, equals(MidtransTransactionStatus.pending));
    });

    test('chargeCoreApi for QRIS parses QR URL and string properly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'status_code': '201',
            'status_message': 'Success, QRIS transaction is created',
            'transaction_id': 'trx-qris-002',
            'order_id': 'NIKAHIN-CORE-QRIS-456',
            'gross_amount': '49000.00',
            'payment_type': 'qris',
            'transaction_status': 'pending',
            'actions': [
              {
                'name': 'generate-qr-code',
                'method': 'GET',
                'url': 'https://api.sandbox.midtrans.com/v2/qris/sample.png'
              }
            ],
            'qr_string': '00020101021226590014ID.LINKAJA.WWW...',
            'expiry_time': '2026-10-08 21:00:00'
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = MidtransPaymentService(client: mockClient);
      final result = await service.chargeCoreApi(
        channel: PaymentChannel.qris,
        userId: 'user_qris',
        email: 'qris@nikahin.app',
        customerName: 'Alya Putri',
      );

      expect(result, isA<MidtransCoreChargeSuccess>());
      final success = result as MidtransCoreChargeSuccess;
      expect(success.data.channel, equals(PaymentChannel.qris));
      expect(success.data.qrCodeUrl, equals('https://api.sandbox.midtrans.com/v2/qris/sample.png'));
      expect(success.data.qrString, contains('00020101021226590014'));
    });

    test('checkCoreApiStatus detects settlement success', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'status_code': '200',
            'transaction_status': 'settlement',
            'order_id': 'ORDER-123',
            'gross_amount': '49000.00',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = MidtransPaymentService(client: mockClient);
      final status = await service.checkCoreApiStatus('ORDER-123');

      expect(status, equals(MidtransTransactionStatus.settlement));
      expect(status.isSuccess, isTrue);
    });
  });
}
