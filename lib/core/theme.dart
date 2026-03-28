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
}
