import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/glass_container.dart';
import '../core/theme.dart';
import '../services/price_service.dart';

class RientroPostVenditaScreen extends ConsumerWidget {
  const RientroPostVenditaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simuliamo una lista di posizioni liquidate storiche
    final historicalSales = [
      HistoricalSaleItem(ticker: 'NVDA', exitPrice: 910.00, entryPriceAtSale: 420.00), // NVDA ora sta crollando nel mock (850)
      HistoricalSaleItem(ticker: 'RTX', exitPrice: 80.00, entryPriceAtSale: 65.00),     // RTX ora sta salendo nel mock (90)
    ];

    // Otteniamo il provider dinamico per comparare
    final currentPortfolioAsync = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rientro Post-Vendita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analisi Vendite & Opportunità', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            GlassContainer(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Margine Operativo Storico', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('€ 45.200,00', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Text('Scannerizzazione Prezzi Attuali', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),

                  currentPortfolioAsync.when(
                    data: (assets) {
                      return Column(
                        children: historicalSales.map((sale) {
                          // Troviamo il prezzo odierno se l'asset esiste ancora tra i simulati
                          final currentAsset = assets.firstWhere((a) => a.ticker == sale.ticker, orElse: () => Asset(ticker: '', name: '', currentPrice: sale.exitPrice, entryPrice: 0, quantity: 0));
                          final isOpportunity = currentAsset.ticker.isNotEmpty && currentAsset.currentPrice < sale.exitPrice;
                          final savePercent = isOpportunity ? ((sale.exitPrice - currentAsset.currentPrice) / sale.exitPrice * 100) : 0.0;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _SaleReentryCard(
                              sale: sale, 
                              currentPrice: currentAsset.currentPrice,
                              isOpportunity: isOpportunity,
                              savePercent: savePercent,
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: AureliusTheme.accentGold)),
                    error: (error, stack) => Text('Errore ricalcolo: $error'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoricalSaleItem {
  final String ticker;
  final double exitPrice;
  final double entryPriceAtSale;

  HistoricalSaleItem({required this.ticker, required this.exitPrice, required this.entryPriceAtSale});
}

class _SaleReentryCard extends StatelessWidget {
  final HistoricalSaleItem sale;
  final double currentPrice;
  final bool isOpportunity;
  final double savePercent;

  const _SaleReentryCard({
    required this.sale,
    required this.currentPrice,
    required this.isOpportunity,
    required this.savePercent,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOpportunity ? AureliusTheme.accentGold.withOpacity(0.08) : Colors.transparent,
        border: Border.all(
          color: isOpportunity ? AureliusTheme.accentGold.withOpacity(0.5) : Colors.white10,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sale.ticker, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Venduto a: ${formatter.format(sale.exitPrice)}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Prezzo Odierno:', style: Theme.of(context).textTheme.bodyMedium),
              Text(formatter.format(currentPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          if (isOpportunity) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AureliusTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: AureliusTheme.accentGold, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Opportunità di Rientro! Risparmio del ${savePercent.toStringAsFixed(1)}%',
                      style: const TextStyle(color: AureliusTheme.accentGold, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
