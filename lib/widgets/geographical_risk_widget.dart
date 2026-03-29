import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/asset_model.dart';
import '../services/price_service.dart';
import 'glass_container.dart';

class GeographicalRiskWidget extends ConsumerWidget {
  const GeographicalRiskWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetCurrency = ref.watch(targetCurrencyProvider);
    final portfolioAsync = ref.watch(portfolioProvider);

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.public_rounded, color: Color(0xFF8E8E93), size: 16),
              const SizedBox(width: 8),
              Text("RISCHIO GEOGRAFICO", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF8E8E93))),
            ],
          ),
          const SizedBox(height: 16),
          
          portfolioAsync.when(
            data: (assets) {
              if (assets.isEmpty) {
                return Text("Nessun dato geografico.", style: GoogleFonts.inter(color: Colors.white));
              }

              final totalNet = assets.fold(0.0, (s, a) => s + a.totalNetValueIn(targetCurrency));
              if (totalNet <= 0) {
                return Text("Patrimonio insufficiente per l'analisi.", style: GoogleFonts.inter(color: Colors.white));
              }

              final Map<String, double> jurisdictionValues = {};

              for (final asset in assets) {
                String region = "Sconosciuta";
                if (asset.category == AssetCategory.crypto) {
                  region = "Decentralizzato";
                } else if (asset.category == AssetCategory.metalli) {
                  region = "Fisico/Cassaforte";
                } else if (asset.category == AssetCategory.previdenza) {
                  region = "Italia";
                } else if (asset.currency == 'USD') {
                  region = "USA";
                } else if (asset.currency == 'EUR' && asset.category == AssetCategory.realEstate) {
                  region = "Italia";
                } else if (asset.currency == 'EUR') {
                  region = "Europa";
                } else {
                  region = "Internazionale";
                }
                
                final val = asset.totalNetValueIn(targetCurrency);
                jurisdictionValues[region] = (jurisdictionValues[region] ?? 0) + val;
              }

              final List<Widget> bars = [];
              jurisdictionValues.forEach((region, value) {
                final percentage = value / totalNet;
                final pctValue = percentage * 100;
                
                String flag = "🌍";
                if (region == "USA") flag = "🇺🇸";
                else if (region == "Europa") flag = "🇪🇺";
                else if (region == "Italia") flag = "🇮🇹";
                else if (region == "Decentralizzato") flag = "⛓️";
                else if (region == "Fisico/Cassaforte") flag = "🏦";

                Color barColor = const Color(0xFF4CAF50);
                if (pctValue > 70) barColor = const Color(0xFFF44336);
                else if (pctValue >= 40) barColor = const Color(0xFFFF9800);

                bars.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("$flag  $region", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Text("${pctValue.toStringAsFixed(1)}%", style: GoogleFonts.inter(color: barColor, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.white.withOpacity(0.05),
                            valueColor: AlwaysStoppedAnimation<Color>(barColor),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  )
                );
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...bars,
                  const SizedBox(height: 8),
                  Text("Una concentrazione > 70% in una singola giurisdizione aumenta il rischio regolatorio.", 
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93))),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(color: Color(0xFFD4AF37)),
            error: (_,__) => Text("Errore nel caricamento", style: GoogleFonts.inter(color: Colors.red)),
          )
        ],
      ),
    );
  }
}
