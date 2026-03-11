import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';
import '../services/subscription_service.dart';
import '../services/price_service.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTier = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade ad Aurelius Premium'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Aurelius Sales Pitch
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AureliusTheme.accentGold,
                  child: Icon(Icons.psychology, color: Colors.black, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Gestire un patrimonio complesso richiede strumenti d\'eccellenza. Il piano Wealth è quello che consiglio per la tua attuale asset allocation.',
                      style: TextStyle(fontStyle: FontStyle.italic, height: 1.4),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),

            // Tier 1: Base
            _PricingCard(
              title: 'Base',
              price: 'Gratis',
              features: const [
                '1 Singola Banca Esterna',
                'Monitoraggio Manuale',
                'Nessun Insight AI'
              ],
              isActive: currentTier == SubscriptionTier.base,
              onTap: () => ref.read(subscriptionProvider.notifier).upgradeTo(SubscriptionTier.base),
              isRecommended: false,
            ),
            const SizedBox(height: 16),

            // Tier 2: Pro
            _PricingCard(
              title: 'Pro',
              price: '€ 9.99 / mese',
              features: const [
                'Multi-banca illimitato',
                'AI Advisor Base',
                'Scanner Screenshot Illimitato',
                'Supporto Asset Criptovalute'
              ],
              isActive: currentTier == SubscriptionTier.pro,
              onTap: () => ref.read(subscriptionProvider.notifier).upgradeTo(SubscriptionTier.pro),
              isRecommended: false,
            ),
            const SizedBox(height: 16),

            // Tier 3: Wealth
            _PricingCard(
              title: 'Wealth Elite',
              price: '€ 24.99 / mese',
              features: const [
                'Gestione Real Estate',
                'Master Dashboard (Net Worth Totale)',
                'Report Patrimoniale Mensile Esportabile',
                'Priorità Aurelius AI Advisor'
              ],
              isActive: currentTier == SubscriptionTier.wealth,
              onTap: () => ref.read(subscriptionProvider.notifier).upgradeTo(SubscriptionTier.wealth),
              isRecommended: true,
            ),
            
            const SizedBox(height: 30),
            
            // Generate Report Button
            if (currentTier.canExportPdf)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AureliusTheme.accentGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Esporta Report Patrimoniale', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onPressed: () => _showTextReport(context, ref),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _showTextReport(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.read(portfolioProvider);
    final assets = assetsAsync.valueOrNull ?? [];
    
    double realEstateValue = assets.where((a) => a.category == AssetCategory.realEstate).fold(0.0, (s, a) => s + a.totalNetValue);
    double finanzaValue = assets.where((a) => a.category == AssetCategory.finanza).fold(0.0, (s, a) => s + a.totalNetValue);
    double cashValue = assets.where((a) => a.category == AssetCategory.cash).fold(0.0, (s, a) => s + a.totalNetValue);
    double cryptoValue = assets.where((a) => a.category == AssetCategory.crypto).fold(0.0, (s, a) => s + a.totalNetValue);
    double liabilities = assets.fold(0.0, (sum, asset) => sum + asset.mortgageResidual);
    
    double totalWealth = realEstateValue + finanzaValue + cashValue + cryptoValue;
    
    final currencyFormatter = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    final String report = '''
---------------------------------
REPORT PATRIMONIALE WEALTH ELITE
Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}
---------------------------------

NET WORTH TOTALE: ${currencyFormatter.format(totalWealth)}

Ripartizione Asset:
- Finanza Tradizionale: ${currencyFormatter.format(finanzaValue)}
- Frontiera Crypto: ${currencyFormatter.format(cryptoValue)}
- Liquidità (Cash): ${currencyFormatter.format(cashValue)}
- Immobiliare (Netto): ${currencyFormatter.format(realEstateValue)}

Passività In Essere:
- Mutui/Prestiti: ${currencyFormatter.format(liabilities)}

Un servizio esclusivo di Portafoglio Aurelius.
''';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AureliusTheme.cardDark,
        title: const Text('Report Generato', style: TextStyle(color: AureliusTheme.accentGold)),
        content: SingleChildScrollView(
          child: Text(report, style: const TextStyle(fontFamily: 'Courier', fontSize: 12)),
        ),
        actions: [
          TextButton(
            child: const Text('Chiudi', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(ctx),
          )
        ],
      )
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isActive;
  final VoidCallback onTap;
  final bool isRecommended;

  const _PricingCard({
    required this.title,
    required this.price,
    required this.features,
    required this.isActive,
    required this.onTap,
    required this.isRecommended,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AureliusTheme.accentGold : Colors.white12,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive ? [
             BoxShadow(color: AureliusTheme.accentGold.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)
          ] : null,
        ),
        child: GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isRecommended)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AureliusTheme.accentGold, borderRadius: BorderRadius.circular(20)),
                  child: const Text('CONSIGLIATO DA AURELIUS', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isActive ? AureliusTheme.accentGold : Colors.white)),
                  if (isActive) const Icon(Icons.check_circle, color: AureliusTheme.accentGold),
                ],
              ),
              const SizedBox(height: 8),
              Text(price, style: const TextStyle(fontSize: 18, color: AureliusTheme.secondaryText)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white12),
              ),
              ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.greenAccent),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f)),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
