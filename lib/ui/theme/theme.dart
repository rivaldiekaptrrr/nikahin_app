import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color.dart';
import 'theme_controller.dart';
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
  static ColorScheme lightColorScheme({
    WeddingPalette palette = WeddingPalette.roseGold,
    bool isWeddingMode = true,
  }) {
    if (!isWeddingMode) {
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

    switch (palette) {
      case WeddingPalette.roseGold:
        return ColorScheme(
          brightness: Brightness.light,
          primary: kWeddingPrimaryRose,
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFFD9E2),
          onPrimaryContainer: const Color(0xFF3E001D),
          secondary: const Color(0xFF9C4146),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFFFD9DA),
          onSecondaryContainer: const Color(0xFF40000A),
          tertiary: kWeddingWarmCoral,
          onTertiary: Colors.white,
          tertiaryContainer: const Color(0xFFFFDBCF),
          onTertiaryContainer: const Color(0xFF380D00),
          error: kErrorLight,
          onError: Colors.white,
          errorContainer: const Color(0xFFFFDAD6),
          onErrorContainer: const Color(0xFF410002),
          surface: palette.canvasLight,
          onSurface: const Color(0xFF201A1B),
          surfaceContainerHighest: palette.surfaceContainerLight,
          onSurfaceVariant: const Color(0xFF514347),
          outline: const Color(0xFF837377),
          outlineVariant: const Color(0xFFD5C2C6),
        );
      case WeddingPalette.sageGreen:
        return ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF2E6F52),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFD1FAE5),
          onPrimaryContainer: const Color(0xFF064E3B),
          secondary: const Color(0xFF3F6250),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFD6E8DC),
          onSecondaryContainer: const Color(0xFF0B2B1B),
          tertiary: const Color(0xFF0D9488),
          onTertiary: Colors.white,
          tertiaryContainer: const Color(0xFFCCFBF1),
          onTertiaryContainer: const Color(0xFF115E59),
          error: kErrorLight,
          onError: Colors.white,
          errorContainer: const Color(0xFFFFDAD6),
          onErrorContainer: const Color(0xFF410002),
          surface: palette.canvasLight,
          onSurface: const Color(0xFF191D1A),
          surfaceContainerHighest: palette.surfaceContainerLight,
          onSurfaceVariant: const Color(0xFF424943),
          outline: const Color(0xFF727973),
          outlineVariant: const Color(0xFFC2C9C3),
        );
      case WeddingPalette.champagneGold:
        return ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFFD97757),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFFDBCF),
          onPrimaryContainer: const Color(0xFF380D00),
          secondary: const Color(0xFF9C4146),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFFFD9DA),
          onSecondaryContainer: const Color(0xFF40000A),
          tertiary: const Color(0xFFB45309),
          onTertiary: Colors.white,
          tertiaryContainer: const Color(0xFFFEF3C7),
          onTertiaryContainer: const Color(0xFF78350F),
          error: kErrorLight,
          onError: Colors.white,
          errorContainer: const Color(0xFFFFDAD6),
          onErrorContainer: const Color(0xFF410002),
          surface: palette.canvasLight,
          onSurface: const Color(0xFF1F1A14),
          surfaceContainerHighest: palette.surfaceContainerLight,
          onSurfaceVariant: const Color(0xFF4E453A),
          outline: const Color(0xFF807568),
          outlineVariant: const Color(0xFFD3C5B5),
        );
      case WeddingPalette.royalNavy:
        return ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF1D4ED8),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFDBEAFE),
          onPrimaryContainer: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF0369A1),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFE0F2FE),
          onSecondaryContainer: const Color(0xFF0C4A6E),
          tertiary: const Color(0xFF0284C7),
          onTertiary: Colors.white,
          tertiaryContainer: const Color(0xFFBAE6FD),
          onTertiaryContainer: const Color(0xFF0369A1),
          error: kErrorLight,
          onError: Colors.white,
          errorContainer: const Color(0xFFFFDAD6),
          onErrorContainer: const Color(0xFF410002),
          surface: palette.canvasLight,
          onSurface: const Color(0xFF0F172A),
          surfaceContainerHighest: palette.surfaceContainerLight,
          onSurfaceVariant: const Color(0xFF475569),
          outline: const Color(0xFF94A3B8),
          outlineVariant: const Color(0xFFCBD5E1),
        );
      case WeddingPalette.lavender:
        return ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF7C3AED),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFEDE9FE),
          onPrimaryContainer: const Color(0xFF4C1D95),
          secondary: const Color(0xFF6D28D9),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFDDD6FE),
          onSecondaryContainer: const Color(0xFF2E1065),
          tertiary: const Color(0xFF9333EA),
          onTertiary: Colors.white,
          tertiaryContainer: const Color(0xFFF3E8FF),
          onTertiaryContainer: const Color(0xFF581C87),
          error: kErrorLight,
          onError: Colors.white,
          errorContainer: const Color(0xFFFFDAD6),
          onErrorContainer: const Color(0xFF410002),
          surface: palette.canvasLight,
          onSurface: const Color(0xFF1E1729),
          surfaceContainerHighest: palette.surfaceContainerLight,
          onSurfaceVariant: const Color(0xFF49454E),
          outline: const Color(0xFF7A757F),
          outlineVariant: const Color(0xFFCAC4D0),
        );
    }
  }

  /// Generate Dark ColorScheme
  static ColorScheme darkColorScheme({
    WeddingPalette palette = WeddingPalette.roseGold,
    bool isWeddingMode = true,
  }) {
    if (!isWeddingMode) {
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

    switch (palette) {
      case WeddingPalette.roseGold:
        return ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFFFB1C8),
          onPrimary: const Color(0xFF5E1130),
          primaryContainer: const Color(0xFF7B2946),
          onPrimaryContainer: const Color(0xFFFFD9E2),
          secondary: const Color(0xFFFFB3B6),
          onSecondary: const Color(0xFF5F121C),
          secondaryContainer: const Color(0xFF7D2933),
          onSecondaryContainer: const Color(0xFFFFD9DA),
          tertiary: const Color(0xFFFFB59D),
          onTertiary: const Color(0xFF5F1600),
          tertiaryContainer: const Color(0xFF812800),
          onTertiaryContainer: const Color(0xFFFFDBCF),
          error: kErrorDark,
          onError: const Color(0xFF690005),
          errorContainer: const Color(0xFF93000A),
          onErrorContainer: const Color(0xFFFFDAD6),
          surface: palette.canvasDark,
          onSurface: const Color(0xFFEBE0E1),
          surfaceContainerHighest: palette.surfaceContainerDark,
          onSurfaceVariant: const Color(0xFFD5C2C6),
          outline: const Color(0xFF9E8C91),
          outlineVariant: const Color(0xFF514347),
        );
      case WeddingPalette.sageGreen:
        return ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF6EE7B7),
          onPrimary: const Color(0xFF003822),
          primaryContainer: const Color(0xFF065F46),
          onPrimaryContainer: const Color(0xFFA7F3D0),
          secondary: const Color(0xFFA3D3B7),
          onSecondary: const Color(0xFF103522),
          secondaryContainer: const Color(0xFF274D38),
          onSecondaryContainer: const Color(0xFFBFEFCE),
          tertiary: const Color(0xFF5EEAD4),
          onTertiary: const Color(0xFF003731),
          tertiaryContainer: const Color(0xFF115E59),
          onTertiaryContainer: const Color(0xFFCCFBF1),
          error: kErrorDark,
          onError: const Color(0xFF690005),
          errorContainer: const Color(0xFF93000A),
          onErrorContainer: const Color(0xFFFFDAD6),
          surface: palette.canvasDark,
          onSurface: const Color(0xFFE1E8E3),
          surfaceContainerHighest: palette.surfaceContainerDark,
          onSurfaceVariant: const Color(0xFFC2C9C3),
          outline: const Color(0xFF8C938D),
          outlineVariant: const Color(0xFF424943),
        );
      case WeddingPalette.champagneGold:
        return ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFFCD34D),
          onPrimary: const Color(0xFF451A03),
          primaryContainer: const Color(0xFF78350F),
          onPrimaryContainer: const Color(0xFFFEF3C7),
          secondary: const Color(0xFFFBBF24),
          onSecondary: const Color(0xFF451A03),
          secondaryContainer: const Color(0xFF92400E),
          onSecondaryContainer: const Color(0xFFFDE68A),
          tertiary: const Color(0xFFFDBA74),
          onTertiary: const Color(0xFF431407),
          tertiaryContainer: const Color(0xFF7C2D12),
          onTertiaryContainer: const Color(0xFFFFEDD5),
          error: kErrorDark,
          onError: const Color(0xFF690005),
          errorContainer: const Color(0xFF93000A),
          onErrorContainer: const Color(0xFFFFDAD6),
          surface: palette.canvasDark,
          onSurface: const Color(0xFFEEE5DC),
          surfaceContainerHighest: palette.surfaceContainerDark,
          onSurfaceVariant: const Color(0xFFD3C5B5),
          outline: const Color(0xFF9B8E80),
          outlineVariant: const Color(0xFF4E453A),
        );
      case WeddingPalette.royalNavy:
        return ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF93C5FD),
          onPrimary: const Color(0xFF172554),
          primaryContainer: const Color(0xFF1E40AF),
          onPrimaryContainer: const Color(0xFFDBEAFE),
          secondary: const Color(0xFF7DD3FC),
          onSecondary: const Color(0xFF082F49),
          secondaryContainer: const Color(0xFF0369A1),
          onSecondaryContainer: const Color(0xFFE0F2FE),
          tertiary: const Color(0xFF38BDF8),
          onTertiary: const Color(0xFF0C4A6E),
          tertiaryContainer: const Color(0xFF0284C7),
          onTertiaryContainer: const Color(0xFFE0F2FE),
          error: kErrorDark,
          onError: const Color(0xFF690005),
          errorContainer: const Color(0xFF93000A),
          onErrorContainer: const Color(0xFFFFDAD6),
          surface: palette.canvasDark,
          onSurface: const Color(0xFFF1F5F9),
          surfaceContainerHighest: palette.surfaceContainerDark,
          onSurfaceVariant: const Color(0xFF94A3B8),
          outline: const Color(0xFF64748B),
          outlineVariant: const Color(0xFF334155),
        );
      case WeddingPalette.lavender:
        return ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFC4B5FD),
          onPrimary: const Color(0xFF2E1065),
          primaryContainer: const Color(0xFF5B21B6),
          onPrimaryContainer: const Color(0xFFEDE9FE),
          secondary: const Color(0xFFA78BFA),
          onSecondary: const Color(0xFF3B0764),
          secondaryContainer: const Color(0xFF6D28D9),
          onSecondaryContainer: const Color(0xFFDDD6FE),
          tertiary: const Color(0xFFD8B4FE),
          onTertiary: const Color(0xFF4C1D95),
          tertiaryContainer: const Color(0xFF7E22CE),
          onTertiaryContainer: const Color(0xFFF3E8FF),
          error: kErrorDark,
          onError: const Color(0xFF690005),
          errorContainer: const Color(0xFF93000A),
          onErrorContainer: const Color(0xFFFFDAD6),
          surface: palette.canvasDark,
          onSurface: const Color(0xFFE7E1EC),
          surfaceContainerHighest: palette.surfaceContainerDark,
          onSurfaceVariant: const Color(0xFFCEC4D6),
          outline: const Color(0xFF988E9E),
          outlineVariant: const Color(0xFF4B4452),
        );
    }
  }

  /// Complete Light Theme Data
  static ThemeData lightTheme({
    WeddingPalette palette = WeddingPalette.roseGold,
    bool isWeddingMode = true,
  }) {
    final scheme = lightColorScheme(palette: palette, isWeddingMode: isWeddingMode);
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
  static ThemeData darkTheme({
    WeddingPalette palette = WeddingPalette.roseGold,
    bool isWeddingMode = true,
  }) {
    final scheme = darkColorScheme(palette: palette, isWeddingMode: isWeddingMode);
    final textTheme = isWeddingMode
        ? AppTypography.weddingTypography(scheme.onSurface, scheme.onSurfaceVariant)
        : AppTypography.standardTypography(scheme.onSurface, scheme.onSurfaceVariant);

    final darkCardColor = palette == WeddingPalette.roseGold
        ? kWeddingDarkSurface
        : Color.alphaBlend(scheme.primary.withValues(alpha: 0.08), const Color(0xFF1E1E24));

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
        color: darkCardColor,
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
