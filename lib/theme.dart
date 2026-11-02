import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

// Color Palette from HTML
class AppColors {
  static const Color primary50 = Color(0xFFfef4f1);
  static const Color primary100 = Color(0xFFfde8e2);
  static const Color primary200 = Color(0xFFfbd6c9);
  static const Color primary300 = Color(0xFFf9b8a5);
  static const Color primary400 = Color(0xFFf68f74);
  static const Color primary500 = Color(0xFFec5413);
  static const Color primary600 = Color(0xFFdd470c);
  static const Color primary700 = Color(0xFFb83808);
  static const Color primary800 = Color(0xFF932d08);
  static const Color primary900 = Color(0xFF77260a);
  static const Color primary950 = Color(0xFF401004);

  static const Color secondary50 = Color(0xFFfcf9f8);
  static const Color secondary100 = Color(0xFFf3ebe7);
  static const Color secondary200 = Color(0xFFe7d6cf);
  static const Color secondary300 = Color(0xFFd6bcae);
  static const Color secondary400 = Color(0xFFc19d88);
  static const Color secondary500 = Color(0xFFac7e68);
  static const Color secondary600 = Color(0xFF9a634c);
  static const Color secondary700 = Color(0xFF815140);
  static const Color secondary800 = Color(0xFF684236);
  static const Color secondary900 = Color(0xFF55362d);
  static const Color secondary950 = Color(0xFF2d1b16);

  static const Color textColor = Color(0xFF1b120d);
  static const Color textSecondary = Color(0xFF9a634c); // Added textSecondary
  static const Color backgroundSecondary = Color(
    0xFFf3ebe7,
  ); // Added backgroundSecondary
  static const Color borderColor = Color(0xFFe7d6cf);
}

// Text Styles (Manrope, Noto Sans will be imported via GoogleFonts later)
class AppTextStyles {
  // Define text styles based on the HTML, using default fonts for now.
  // GoogleFonts will be integrated after pubspec.yaml update.

  static TextStyle get bodyText => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static TextStyle get headline1 => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 40,
    fontWeight: FontWeight.w900, // Black
    color: Colors.white,
  ); // Corresponding to h1 in Hero section

  static TextStyle get headline2 => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  ); // Corresponding to h2 in Featured Profiles / How it Works

  static TextStyle get subhead => GoogleFonts.notoSans(
    // Use Noto Sans
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
  ); // Corresponding to h2 in Hero section

  static TextStyle get buttonText => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.015,
  );

  static TextStyle get buttonTextSecondary => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
    letterSpacing: 0.015,
  );

  static TextStyle get navLink => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textColor,
  );

  static TextStyle get footerText => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 12,
    color: AppColors.secondary600,
  );

  static TextStyle get cardTitle => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static TextStyle get cardSubtitle => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 16,
    color: AppColors.secondary600,
  );

  static TextStyle get sectionTitle => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static TextStyle get sectionSubtitle => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 16,
    color: AppColors.secondary600,
  );

  static TextStyle get headline3 => GoogleFonts.manrope(
    // New style for Messages page
    fontSize: 20,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.textColor,
  );

  static TextStyle get stepTitle => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static TextStyle get stepDescription => GoogleFonts.manrope(
    // Use Manrope
    fontSize: 14,
    color: AppColors.secondary600,
  );
}
