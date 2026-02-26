import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

TextTheme createForestManorTextTheme() {
  return TextTheme(
    displayLarge: GoogleFonts.cormorantGaramond(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: ForestManorColors.deepForest,
      letterSpacing: 1.2,
    ),
    displayMedium: GoogleFonts.cormorantGaramond(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: ForestManorColors.deepForest,
      letterSpacing: 1.1,
    ),
    headlineMedium: GoogleFonts.cormorantGaramond(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: ForestManorColors.deepForest,
      letterSpacing: 1.0,
    ),
    titleLarge: GoogleFonts.cormorantGaramond(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: ForestManorColors.charcoalBark,
      letterSpacing: 1.0,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: ForestManorColors.charcoalBark,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: ForestManorColors.ochreEarth,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: ForestManorColors.champagneLinen,
      letterSpacing: 0.5,
    ),
  );
}
