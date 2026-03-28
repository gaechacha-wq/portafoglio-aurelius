import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/subscription_service.dart';
import '../widgets/glass_container.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTier = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.workspace_premium_rounded, size: 48, color: AureliusTheme.accentGold),
            const SizedBox(height: 16),
            Text(
              "Sblocca il tuo Potenziale Finanziario",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Scegli il piano che si adatta al tuo patrimonio.\nProva gratuita 14 giorni, nessun addebito immediato.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF8E8E93)),
            ),
            const SizedBox(height: 32),

            // CARD CORE
            _buildCoreCard(context, ref, currentTier),
            const SizedBox(height: 16),

            // CARD PRO (Evidenziata)
            _buildProCard(context, ref, currentTier),
            const SizedBox(height: 16),

            // CARD WEALTH
            _buildWealthCard(context, ref, currentTier),

            const SizedBox(height: 32),
            Text("🔒 Pagamento sicuro. Disdici quando vuoi.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93))),
            const SizedBox(height: 8),
            Text("Tutti i prezzi includono IVA.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93).withOpacity(0.6))),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AureliusTheme.accentGold, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 14, color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildCurrentPlanIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text("✓ Piano attuale", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4CAF50))),
    );
  }

  Widget _buildCoreCard(BuildContext context, WidgetRef ref, SubscriptionTier currentTier) {
    final bool isActive = currentTier == SubscriptionTier.base;

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Core", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Per iniziare", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("€9,99", style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("/mese", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                ],
              ),
            ],
          ),
          _buildDivider(),
          _buildFeatureLine("Asset illimitati inserimento manuale"),
          _buildFeatureLine("2 integrazioni bancarie"),
          _buildFeatureLine("Storico 12 mesi"),
          _buildFeatureLine("Privacy Mode"),
          _buildFeatureLine("Export CSV"),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AureliusTheme.accentGold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ref.read(subscriptionProvider.notifier).upgradeTo(SubscriptionTier.base);
                context.pop();
              },
              child: Text("Inizia ora", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AureliusTheme.accentGold)),
            ),
          ),
          if (isActive) _buildCurrentPlanIndicator(),
        ],
      ),
    );
  }

  Widget _buildProCard(BuildContext context, WidgetRef ref, SubscriptionTier currentTier) {
    final bool isActive = currentTier == SubscriptionTier.pro;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: AureliusTheme.accentGold, width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: GlassContainer(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pro", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("Per investitori attivi", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("€24,99", style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
                        Text("/mese", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                      ],
                    ),
                  ],
                ),
                _buildDivider(),
                _buildFeatureLine("Tutto di Core"),
                _buildFeatureLine("Integrazioni automatiche illimitate"),
                _buildFeatureLine("Performance per categoria"),
                _buildFeatureLine("Scenario Planner"),
                _buildFeatureLine("Document Vault"),
                _buildFeatureLine("Advisor sharing (1 utente)"),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AureliusTheme.accentGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ref.read(subscriptionProvider.notifier).upgradeTo(SubscriptionTier.pro);
                      context.pop();
                    },
                    child: Text("Scegli Pro", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (isActive) _buildCurrentPlanIndicator(),
              ],
            ),
          ),
        ),
        Positioned(
          top: -12,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AureliusTheme.accentGold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Il più scelto", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Widget _buildWealthCard(BuildContext context, WidgetRef ref, SubscriptionTier currentTier) {
    final bool isActive = currentTier == SubscriptionTier.wealth;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GlassContainer(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Wealth", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Per patrimoni complessi", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("€79,99", style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("/mese", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                  ],
                ),
              ],
            ),
            _buildDivider(),
            _buildFeatureLine("Tutto di Pro"),
            _buildFeatureLine("Master Dashboard patrimoniale"),
            _buildFeatureLine("Family Office (5 utenti)"),
            _buildFeatureLine("Tax Engine avanzato"),
            _buildFeatureLine("Report PDF per commercialista"),
            _buildFeatureLine("Supporto dedicato"),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.6)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ref.read(subscriptionProvider.notifier).upgradeTo(SubscriptionTier.wealth);
                  context.pop();
                }, // Pop chiude programmaticamente l'Onboarding / PayWall e aggiorna i layer
                child: Text("Scegli Wealth", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            if (isActive) _buildCurrentPlanIndicator(),
          ],
        ),
      ),
    );
  }
}
