import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/theme.dart';
import '../models/asset_model.dart';
import '../services/price_service.dart';
import '../services/tax_export_service.dart';
import '../services/subscription_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/aurelius_snackbar.dart';

class TaxScreen extends ConsumerWidget {
  const TaxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subTier = ref.watch(subscriptionProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    final portfolioAsync = ref.watch(portfolioProvider);
    final taxService = ref.watch(taxExportServiceProvider);

    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Zainetto Fiscale", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
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
      body: subTier == SubscriptionTier.base ? _buildPaywall(context) : _buildContent(context, privacyMode, portfolioAsync, taxService),
    );
  }

  Widget _buildPaywall(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_rounded, size: 64, color: AureliusTheme.accentGold),
              const SizedBox(height: 24),
              Text("Zainetto Fiscale", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              Text(
                "Il calcolo automatizzato delle plusvalenze, l'ottimizzazione fiscale e l'esportazione CSV per il tuo commercialista sono funzionalità esclusive dei piani Pro e Wealth.",
                style: GoogleFonts.inter(color: const Color(0xFF8E8E93)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AureliusTheme.accentGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go('/subscription'),
                child: Text("Sblocca Ora", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool privacyMode, AsyncValue<List<Asset>> portfolioAsync, TaxExportService taxService) {
    final formatter = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    return portfolioAsync.maybeWhen(
      data: (assets) {
        final List<Asset> taxableAssets = assets.where((a) => a.category != AssetCategory.cash && a.category != AssetCategory.previdenza).toList();
        
        double totPlusvalenze = 0;
        double totMinusvalenze = 0;
        for (final asset in taxableAssets) {
          final pl = taxService.calcolaPlusvalenza(asset);
          if (pl > 0) totPlusvalenze += pl;
          else totMinusvalenze += pl.abs();
        }
        final imponibileNetto = totPlusvalenze - totMinusvalenze;
        final impostaDovuta = imponibileNetto > 0 ? imponibileNetto * 0.26 : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CARD 1 - RIEPILOGO
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("RIEPILOGO ANNO CORRENTE", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildRow("Plusvalenze totali", privacyMode ? "***" : formatter.format(totPlusvalenze), const Color(0xFF4CAF50)),
                    const SizedBox(height: 8),
                    _buildRow("Minusvalenze totali", privacyMode ? "***" : formatter.format(totMinusvalenze), const Color(0xFFF44336)),
                    const SizedBox(height: 8),
                    _buildRow("Imponibile netto", privacyMode ? "***" : formatter.format(imponibileNetto), Colors.white),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: AureliusTheme.accentGold), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Imposta dovuta (26%)", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(privacyMode ? "***" : formatter.format(impostaDovuta), style: GoogleFonts.inter(color: AureliusTheme.accentGold, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // CARD 2 - LISTA
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DETTAGLIO PER ASSET", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ...taxableAssets.map((asset) {
                      final pl = taxService.calcolaPlusvalenza(asset);
                      final isGain = pl >= 0;
                      final imposta = taxService.calcolaImposta(asset);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.show_chart_rounded, color: Colors.white, size: 24),
                            const SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(asset.name, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                                Text(asset.ticker, style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 12)),
                              ],
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(privacyMode ? "***" : formatter.format(pl.abs()), style: GoogleFonts.inter(color: isGain ? const Color(0xFF4CAF50) : const Color(0xFFF44336), fontWeight: FontWeight.w600)),
                                Text(privacyMode ? "***" : "Imp: ${formatter.format(imposta)}", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFF9800)), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFFFF9800), size: 20),
                          const SizedBox(width: 12),
                          Expanded(child: Text("Questi calcoli sono indicativi. Consulta sempre il tuo commercialista per la dichiarazione fiscale ufficiale.", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 12))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // CARD 3 - DOWNLOAD
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ESPORTA", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AureliusTheme.accentGold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final csvContent = taxService.generaCSV(taxableAssets);
                          final blob = html.Blob([csvContent], 'text/csv');
                          final url = html.Url.createObjectUrlFromBlob(blob);
                          html.AnchorElement(href: url)
                            ..setAttribute('download', 'aurelius_fiscale_${DateTime.now().year}.csv')
                            ..click();
                          html.Url.revokeObjectUrl(url);

                          AureliusSnackBar.showSuccess(context, "Report scaricato con successo");
                        },
                        icon: const Icon(Icons.download_rounded, color: Colors.black),
                        label: Text("Scarica Report CSV", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text("Il file CSV è compatibile con Excel, Numbers e qualsiasi software contabile.", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 11), textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
      orElse: () => const Center(child: CircularProgressIndicator(color: AureliusTheme.accentGold)),
    );
  }

  Widget _buildRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
        Text(value, style: GoogleFonts.inter(color: valueColor, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
