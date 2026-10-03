import 'package:flutter/services.dart';

/// Centralized, robust input validation utilities for Nikahin App
class ValidationUtils {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneIndoRegex = RegExp(
    r'^(\+62|62|08)[0-9]{7,13}$',
  );

  /// Formatter for human names (allows letters, spaces, dots, apostrophes, hyphens, parentheses)
  static TextInputFormatter get nameInputFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s\.\,\'\-\(\)]"));

  /// Formatter for phone numbers
  static TextInputFormatter get phoneInputFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s]'));

  /// Formatter for Instagram handles
  static TextInputFormatter get igHandleInputFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_\.]'));

  /// Validates required text fields (checks null, empty, and whitespace-only)
  static String? validateRequired(String? value, String fieldName, {int minLength = 1}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    if (value.trim().length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    return null;
  }

  /// Validates person or couple name with format check
  static String? validateName(String? value, String fieldName) {
    final requiredCheck = validateRequired(value, fieldName, minLength: 2);
    if (requiredCheck != null) return requiredCheck;

    final trimmed = value!.trim();
    // Ensure name contains at least one alphabetic letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(trimmed)) {
      return '$fieldName harus mengandung huruf alfabet';
    }
    return null;
  }

  /// Validates email address format
  static String? validateEmail(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) return 'Email wajib diisi';
      return null;
    }
    final trimmed = value.trim();
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Format email tidak valid (contoh: user@gmail.com)';
    }
    return null;
  }

  /// Validates password strength & length
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < minLength) {
      return 'Password minimal $minLength karakter';
    }
    return null;
  }

  /// Validates Indonesian phone/WhatsApp numbers
  static String? validatePhoneIndo(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) return 'Nomor WhatsApp / HP wajib diisi';
      return null;
    }
    final clean = value.replaceAll(RegExp(r'[^0-9+]'), '');
    if (clean.length < 9) {
      return 'Nomor telepon terlalu pendek (minimal 9 digit)';
    }
    if (clean.length > 15) {
      return 'Nomor telepon terlalu panjang (maksimal 15 digit)';
    }
    if (!_phoneIndoRegex.hasMatch(clean)) {
      return 'Nomor harus diawali 08, 62, atau +62';
    }
    return null;
  }

  /// Validates URL format (e.g. for product/vendor links)
  static String? validateUrl(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) return 'Tautan URL wajib diisi';
      return null;
    }
    final trimmed = value.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || (!trimmed.startsWith('http://') && !trimmed.startsWith('https://'))) {
      return 'URL harus diawali http:// atau https://';
    }
    return null;
  }

  /// Validates minimum numerical value (pax, quantity, duration, amount)
  static String? validateMinNumber(num? value, num min, String fieldName, {String? unit}) {
    if (value == null) {
      return '$fieldName wajib diisi angka';
    }
    if (value < min) {
      final unitStr = unit != null ? ' $unit' : '';
      return '$fieldName minimal $min$unitStr';
    }
    return null;
  }

  /// Validates that an event or wedding date is not in the past (before today midnight)
  static String? validateFutureOrTodayDate(int? epochMillis, String fieldName) {
    if (epochMillis == null || epochMillis <= 0) {
      return '$fieldName belum dipilih';
    }
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    if (epochMillis < todayMidnight) {
      return '$fieldName tidak boleh di masa lampau';
    }
    return null;
  }
}
