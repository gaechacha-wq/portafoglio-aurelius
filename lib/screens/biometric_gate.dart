import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';

class BiometricGate extends ConsumerStatefulWidget {
  const BiometricGate({super.key});

  @override
  ConsumerState<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends ConsumerState<BiometricGate> {
  bool isAuthenticating = false;

  Future<void> _mockAuthenticate() async {
    if (isAuthenticating) return;

    setState(() {
      isAuthenticating = true;
    });

    // Ritardo esatto richiesto nel Master Prompt [AURELIUS-MP-08]
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Sfondo puro black richiesto
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // 1. Logo/icona centrata con shimmer dorato animato
              Shimmer.fromColors(
                baseColor: AureliusTheme.accentGold,
                highlightColor: Colors.white,
                period: const Duration(seconds: 3),
                child: const Icon(
                  Icons.shield_rounded, 
                  size: 90,
                  color: AureliusTheme.accentGold,
                ),
              ),
              const SizedBox(height: 24),
              
              // 2. Testo principale
              Text(
                "Portafoglio Aurelius",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AureliusTheme.accentGold,
                ),
              ),
              const SizedBox(height: 8),
              
              // 3. Sottotitolo
              Text(
                "Il tuo patrimonio. Sempre con te.",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 40),

              // 5. Pulsante biometrico o caricamento
              isAuthenticating
                  ? const CircularProgressIndicator(
                      color: AureliusTheme.accentGold,
                    )
                  : GestureDetector(
                      onTap: _mockAuthenticate,
                      child: const GlassContainer(
                        width: 80,
                        height: 80,
                        borderRadius: 40, // Cerchio perfetto
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: AureliusTheme.accentGold,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
              
              const Spacer(),
              
              // 6. Link in basso (Solo placeholder visivo)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  "Accedi con PIN",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8E8E93),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
