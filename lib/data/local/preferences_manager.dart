import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kPrefHasSeenWelcome = 'has_seen_welcome';
const String kPrefHasSkippedLogin = 'has_skipped_login';
const String kPrefIsDemoMode = 'is_demo_mode';
const String kPrefUserEmail = 'user_email';
const String kPrefUserId = 'user_id';
const String kPrefAccessLevel = 'user_access_level';
const String kPrefActiveProfileId = 'active_profile_id';
const String kPrefIdToken = 'user_id_token';

class AppPreferences {
  static Future<String> getAccessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kPrefAccessLevel) ?? 'NONE';
  }

  static Future<void> setAccessLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefAccessLevel, level);
  }
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

  static Future<bool> isDemoMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kPrefIsDemoMode) ?? false;
  }

  static Future<void> setDemoMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefIsDemoMode, val);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kPrefUserId);
  }

  static Future<void> setUserId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id != null) {
      await prefs.setString(kPrefUserId, id);
    } else {
      await prefs.remove(kPrefUserId);
    }
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

  static Future<String?> getIdToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kPrefIdToken);
  }

  static Future<void> setIdToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null && token.isNotEmpty) {
      await prefs.setString(kPrefIdToken, token);
    } else {
      await prefs.remove(kPrefIdToken);
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

  static Future<String?> getUserProfileId(String? userId) async {
    if (userId == null || userId.isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_profile_id_$userId');
  }

  static Future<void> setUserProfileId(String? userId, String? profileId) async {
    if (userId == null || userId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    if (profileId != null && profileId.isNotEmpty) {
      await prefs.setString('user_profile_id_$userId', profileId);
    } else {
      await prefs.remove('user_profile_id_$userId');
    }
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
