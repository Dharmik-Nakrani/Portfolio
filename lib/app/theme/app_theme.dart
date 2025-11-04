import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.themeColor,
        secondary: AppColors.sectionTitle,
        surface: AppColors.cardBg,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.openSans(
          color: AppColors.sectionDescription,
          fontSize: 64,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.raleway(
          color: AppColors.sectionTitle,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.poppins(
          color: AppColors.sectionTitle,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.openSans(
          color: AppColors.sectionDescription,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.openSans(
          color: AppColors.sectionDescription,
          fontSize: 14,
        ),
      ),
      useMaterial3: true,
    );
  }
}
