import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preference key matching Track-app PreferencesManager.THEME_MODE
const String kPrefThemeMode = 'theme_mode';

/// Theme Controller managing application theme mode (System, Light, Dark)
/// Persistent via SharedPreferences
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadPersistedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadPersistedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeIndex = prefs.getInt(kPrefThemeMode);
      if (modeIndex != null) {
        switch (modeIndex) {
          case 1:
            state = ThemeMode.light;
            break;
          case 2:
            state = ThemeMode.dark;
            break;
          default:
            state = ThemeMode.system;
            break;
        }
      }
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      int modeIndex = 0;
      if (mode == ThemeMode.light) {
        modeIndex = 1;
      } else if (mode == ThemeMode.dark) {
        modeIndex = 2;
      }
      await prefs.setInt(kPrefThemeMode, modeIndex);
    } catch (_) {}
  }
}

/// Provider to access and observe theme mode across the app
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
