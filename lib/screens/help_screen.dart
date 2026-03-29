import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Guida Aurelius", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AureliusTheme.accentGold),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GlassContainer(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("COME INIZIARE", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildStep("Step 1", "Aggiungi i tuoi asset", "Tocca il + in basso a destra e segui la procedura guidata."),
                  const SizedBox(height: 16),
                  _buildStep("Step 2", "Monitora il patrimonio", "La dashboard aggiorna i valori automaticamente ogni 5 secondi."),
                  const SizedBox(height: 16),
                  _buildStep("Step 3", "Analizza con AI", "Usa l'AI Advisor per ricevere consigli personalizzati sul tuo portafoglio."),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassContainer(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CATEGORIE ASSET", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildAssetCat(Icons.trending_up, Colors.blue, "Finanza", "Azioni, ETF, Obbligazioni"),
                  _buildAssetCat(Icons.currency_bitcoin, Colors.orange, "Crypto", "Bitcoin, Altcoins, Wallet"),
                  _buildAssetCat(Icons.home_work_rounded, Colors.green, "Immobili", "Proprietà e Mutui residui"),
                  _buildAssetCat(Icons.account_balance_wallet_rounded, Colors.white, "Liquidità", "Conti Correnti, Cash"),
                  _buildAssetCat(Icons.inventory_2_rounded, Colors.yellow[700]!, "Metalli", "Oro, Argento Fisico"),
                  _buildAssetCat(Icons.diamond_rounded, Colors.purple[300]!, "Lusso", "Orologi, Arte, Auto"),
                  _buildAssetCat(Icons.shield_rounded, Colors.teal[300]!, "Previdenza", "Fondi Pensione, PIP"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassContainer(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PRIVACY E SICUREZZA", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    "I tuoi dati sono protetti con autenticazione Firebase e regole di sicurezza che garantiscono che solo tu possa accedere al tuo portafoglio. Attiva il Privacy Mode per oscurare i valori sensibili.",
                    style: GoogleFonts.inter(color: Colors.white, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassContainer(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CONTATTI", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    "Per supporto o feedback scrivi a:\nsupport@portafoglioaurelius.it",
                    style: GoogleFonts.inter(color: Colors.white, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String subtitle, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AureliusTheme.accentGold.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
              child: Text(title, style: GoogleFonts.inter(color: AureliusTheme.accentGold, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Text(subtitle, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(desc, style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 13)),
      ],
    );
  }

  Widget _buildAssetCat(IconData icon, Color color, String name, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
              Text(desc, style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}
