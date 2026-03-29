import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AureliusTheme {
  // Dark premium colors
  static const Color backgroundBlack = Color(0xFF000000);
  static const Color cardDark = Color(0xFF1C1C1E);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color secondaryText = Color(0xFF8E8E93);
  static const Color primaryText = Color(0xFFFFFFFF);
  
  static const Color catFinanza = Color(0xFFD4AF37);
  static const Color catCrypto = Color(0xFF00E5FF);
  static const Color catRealEstate = Color(0xFF4CAF50);
  static const Color catLusso = Color(0xFF9C27B0);
  static const Color catCash = Color(0xFF607D8B);
  static const Color catMetalli = Color(0xFFFF9800);
  static const Color catPrevidenza = Color(0xFF03A9F4);
  static const Color gainGreen = Color(0xFF4CAF50);
  static const Color lossRed = Color(0xFFF44336);

  static const Color lightBackground = Color(0xFFF5F0E8);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE8DFC0);
  static const Color lightPrimaryText = Color(0xFF1A1A1A);
  static const Color lightSecondaryText = Color(0xFF666666);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: accentGold,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: primaryText),
        titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: primaryText),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: primaryText),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: secondaryText),
      ),
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        onPrimary: backgroundBlack,
        surface: cardDark,
        onSurface: primaryText,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: accentGold,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: lightPrimaryText),
        titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: lightPrimaryText),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: lightPrimaryText),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: lightSecondaryText),
      ),
      colorScheme: const ColorScheme.light(
        primary: accentGold,
        onPrimary: Colors.white,
        surface: lightCard,
        onSurface: lightPrimaryText,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lightCardBorder, width: 1),
        ),
      ),
    );
  }
}
