import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class AppThemes {
  const AppThemes._();

  static final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor, primary: AppColors.primaryColor),
      useMaterial3: false,
      fontFamily: GoogleFonts.poppins().fontFamily);
}
