import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kPrefHasSeenWelcome = 'has_seen_welcome';
const String kPrefHasSkippedLogin = 'has_skipped_login';
const String kPrefUserEmail = 'user_email';
const String kPrefActiveProfileId = 'active_profile_id';

class AppPreferences {
  static Future<bool> hasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kPrefHasSeenWelcome) ?? false;
  }

  static Future<void> setHasSeenWelcome(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefHasSeenWelcome, val);
  }

  static Future<bool> hasSkippedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kPrefHasSkippedLogin) ?? false;
  }

  static Future<void> setHasSkippedLogin(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefHasSkippedLogin, val);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kPrefUserEmail);
  }

  static Future<void> setUserEmail(String? email) async {
    final prefs = await SharedPreferences.getInstance();
    if (email != null) {
      await prefs.setString(kPrefUserEmail, email);
    } else {
      await prefs.remove(kPrefUserEmail);
    }
  }

  static Future<String> getActiveProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kPrefActiveProfileId) ?? 'profile_rivaldi_alya';
  }

  static Future<void> setActiveProfileId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefActiveProfileId, id);
  }

  static Future<bool> isDailyReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('wedding_daily_reminder') ?? true;
  }

  static Future<void> setDailyReminderEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wedding_daily_reminder', val);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('wedding_biometric_lock') ?? false;
  }

  static Future<void> setBiometricEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wedding_biometric_lock', val);
  }
}

class UserEmailNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  @override
  set state(String? value) => super.state = value;

  void setEmail(String? email) => state = email;
}

final userEmailProvider =
    NotifierProvider<UserEmailNotifier, String?>(UserEmailNotifier.new);
