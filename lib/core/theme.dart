import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AureliusTheme {
  // Dark premium colors
  static const Color backgroundBlack = Color(0xFF000000);
  static const Color cardDark = Color(0xFF1C1C1E);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color secondaryText = Color(0xFF8E8E93);
  static const Color primaryText = Color(0xFFFFFFFF);
  
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
