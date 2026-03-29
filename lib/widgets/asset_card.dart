import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/asset_model.dart';
import 'glass_container.dart';
import '../core/theme.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  final bool isPrivacyMode;
  final String targetCurrency;

  const AssetCard({
    super.key,
    required this.asset,
    required this.isPrivacyMode,
    required this.targetCurrency,
  });

  @override
  Widget build(BuildContext context) {
    IconData categoryIcon;
    Color categoryColor;

    switch (asset.category) {
      case AssetCategory.finanza:
        categoryIcon = Icons.trending_up_rounded;
        categoryColor = const Color(0xFFD4AF37);
        break;
      case AssetCategory.crypto:
        categoryIcon = Icons.currency_bitcoin_rounded;
        categoryColor = const Color(0xFF00E5FF);
        break;
      case AssetCategory.realEstate:
        categoryIcon = Icons.home_rounded;
        categoryColor = const Color(0xFF4CAF50);
        break;
      case AssetCategory.lusso:
        categoryIcon = Icons.diamond_rounded;
        categoryColor = const Color(0xFF9C27B0);
        break;
      case AssetCategory.cash:
        categoryIcon = Icons.account_balance_wallet_rounded;
        categoryColor = const Color(0xFF607D8B);
        break;
      case AssetCategory.metalli:
        categoryIcon = Icons.savings_rounded;
        categoryColor = const Color(0xFFFF9800);
        break;
      case AssetCategory.previdenza:
        categoryIcon = Icons.shield_rounded;
        categoryColor = const Color(0xFF03A9F4);
        break;
    }

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'it_IT', 
      symbol: targetCurrency == 'EUR' ? '€' : (targetCurrency == 'USD' ? '\$' : '£'),
    );
    
    final double netValue = asset.totalNetValueIn(targetCurrency);
    final String displayValue = isPrivacyMode ? "••••••" : currencyFormat.format(netValue);

    final double perf = asset.profitLossPercent;
    final bool isPositive = perf >= 0;
    final String perfPrefix = isPositive ? "▲ +" : "▼ ";
    final Color perfColor = isPositive ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final String displayPerf = isPrivacyMode ? "••.••%" : "${perfPrefix}${perf.abs().toStringAsFixed(2)}%";

    return GestureDetector(
      onTap: () => _showAssetDetails(context, categoryIcon, categoryColor, currencyFormat),
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // SINISTRA
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: categoryColor.withOpacity(0.5), width: 1),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 24),
            ),
            const SizedBox(width: 16),
            
            // CENTRO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${asset.ticker} • ${asset.bank}",
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // DESTRA
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayValue,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  displayPerf,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: isPrivacyMode ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6) : perfColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAssetDetails(BuildContext context, IconData icon, Color color, NumberFormat format) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.only(top: 100),
          child: GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Maniglia di trascinamento
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: const Color(0xFF8E8E93).withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),

                // HEADER
                Center(child: Icon(icon, color: color, size: 40)),
                const SizedBox(height: 12),
                Text(asset.name, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(ctx).colorScheme.onSurface)),
                Text("${asset.ticker} • ${asset.bank}", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.6))),
                const SizedBox(height: 16),
                Divider(color: AureliusTheme.accentGold.withOpacity(0.2)),
                const SizedBox(height: 16),

                // METRICHE
                Row(
                  children: [
                    Expanded(child: _buildMetricItem(ctx, "Valore Attuale", isPrivacyMode ? "••••••" : format.format(asset.currentPrice))),
                    Expanded(child: _buildMetricItem(ctx, "Prezzo Carico", isPrivacyMode ? "••••••" : format.format(asset.entryPrice))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMetricItem(ctx, "Quantità", isPrivacyMode ? "•••" : asset.quantity.toString())),
                    Expanded(child: _buildMetricItem(ctx, "Gain/Loss", isPrivacyMode ? "••••••" : format.format(asset.profitLoss), 
                      valColor: isPrivacyMode ? Theme.of(ctx).colorScheme.onSurface : (asset.profitLoss >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336)))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMetricItem(ctx, "Performance", isPrivacyMode ? "••.••%" : "${asset.profitLossPercent.toStringAsFixed(2)}%", 
                      valColor: isPrivacyMode ? Theme.of(ctx).colorScheme.onSurface : (asset.profitLossPercent >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336)))),
                    Expanded(child: _buildMetricItem(ctx, "Valuta Originale", asset.currency)),
                  ],
                ),

                // EXTRA
                if (asset.category == AssetCategory.realEstate) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildMetricItem(ctx, "Mutuo Residuo", isPrivacyMode ? "••••••" : format.format(0))),
                      Expanded(child: _buildMetricItem(ctx, "Affitto Mensile", isPrivacyMode ? "••••••" : format.format(asset.monthlyRent))),
                    ],
                  ),
                ],
                if (asset.category == AssetCategory.crypto) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildMetricItem(ctx, "Custode / Wallet", asset.bank)),
                    ],
                  ),
                ],
                
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AureliusTheme.accentGold,
                      side: const BorderSide(color: AureliusTheme.accentGold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("Chiudi", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricItem(BuildContext context, String label, String value, {Color? valColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: GoogleFonts.inter(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: valColor ?? Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }
}
