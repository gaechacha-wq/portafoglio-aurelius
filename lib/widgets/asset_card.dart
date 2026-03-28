import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/asset_model.dart';
import 'glass_container.dart';

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

    return GlassContainer(
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
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFFFFFFFF)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${asset.ticker} • ${asset.bank}",
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: const Color(0xFF8E8E93)),
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
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFFFFFFF)),
              ),
              const SizedBox(height: 4),
              Text(
                displayPerf,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: isPrivacyMode ? const Color(0xFF8E8E93) : perfColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
