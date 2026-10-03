import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color.dart';
import 'type.dart';

/// App Theme matching Theme.kt in Track-app
class NikahinTheme {
  // Re-export color tokens for direct access
  static const Color primaryRose = kWeddingPrimaryRose;
  static const Color secondaryRose = kWeddingSecondaryRose;
  static const Color warmCoral = kWeddingWarmCoral;
  static const Color champagneGold = kWeddingChampagneGold;
  static const Color softPinkBg = kWeddingSoftPinkBg;
  static const Color darkCharcoalBg = kWeddingDarkCharcoalBg;
  static const Color darkSurface = kWeddingDarkSurface;

  /// Generate Light ColorScheme
  static ColorScheme lightColorScheme({bool isWeddingMode = true}) {
    if (isWeddingMode) {
      return const ColorScheme(
        brightness: Brightness.light,
        primary: kWeddingPrimaryRose,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFFFD9E2),
        onPrimaryContainer: Color(0xFF3E001D),
        secondary: Color(0xFF9C4146),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFFFD9DA),
        onSecondaryContainer: Color(0xFF40000A),
        tertiary: kWeddingWarmCoral,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFFFDBCF),
        onTertiaryContainer: Color(0xFF380D00),
        error: kErrorLight,
        onError: Colors.white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        surface: kWeddingSoftPinkBg,
        onSurface: Color(0xFF201A1B),
        surfaceContainerHighest: Color(0xFFF2DDE1),
        onSurfaceVariant: Color(0xFF514347),
        outline: Color(0xFF837377),
        outlineVariant: Color(0xFFD5C2C6),
      );
    }

    return const ColorScheme(
      brightness: Brightness.light,
      primary: kPrimaryLight,
      onPrimary: kOnPrimaryLight,
      primaryContainer: kPrimaryContainerLight,
      onPrimaryContainer: kOnPrimaryContainerLight,
      secondary: kSecondaryLight,
      onSecondary: kOnSecondaryLight,
      secondaryContainer: kSecondaryContainerLight,
      onSecondaryContainer: kOnSecondaryContainerLight,
      tertiary: kTertiaryLight,
      onTertiary: kOnTertiaryLight,
      tertiaryContainer: kTertiaryContainerLight,
      onTertiaryContainer: kOnTertiaryContainerLight,
      error: kErrorLight,
      onError: Colors.white,
      surface: kSurfaceLight,
      onSurface: kOnSurfaceLight,
      surfaceContainerHighest: kSurfaceVariantLight,
      onSurfaceVariant: kOnSurfaceVariantLight,
      outline: Color(0xFF94A3B8),
      outlineVariant: Color(0xFFE2E8F0),
    );
  }

  /// Generate Dark ColorScheme
  static ColorScheme darkColorScheme({bool isWeddingMode = true}) {
    if (isWeddingMode) {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFFFB1C8),
        onPrimary: Color(0xFF5E1130),
        primaryContainer: Color(0xFF7B2946),
        onPrimaryContainer: Color(0xFFFFD9E2),
        secondary: Color(0xFFFFB3B6),
        onSecondary: Color(0xFF5F121C),
        secondaryContainer: Color(0xFF7D2933),
        onSecondaryContainer: Color(0xFFFFD9DA),
        tertiary: Color(0xFFFFB59D),
        onTertiary: Color(0xFF5F1600),
        tertiaryContainer: Color(0xFF812800),
        onTertiaryContainer: Color(0xFFFFDBCF),
        error: kErrorDark,
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: kWeddingDarkCharcoalBg,
        onSurface: Color(0xFFEBE0E1),
        surfaceContainerHighest: Color(0xFF3B3338),
        onSurfaceVariant: Color(0xFFD5C2C6),
        outline: Color(0xFF9E8C91),
        outlineVariant: Color(0xFF514347),
      );
    }

    return const ColorScheme(
      brightness: Brightness.dark,
      primary: kPrimaryDark,
      onPrimary: kOnPrimaryDark,
      primaryContainer: kPrimaryContainerDark,
      onPrimaryContainer: kOnPrimaryContainerDark,
      secondary: kSecondaryDark,
      onSecondary: kOnSecondaryDark,
      secondaryContainer: kSecondaryContainerDark,
      onSecondaryContainer: kOnSecondaryContainerDark,
      tertiary: kTertiaryDark,
      onTertiary: kOnTertiaryDark,
      tertiaryContainer: kTertiaryContainerDark,
      onTertiaryContainer: kOnTertiaryContainerDark,
      error: kErrorDark,
      onError: Color(0xFF690005),
      surface: kSurfaceDark,
      onSurface: kOnSurfaceDark,
      surfaceContainerHighest: kSurfaceVariantDark,
      onSurfaceVariant: kOnSurfaceVariantDark,
      outline: Color(0xFF475569),
      outlineVariant: Color(0xFF334155),
    );
  }

  /// Complete Light Theme Data
  static ThemeData lightTheme({bool isWeddingMode = true}) {
    final scheme = lightColorScheme(isWeddingMode: isWeddingMode);
    final textTheme = isWeddingMode
        ? AppTypography.weddingTypography(scheme.onSurface, scheme.onSurfaceVariant)
        : AppTypography.standardTypography(scheme.onSurface, scheme.onSurfaceVariant);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),
    );
  }

  /// Complete Dark Theme Data
  static ThemeData darkTheme({bool isWeddingMode = true}) {
    final scheme = darkColorScheme(isWeddingMode: isWeddingMode);
    final textTheme = isWeddingMode
        ? AppTypography.weddingTypography(scheme.onSurface, scheme.onSurfaceVariant)
        : AppTypography.standardTypography(scheme.onSurface, scheme.onSurfaceVariant);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: kWeddingDarkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kWeddingDarkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: kWeddingDarkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),
    );
  }
}
