import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:nikahin_app/shared/utils/error_handler.dart';

void main() {
  group('AppErrorHandler & AppException Tests', () {
    test('SocketException maps to networkError', () {
      const socketEx = SocketException('Failed host lookup');
      final appEx = AppErrorHandler.parse(socketEx);
      expect(appEx.type, AppErrorType.networkError);
      expect(appEx.message, contains('Tidak ada koneksi internet'));
    });

    test('TimeoutException maps to timeout', () {
      final timeoutEx = TimeoutException('Connection timed out');
      final appEx = AppErrorHandler.parse(timeoutEx);
      expect(appEx.type, AppErrorType.timeout);
      expect(appEx.message, contains('terlalu lama'));
    });

    test('FormatException maps to validationError', () {
      const formatEx = FormatException('Invalid JSON');
      final appEx = AppErrorHandler.parse(formatEx);
      expect(appEx.type, AppErrorType.validationError);
    });

    test('PlatformException permission denied maps to permissionError', () {
      final platformEx = PlatformException(code: 'PERMISSION_DENIED', message: 'Storage access denied');
      final appEx = AppErrorHandler.parse(platformEx);
      expect(appEx.type, AppErrorType.permissionError);
    });

    test('HTTP 401 error string maps to authError', () {
      final authError = Exception('HTTP 401 Unauthorized: token expired');
      final appEx = AppErrorHandler.parse(authError);
      expect(appEx.type, AppErrorType.authError);
    });

    test('HTTP 500 error string maps to serverError', () {
      final serverError = Exception('HTTP 500 Internal server error');
      final appEx = AppErrorHandler.parse(serverError);
      expect(appEx.type, AppErrorType.serverError);
    });

    test('Unknown error maps to unknownError', () {
      final randomError = Exception('Some strange error');
      final appEx = AppErrorHandler.parse(randomError);
      expect(appEx.type, AppErrorType.unknownError);
      expect(appEx.message, contains('Terjadi kendala tak terduga'));
    });
  });
}