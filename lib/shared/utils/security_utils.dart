import 'package:flutter/foundation.dart';

/// Security and Privacy Utilities for Nikahin App
class SecurityUtils {
  /// Masks sensitive email addresses (e.g., dimas.arya@example.com -> d***a@example.com)
  static String maskEmail(String? email) {
    if (email == null || email.trim().isEmpty) return '-';
    final trimmed = email.trim();
    final parts = trimmed.split('@');
    if (parts.length != 2) return '***';

    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) {
      return '${name[0]}*@$domain';
    }

    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  /// Masks telephone / WhatsApp numbers for privacy (e.g., 081234567890 -> 0812****7890)
  static String maskPhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) return '-';
    final cleaned = phone.replaceAll(RegExp(r'\s+|-'), '');
    if (cleaned.length < 8) return '****';

    final prefix = cleaned.substring(0, 4);
    final suffix = cleaned.substring(cleaned.length - 4);
    final maskedLength = cleaned.length - 8;
    return '$prefix${'*' * (maskedLength > 0 ? maskedLength : 4)}$suffix';
  }

  /// Masks sensitive financial or token strings in logs to prevent data leakage
  static String sanitizeForLogging(String text) {
    if (!kDebugMode) return '[REDACTED]';
    return text.replaceAll(RegExp(r'(password|token|secret|apiKey)=([^&]+)', caseSensitive: false), r'$1=***');
  }

  /// Sanitizes text input to prevent malicious script/HTML injection
  static String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .trim();
  }

  /// Validates that a backup payload contains safe and structured data
  static bool validateBackupPayload(Map<String, dynamic> data) {
    if (data['format'] != 'NIKAHIN_BACKUP') return false;
    if (data['profile'] is! Map<String, dynamic>) return false;
    final profile = data['profile'] as Map<String, dynamic>;
    if ((profile['id'] as String? ?? '').isEmpty) return false;
    return true;
  }
}
