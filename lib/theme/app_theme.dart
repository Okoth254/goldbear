import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  // Legacy color references for backward compatibility during migration
  static const Color primary = ForestManorColors.deepForest;
  static const Color backgroundLight = ForestManorColors.backgroundLight;
  static const Color backgroundDark = ForestManorColors.backgroundDark;
  static const Color charcoalBark = ForestManorColors.charcoalBark;
  static const Color deepForest = ForestManorColors.deepForest;
  static const Color sageMist = ForestManorColors.sageMist;
  static const Color ochreEarth = ForestManorColors.ochreEarth;
  static const Color surfaceDark = ForestManorColors.surfaceDark;
  static const Color surfaceHighlight = ForestManorColors.surfaceHighlight;

  static ThemeData get lightTheme {
    final baseTextTheme = createForestManorTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ForestManorColors.champagneLinen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ForestManorColors.deepForest,
        primary: ForestManorColors.deepForest,
        secondary: ForestManorColors.ochreEarth,
        surface: ForestManorColors.champagneLinen,
        onSurface: ForestManorColors.charcoalBark,
        tertiary: ForestManorColors.sageMist,
      ),
      textTheme: baseTextTheme,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ForestManorColors.deepForest,
          foregroundColor: ForestManorColors.champagneLinen,
          textStyle: baseTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ForestManorColors.sageMist),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ForestManorColors.sageMist),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ForestManorColors.deepForest, width: 2),
        ),
        labelStyle: const TextStyle(color: ForestManorColors.ochreEarth),
        floatingLabelStyle: const TextStyle(color: ForestManorColors.deepForest),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = createForestManorTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ForestManorColors.surfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: ForestManorColors.deepForest,
        secondary: ForestManorColors.ochreEarth,
        surface: ForestManorColors.surfaceDark,
        onPrimary: Colors.white,
        onSecondary: ForestManorColors.surfaceDark,
        onSurface: Colors.white,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      fontFamily: 'Serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: ForestManorColors.backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
