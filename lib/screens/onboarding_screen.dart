import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../services/price_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.go('/dashboard'),
            child: Text("Salta", style: GoogleFonts.inter(color: const Color(0xFF8E8E93))),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildPage(
                    icon: Icons.account_balance_wallet_rounded,
                    title: "Benvenuto in Aurelius",
                    description: "Il tuo caveau digitale personale. Tutto il tuo patrimonio in un posto solo, sempre sotto controllo.",
                  ),
                  _buildPage(
                    icon: Icons.add_circle_outline_rounded,
                    title: "Aggiungi i tuoi asset",
                    description: "Inserisci manualmente azioni, crypto, immobili, orologi e liquidità. Oppure usa lo Scanner AI per importare automaticamente dai tuoi estratti conto.",
                  ),
                  _buildPage(
                    icon: Icons.lock_rounded,
                    title: "I tuoi dati, solo tuoi",
                    description: "Aurelius non vende i tuoi dati. Attiva il Privacy Mode per oscurare tutti i valori con un solo tap.",
                  ),
                  _buildGoalPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(4, (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index ? AureliusTheme.accentGold : const Color(0xFF8E8E93).withOpacity(0.5),
                          ),
                        )),
                  ),
                  _currentPage < 3
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AureliusTheme.accentGold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            foregroundColor: AureliusTheme.accentGold,
                          ),
                          onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                          child: Text("Avanti", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AureliusTheme.accentGold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => context.go('/dashboard'),
                          child: Text("Inizia", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AureliusTheme.accentGold),
          const SizedBox(height: 24),
          Text(title, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(description, style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF8E8E93)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  final _goalController = TextEditingController();

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flag_rounded, size: 64, color: AureliusTheme.accentGold),
          const SizedBox(height: 24),
          Text("Qual è il tuo obiettivo?", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          TextField(
            controller: _goalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Inserisci il tuo obiettivo patrimoniale in €",
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AureliusTheme.accentGold), borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AureliusTheme.accentGold, width: 2), borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          Text("Puoi modificarlo in qualsiasi momento nelle Impostazioni.", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93)), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AureliusTheme.accentGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final val = double.tryParse(_goalController.text.replaceAll(',', '.'));
                if (val != null && val > 0) {
                  ref.read(savingsGoalProvider.notifier).state = val;
                }
                context.go('/dashboard');
              },
              child: Text("Imposta Obiettivo", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/dashboard'),
            child: Text("Salta", style: GoogleFonts.inter(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
