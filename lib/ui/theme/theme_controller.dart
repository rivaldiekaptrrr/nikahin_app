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
    return ThemeMode.light;
  }

  Future<void> _loadPersistedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeIndex = prefs.getInt(kPrefThemeMode);
      if (modeIndex != null) {
        switch (modeIndex) {
          case 0:
            state = ThemeMode.system;
            break;
          case 1:
            state = ThemeMode.light;
            break;
          case 2:
            state = ThemeMode.dark;
            break;
          default:
            state = ThemeMode.light;
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

/// Pilihan palet warna aksen pernikahan
enum WeddingPalette {
  roseGold,
  sageGreen,
  champagneGold,
  royalNavy,
  lavender;

  String get displayName {
    switch (this) {
      case WeddingPalette.roseGold:
        return 'Rose Gold';
      case WeddingPalette.sageGreen:
        return 'Sage Green';
      case WeddingPalette.champagneGold:
        return 'Champagne';
      case WeddingPalette.royalNavy:
        return 'Royal Navy';
      case WeddingPalette.lavender:
        return 'Lavender';
    }
  }

  String get description {
    switch (this) {
      case WeddingPalette.roseGold:
        return 'Romantis & Hangat';
      case WeddingPalette.sageGreen:
        return 'Botanikal & Alami';
      case WeddingPalette.champagneGold:
        return 'Mewah & Elegan';
      case WeddingPalette.royalNavy:
        return 'Klasik & Modern';
      case WeddingPalette.lavender:
        return 'Anggun & Manis';
    }
  }

  Color get primaryPreview {
    switch (this) {
      case WeddingPalette.roseGold:
        return const Color(0xFFD81B60);
      case WeddingPalette.sageGreen:
        return const Color(0xFF2E6F52);
      case WeddingPalette.champagneGold:
        return const Color(0xFFB45309);
      case WeddingPalette.royalNavy:
        return const Color(0xFF1D4ED8);
      case WeddingPalette.lavender:
        return const Color(0xFF7C3AED);
    }
  }

  Color get secondaryPreview {
    switch (this) {
      case WeddingPalette.roseGold:
        return const Color(0xFFFFD9E2);
      case WeddingPalette.sageGreen:
        return const Color(0xFFD1FAE5);
      case WeddingPalette.champagneGold:
        return const Color(0xFFFEF3C7);
      case WeddingPalette.royalNavy:
        return const Color(0xFFDBEAFE);
      case WeddingPalette.lavender:
        return const Color(0xFFEDE9FE);
    }
  }
}

const String kPrefWeddingPalette = 'wedding_accent_palette';

class WeddingPaletteNotifier extends Notifier<WeddingPalette> {
  @override
  WeddingPalette build() {
    _loadPersistedPalette();
    return WeddingPalette.roseGold;
  }

  Future<void> _loadPersistedPalette() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(kPrefWeddingPalette);
      if (name != null) {
        state = WeddingPalette.values.firstWhere(
          (p) => p.name == name,
          orElse: () => WeddingPalette.roseGold,
        );
      }
    } catch (_) {}
  }

  Future<void> setPalette(WeddingPalette palette) async {
    state = palette;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kPrefWeddingPalette, palette.name);
    } catch (_) {}
  }
}

final weddingPaletteProvider =
    NotifierProvider<WeddingPaletteNotifier, WeddingPalette>(
  WeddingPaletteNotifier.new,
);
