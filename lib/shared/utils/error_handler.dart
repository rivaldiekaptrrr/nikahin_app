import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enum representing standardized error types across Nikahin App
enum AppErrorType {
  success,
  loading,
  empty,
  validationError,
  networkError,
  serverError,
  authError,
  permissionError,
  timeout,
  unknownError,
}

/// Standardized Application Exception with user-facing message & categorization
class AppException implements Exception {
  final String message;
  final AppErrorType type;
  final dynamic originalError;
  final int? statusCode;

  const AppException({
    required this.message,
    this.type = AppErrorType.unknownError,
    this.originalError,
    this.statusCode,
  });

  @override
  String toString() => message;

  IconData get icon {
    switch (type) {
      case AppErrorType.success:
        return Icons.check_circle_rounded;
      case AppErrorType.loading:
        return Icons.hourglass_top_rounded;
      case AppErrorType.empty:
        return Icons.inbox_outlined;
      case AppErrorType.validationError:
        return Icons.rule_rounded;
      case AppErrorType.networkError:
        return Icons.wifi_off_rounded;
      case AppErrorType.serverError:
        return Icons.cloud_off_rounded;
      case AppErrorType.authError:
        return Icons.lock_outline_rounded;
      case AppErrorType.permissionError:
        return Icons.security_rounded;
      case AppErrorType.timeout:
        return Icons.timer_off_outlined;
      case AppErrorType.unknownError:
        return Icons.error_outline_rounded;
    }
  }

  Color get color {
    switch (type) {
      case AppErrorType.success:
        return const Color(0xFF1B5E20);
      case AppErrorType.loading:
        return Colors.blue;
      case AppErrorType.empty:
        return Colors.grey.shade600;
      case AppErrorType.validationError:
        return Colors.orange.shade800;
      case AppErrorType.networkError:
        return Colors.amber.shade900;
      case AppErrorType.serverError:
        return const Color(0xFFB71C1C);
      case AppErrorType.authError:
        return const Color(0xFF881337);
      case AppErrorType.permissionError:
        return Colors.deepPurple;
      case AppErrorType.timeout:
        return Colors.indigo;
      case AppErrorType.unknownError:
        return const Color(0xFFD32F2F);
    }
  }
}

/// Centralized Error Handler to convert raw exceptions into human-friendly messages
class AppErrorHandler {
  static AppException parse(dynamic error) {
    if (error is AppException) return error;

    if (error is SocketException) {
      return AppException(
        message: 'Tidak ada koneksi internet. Mode offline aktif dan data tersimpan lokal.',
        type: AppErrorType.networkError,
        originalError: error,
      );
    }

    if (error is TimeoutException) {
      return AppException(
        message: 'Permintaan memakan waktu terlalu lama. Silakan periksa jaringan Anda dan coba lagi.',
        type: AppErrorType.timeout,
        originalError: error,
      );
    }

    if (error is FormatException) {
      return AppException(
        message: 'Format data tidak valid atau tidak sesuai standar.',
        type: AppErrorType.validationError,
        originalError: error,
      );
    }

    if (error is PlatformException) {
      if (error.code.contains('PERMISSION') || error.code.contains('DENIED')) {
        return AppException(
          message: 'Izin akses perangkat ditolak. Silakan aktifkan izin di pengaturan perangkat.',
          type: AppErrorType.permissionError,
          originalError: error,
        );
      }
      return AppException(
        message: error.message ?? 'Terjadi kendala pada sistem perangkat.',
        type: AppErrorType.unknownError,
        originalError: error,
      );
    }

    if (error is FileSystemException) {
      return AppException(
        message: 'Tidak dapat mengakses penyimpanan file pada perangkat.',
        type: AppErrorType.permissionError,
        originalError: error,
      );
    }

    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('401') || errorStr.contains('unauthorized') || errorStr.contains('auth')) {
      return AppException(
        message: 'Sesi login telah berakhir atau Anda belum memiliki izin masuk.',
        type: AppErrorType.authError,
        originalError: error,
        statusCode: 401,
      );
    }

    if (errorStr.contains('403') || errorStr.contains('forbidden')) {
      return AppException(
        message: 'Akses dibatasi. Anda tidak memiliki izin mengakses data ini.',
        type: AppErrorType.authError,
        originalError: error,
        statusCode: 403,
      );
    }

    if (errorStr.contains('500') || errorStr.contains('502') || errorStr.contains('503') || errorStr.contains('server')) {
      return AppException(
        message: 'Server sedang mengalami gangguan sementara. Data lokal Anda tetap aman.',
        type: AppErrorType.serverError,
        originalError: error,
        statusCode: 500,
      );
    }

    if (errorStr.contains('network') || errorStr.contains('offline') || errorStr.contains('connection')) {
      return AppException(
        message: 'Koneksi jaringan terputus. Silakan coba kembali saat online.',
        type: AppErrorType.networkError,
        originalError: error,
      );
    }

    return AppException(
      message: 'Terjadi kendala tak terduga. Silakan coba lagi beberapa saat lagi.',
      type: AppErrorType.unknownError,
      originalError: error,
    );
  }
}