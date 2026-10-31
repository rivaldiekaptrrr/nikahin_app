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

/// Pilihan palet warna aksen & kanvas pernikahan
enum WeddingPalette {
  champagneGold,
  sageGreen,
  roseGold,
  royalNavy,
  lavender;

  String get displayName {
    switch (this) {
      case WeddingPalette.champagneGold:
        return 'Warm Champagne';
      case WeddingPalette.sageGreen:
        return 'Botanical Sage';
      case WeddingPalette.roseGold:
        return 'Blush Romance';
      case WeddingPalette.royalNavy:
        return 'Midnight Sapphire';
      case WeddingPalette.lavender:
        return 'Royal Lavender';
    }
  }

  String get label => displayName;

  String get description {
    switch (this) {
      case WeddingPalette.champagneGold:
        return 'Hangat, intim & klasik';
      case WeddingPalette.sageGreen:
        return 'Asri, sejuk & alami';
      case WeddingPalette.roseGold:
        return 'Anggun, manis & romantis';
      case WeddingPalette.royalNavy:
        return 'Mewah, elegan & modern';
      case WeddingPalette.lavender:
        return 'Lembut, damai & artistik';
    }
  }

  Color get primaryPreview {
    switch (this) {
      case WeddingPalette.champagneGold:
        return const Color(0xFFD97757); // Warm Terracotta / Coral
      case WeddingPalette.sageGreen:
        return const Color(0xFF2E6F52);
      case WeddingPalette.roseGold:
        return const Color(0xFFD81B60);
      case WeddingPalette.royalNavy:
        return const Color(0xFF1D4ED8);
      case WeddingPalette.lavender:
        return const Color(0xFF7C3AED);
    }
  }

  Color get secondaryPreview {
    switch (this) {
      case WeddingPalette.champagneGold:
        return const Color(0xFFFAF6F0);
      case WeddingPalette.sageGreen:
        return const Color(0xFFF2F6F3);
      case WeddingPalette.roseGold:
        return const Color(0xFFFAF3F5);
      case WeddingPalette.royalNavy:
        return const Color(0xFFF2F5F9);
      case WeddingPalette.lavender:
        return const Color(0xFFF6F4FA);
    }
  }

  /// Warna kanvas latar belakang (Light Mode)
  Color get canvasLight {
    switch (this) {
      case WeddingPalette.champagneGold:
        return const Color(0xFFFAF6F0);
      case WeddingPalette.sageGreen:
        return const Color(0xFFF2F6F3);
      case WeddingPalette.roseGold:
        return const Color(0xFFFAF3F5);
      case WeddingPalette.royalNavy:
        return const Color(0xFFF2F5F9);
      case WeddingPalette.lavender:
        return const Color(0xFFF6F4FA);
    }
  }

  /// Warna kanvas latar belakang (Dark Mode)
  Color get canvasDark {
    switch (this) {
      case WeddingPalette.champagneGold:
        return const Color(0xFF1A1715);
      case WeddingPalette.sageGreen:
        return const Color(0xFF121815);
      case WeddingPalette.roseGold:
        return const Color(0xFF1A1316);
      case WeddingPalette.royalNavy:
        return const Color(0xFF0F1420);
      case WeddingPalette.lavender:
        return const Color(0xFF16131F);
    }
  }

  /// Warna kontainer kartu Bento (Light Mode)
  Color get surfaceContainerLight {
    switch (this) {
      case WeddingPalette.champagneGold:
        return const Color(0xFFF3EDE4);
      case WeddingPalette.sageGreen:
        return const Color(0xFFE5EDE7);
      case WeddingPalette.roseGold:
        return const Color(0xFFF3E5E9);
      case WeddingPalette.royalNavy:
        return const Color(0xFFE2E9F4);
      case WeddingPalette.lavender:
        return const Color(0xFFECE6F6);
    }
  }

  /// Warna kontainer kartu Bento (Dark Mode)
  Color get surfaceContainerDark {
    switch (this) {
      case WeddingPalette.champagneGold:
        return const Color(0xFF28231F);
      case WeddingPalette.sageGreen:
        return const Color(0xFF1C2621);
      case WeddingPalette.roseGold:
        return const Color(0xFF2A1F24);
      case WeddingPalette.royalNavy:
        return const Color(0xFF1B2438);
      case WeddingPalette.lavender:
        return const Color(0xFF231E30);
    }
  }
}

const String kPrefWeddingPalette = 'wedding_accent_palette';

class WeddingPaletteNotifier extends Notifier<WeddingPalette> {
  @override
  WeddingPalette build() {
    _loadPersistedPalette();
    return WeddingPalette.champagneGold;
  }

  Future<void> _loadPersistedPalette() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(kPrefWeddingPalette);
      if (name != null) {
        state = WeddingPalette.values.firstWhere(
          (p) => p.name == name,
          orElse: () => WeddingPalette.champagneGold,
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

/// State Controller untuk sakelar on/off wallpaper motif doodle
const String kPrefDoodlePatternEnabled = 'wedding_doodle_pattern_enabled';

class DoodlePatternNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadPersisted();
    return true;
  }

  Future<void> _loadPersisted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final val = prefs.getBool(kPrefDoodlePatternEnabled);
      if (val != null) {
        state = val;
      }
    } catch (_) {}
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kPrefDoodlePatternEnabled, enabled);
    } catch (_) {}
  }
}

final doodlePatternEnabledProvider =
    NotifierProvider<DoodlePatternNotifier, bool>(
  DoodlePatternNotifier.new,
);
