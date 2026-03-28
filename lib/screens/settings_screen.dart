import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: Text("Impostazioni", style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings_rounded, color: AureliusTheme.accentGold, size: 64),
            const SizedBox(height: 24),
            Text("Impostazioni", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
            const SizedBox(height: 12),
            Text("Funzione in arrivo", style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                "Personalizza la tua esperienza Aurelius:\n"
                "valuta, notifiche, sicurezza e molto altro.\n"
                "Disponibile a breve.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
