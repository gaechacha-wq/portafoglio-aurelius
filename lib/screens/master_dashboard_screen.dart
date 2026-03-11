import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_glass_container.dart';
import '../services/price_service.dart';
import '../services/ai_aurelius_service.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class MasterDashboardScreen extends ConsumerWidget {
  const MasterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netWorth = ref.watch(masterNetWorthProvider);
    final grossAssets = ref.watch(masterAssetsGrossValueProvider);
    final liabilities = ref.watch(masterLiabilitiesProvider);
    final isPrivacy = ref.watch(privacyModeProvider);
    final targetCurr = ref.watch(targetCurrencyProvider);
    final cashflow = ref.watch(cashflowProvider);
    final savingsGoal = ref.watch(savingsGoalProvider);
    
    String symbol = '€';
    String locale = 'it_IT';
    if (targetCurr == 'USD') { symbol = '\$'; locale = 'en_US'; }
    if (targetCurr == 'GBP') { symbol = '£'; locale = 'en_GB'; }
    final currencyFormatter = NumberFormat.currency(locale: locale, symbol: symbol);
    
    // Allocation Chart Data & AI Advice
    final assetsAsync = ref.watch(portfolioProvider);
    final aiRef = ref.watch(aiAdvisorProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestione Globale Patrimonio'),
        actions: [
          DropdownButton<String>(
            value: targetCurr,
            dropdownColor: AureliusTheme.cardDark,
            underline: const SizedBox(),
            icon: const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Icon(Icons.arrow_drop_down, color: AureliusTheme.accentGold),
            ),
            style: const TextStyle(color: AureliusTheme.accentGold, fontWeight: FontWeight.bold),
            items: ['EUR', 'USD', 'GBP'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                ref.read(targetCurrencyProvider.notifier).state = newValue;
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(CupertinoIcons.share_up, color: AureliusTheme.accentGold),
            color: AureliusTheme.cardDark,
            onSelected: (value) {
              if (value == 'tax') _generateTaxReport(context, ref);
              if (value == 'csv') _generateCsvExport(context, ref);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'tax',
                child: Row(
                  children: [Icon(CupertinoIcons.doc_text, color: AureliusTheme.accentGold, size: 20), SizedBox(width: 8), Text('Report Fiscale')],
                ),
              ),
              const PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [Icon(CupertinoIcons.table, color: Colors.greenAccent, size: 20), SizedBox(width: 8), Text('Esporta CSV')],
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Worth Card with FLUID ANIMATION
            GlassContainer(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('NET WORTH', 
                    style: TextStyle(
                      color: AureliusTheme.accentGold, 
                      letterSpacing: 2.0, 
                      fontSize: 14, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 12),
                  // Animazione fluida del numero!
                  Hero(
                    tag: 'master_balance',
                    child: Material(
                      type: MaterialType.transparency,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(begin: 0, end: netWorth),
                        builder: (context, value, child) {
                          return Semantics(
                            label: 'Patrimonio netto totale',
                            value: currencyFormatter.format(value),
                            child: isPrivacy
                              ? ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Text('$symbol *******', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48, fontWeight: FontWeight.bold))
                                )
                              : Text(currencyFormatter.format(value), 
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48, fontWeight: FontWeight.bold)
                                ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MetricCol(title: '∑ Assets', value: currencyFormatter.format(grossAssets), color: Colors.greenAccent),
                      Container(height: 40, width: 1, color: Colors.white24),
                      _MetricCol(title: '∑ Passività', value: currencyFormatter.format(liabilities), color: Colors.redAccent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Obiettivo Finanziario
            Text('Obiettivo Finanziario', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            GlassContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text('Progresso Verso il Traguardo', style: TextStyle(color: Colors.white70)),
                       Text('${(netWorth / savingsGoal * 100).clamp(0, 100).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
                     ],
                   ),
                   const SizedBox(height: 16),
                   ClipRRect(
                     borderRadius: BorderRadius.circular(10),
                     child: LinearProgressIndicator(
                       value: (netWorth / savingsGoal).clamp(0.0, 1.0),
                       minHeight: 12,
                       backgroundColor: Colors.white10,
                       valueColor: const AlwaysStoppedAnimation<Color>(AureliusTheme.accentGold),
                     ),
                   ),
                   const SizedBox(height: 12),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(currencyFormatter.format(netWorth), style: const TextStyle(fontSize: 12)),
                       Text('Obiettivo: ${currencyFormatter.format(savingsGoal)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                     ],
                   )
                ],
              )
            ),
            const SizedBox(height: 30),

            // Cashflow Family Section
            Text('Flussi di Cassa Annuali (Famiglia)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            GlassContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reddito Personale Netto', style: TextStyle(color: Colors.white70)),
                      Text(currencyFormatter.format(cashflow.personalIncome), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reddito Coniuge Netto', style: TextStyle(color: Colors.white70)),
                      Text(currencyFormatter.format(cashflow.spouseIncome), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Entrate Familiari Totali', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(currencyFormatter.format(cashflow.familyIncome), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent, fontSize: 16)),
                    ],
                  ),
                ],
              )
            ),
            const SizedBox(height: 30),

            // AI Allocation Advice
            FutureBuilder<String>(
              future: aiRef.analyzeAllocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AureliusTheme.accentGold));
                }
                final advice = snapshot.data ?? 'Analisi non disponibile.';
                return GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.psychology, color: AureliusTheme.accentGold, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Aurelius Advice', style: TextStyle(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
                            const SizedBox(height: 4),
                            Text(advice, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
            const SizedBox(height: 30),

            // Advanced Asset Allocation Pie Chart
            Text('Ripartizione Globale', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            GlassContainer(
              width: double.infinity,
              height: 280,
              padding: const EdgeInsets.all(20),
              child: assetsAsync.maybeWhen(
                data: (assets) {
                  double realEstateValue = assets.where((a) => a.category == AssetCategory.realEstate).fold(0.0, (s, a) => s + a.totalNetValue);
                  double finanzaValue = assets.where((a) => a.category == AssetCategory.finanza).fold(0.0, (s, a) => s + a.totalNetValue);
                  double cryptoValue = assets.where((a) => a.category == AssetCategory.crypto).fold(0.0, (s, a) => s + a.totalNetValue);
                  double cashValue = assets.where((a) => a.category == AssetCategory.cash).fold(0.0, (s, a) => s + a.totalNetValue);
                  double metalliValue = assets.where((a) => a.category == AssetCategory.metalli).fold(0.0, (s, a) => s + a.totalNetValue);
                  double lussoValue = assets.where((a) => a.category == AssetCategory.lusso).fold(0.0, (s, a) => s + a.totalNetValue);
                  double previdenzaValue = assets.where((a) => a.category == AssetCategory.previdenza).fold(0.0, (s, a) => s + a.totalNetValue);
                  
                  // Gruppo Investimenti (Finanza + Crypto)
                  double investimentiValue = finanzaValue + cryptoValue;
                  
                  double total = realEstateValue + investimentiValue + cashValue + metalliValue + lussoValue + previdenzaValue;
                  if (total == 0) return const Center(child: Text('Nessun Asset.'));
                  
                  return Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                color: Colors.blueAccent, 
                                value: investimentiValue, 
                                title: '${(investimentiValue/total*100).toStringAsFixed(0)}%',
                                radius: 50,
                                titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),
                              ),
                              PieChartSectionData(
                                color: AureliusTheme.accentGold, 
                                value: realEstateValue, 
                                title: '${(realEstateValue/total*100).toStringAsFixed(0)}%',
                                radius: 60,
                                titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                              ),
                              PieChartSectionData(
                                color: Colors.greenAccent, 
                                value: cashValue, 
                                title: '${(cashValue/total*100).toStringAsFixed(0)}%',
                                radius: 45,
                                titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                              ),
                              if (metalliValue > 0)
                                PieChartSectionData(
                                  color: Colors.blueGrey, 
                                  value: metalliValue, 
                                  title: '${(metalliValue/total*100).toStringAsFixed(0)}%',
                                  radius: 40,
                                  titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),
                                ),
                              if (lussoValue > 0)
                                PieChartSectionData(
                                  color: const Color(0xFF800020), // Bordeaux
                                  value: lussoValue, 
                                  title: '${(lussoValue/total*100).toStringAsFixed(0)}%',
                                  radius: 48,
                                  titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),
                                ),
                              if (previdenzaValue > 0)
                                PieChartSectionData(
                                  color: Colors.purpleAccent, 
                                  value: previdenzaValue, 
                                  title: '${(previdenzaValue/total*100).toStringAsFixed(0)}%',
                                  radius: 42,
                                  titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),
                                ),
                            ]
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Legend(color: Colors.blueAccent, title: 'Investimenti\n(Finanza+Crypto)'),
                              const SizedBox(height: 12),
                              _Legend(color: AureliusTheme.accentGold, title: 'Immobiliare'),
                              const SizedBox(height: 12),
                              _Legend(color: Colors.greenAccent, title: 'Liquidità'),
                              if (metalliValue > 0) ...[
                                const SizedBox(height: 12),
                                _Legend(color: Colors.blueGrey, title: 'Metalli'),
                              ],
                              if (lussoValue > 0) ...[
                                const SizedBox(height: 12),
                                _Legend(color: const Color(0xFF800020), title: 'Beni di Lusso'),
                              ],
                              if (previdenzaValue > 0) ...[
                                const SizedBox(height: 12),
                                _Legend(color: Colors.purpleAccent, title: 'Previdenza'),
                              ],
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                orElse: () => const Center(child: CircularProgressIndicator(color: AureliusTheme.accentGold)),
              ),
            ),
            
            const SizedBox(height: 40),
            Text('Composizione Portafoglio', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            
            // List of specific assets grouped by Liability and Assets for the Dashboard
            assetsAsync.maybeWhen(
              data: (assets) {
                final realEstates = assets.where((a) => a.category == AssetCategory.realEstate).toList();
                final cryptos = assets.where((a) => a.category == AssetCategory.crypto).toList();
                
                return Column(
                   children: [
                     if (realEstates.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(CupertinoIcons.building_2_fill, color: AureliusTheme.accentGold),
                            const SizedBox(width: 8),
                            Text('Passività / Mutui', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AureliusTheme.accentGold)),
                           ],
                        ),
                        const SizedBox(height: 12),
                        ...realEstates.map((re) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassContainer(
                             padding: const EdgeInsets.all(16),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(re.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                     Text('Valore: ${currencyFormatter.format(re.totalGrossValue)}', style: Theme.of(context).textTheme.bodySmall),
                                   ],
                                 ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [
                                     Text('- ${currencyFormatter.format(re.mortgageResidual)}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                                     Text('Mutuo Residuo', style: Theme.of(context).textTheme.bodySmall),
                                   ],
                                 )
                               ]
                             )
                          ),
                        )),
                        const SizedBox(height: 20),
                     ],
                     
                     if (cryptos.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.memory, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text('Frontiera Digitale (Crypto)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueAccent)),
                           ],
                        ),
                        const SizedBox(height: 12),
                        ...cryptos.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NeonGlassContainer(
                             glowColor: Colors.blueAccent,
                             padding: const EdgeInsets.all(16),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(c.ticker, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, shadows: [Shadow(color: Colors.blueAccent, blurRadius: 4)])),
                                     Text(c.cryptoLocation, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.lightBlue)),
                                   ],
                                 ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [
                                     Text(currencyFormatter.format(c.totalNetValue), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                     Text('${c.quantity} pz', style: Theme.of(context).textTheme.bodySmall),
                                   ],
                                 )
                               ]
                             )
                          ),
                        )),
                        const SizedBox(height: 20),
                     ],
                     
                     if (assets.any((a) => a.category == AssetCategory.metalli)) ...[
                        Row(
                          children: [
                            const Icon(CupertinoIcons.sparkles, color: Colors.blueGrey),
                            const SizedBox(width: 8),
                            Text('Metalli Preziosi', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueGrey)),
                           ],
                        ),
                        const SizedBox(height: 12),
                        ...assets.where((a) => a.category == AssetCategory.metalli).map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassContainer(
                             padding: const EdgeInsets.all(16),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                     Text(m.bank, style: Theme.of(context).textTheme.bodySmall),
                                   ],
                                 ),
                                 Text(currencyFormatter.format(m.totalNetValue), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                               ]
                             )
                          ),
                        )),
                        const SizedBox(height: 20),
                     ],
                     
                     if (assets.any((a) => a.category == AssetCategory.lusso)) ...[
                        Row(
                          children: [
                            const Icon(CupertinoIcons.car_detailed, color: Color(0xFF800020)),
                            const SizedBox(width: 8),
                            Text('Beni di Lusso', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF800020))),
                           ],
                        ),
                        const SizedBox(height: 12),
                        ...assets.where((a) => a.category == AssetCategory.lusso).map((l) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassContainer(
                             padding: const EdgeInsets.all(16),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(l.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                     Text(l.bank, style: Theme.of(context).textTheme.bodySmall),
                                   ],
                                 ),
                                 Text(currencyFormatter.format(l.totalNetValue), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                               ]
                             )
                          ),
                        )),
                        const SizedBox(height: 20),
                     ],
                     
                     if (assets.any((a) => a.category == AssetCategory.previdenza)) ...[
                        Row(
                          children: [
                            const Icon(CupertinoIcons.money_dollar_circle_fill, color: Colors.purpleAccent),
                            const SizedBox(width: 8),
                            Text('Previdenza & Vita', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.purpleAccent)),
                           ],
                        ),
                        const SizedBox(height: 12),
                        ...assets.where((a) => a.category == AssetCategory.previdenza).map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassContainer(
                             padding: const EdgeInsets.all(16),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                     if (p.expirationDate != null)
                                       Text('Scadenza: ${DateFormat('MM/yyyy').format(p.expirationDate!)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.purpleAccent)),
                                   ],
                                 ),
                                 Text(currencyFormatter.format(p.totalNetValue), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                               ]
                             )
                          ),
                        )),
                     ]
                   ]
                );
              },
              orElse: () => const SizedBox(),
            ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _generateTaxReport(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.read(portfolioProvider);
    
    assetsAsync.whenData((assets) {
      double plusvalenze = 0;
      double minusvalenze = 0;
      StringBuffer report = StringBuffer();

      report.writeln('=== REPORT FISCALE: ZAINETTO AURELIUS ===\n');
      report.writeln('Generato il: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}\n');
      report.writeln('-----------------------------------------');

      for (var a in assets) {
        if (a.category == AssetCategory.finanza || a.category == AssetCategory.crypto) {
          if (a.profitLoss > 0) {
            plusvalenze += a.profitLoss;
            report.writeln('[+] ${a.ticker} (${a.bank}): +€${a.profitLoss.toStringAsFixed(2)}');
          } else if (a.profitLoss < 0) {
            minusvalenze += a.profitLoss.abs();
            report.writeln('[-] ${a.ticker} (${a.bank}): -€${a.profitLoss.abs().toStringAsFixed(2)}');
          }
        }
      }

      report.writeln('-----------------------------------------');
      report.writeln('TOTALE PLUSVALENZE:  +€${plusvalenze.toStringAsFixed(2)}');
      report.writeln('TOTALE MINUSVALENZE: -€${minusvalenze.toStringAsFixed(2)}');
      report.writeln('BILANCIO NETTO:       €${(plusvalenze - minusvalenze).toStringAsFixed(2)}');
      report.writeln('=========================================');

      // Simuliamo l'export copiando nella clipboard e mostrando un dialog
      Clipboard.setData(ClipboardData(text: report.toString()));
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AureliusTheme.cardDark,
          title: const Row(
            children: [
              Icon(CupertinoIcons.checkmark_seal_fill, color: AureliusTheme.accentGold),
              SizedBox(width: 8),
              Text('Report Generato', style: TextStyle(color: AureliusTheme.accentGold)),
            ],
          ),
          content: const Text('Il Report Fiscale è stato calcolato e copiato negli appunti pronto per essere inviato al tuo commercialista.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Chiudi', style: TextStyle(color: Colors.white)),
            )
          ],
        )
      );
    });
  }

  void _generateCsvExport(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.read(portfolioProvider);
    
    assetsAsync.whenData((assets) {
      StringBuffer csv = StringBuffer();
      csv.writeln('Categoria,Ticker,Nome,Banca/Locazione,Quantità,Prezzo Ingresso,Prezzo Attuale,Valore Lordo Orig.,Valore Netto Orig.,Valuta');

      for (var a in assets) {
        csv.writeln('${a.category.name},${a.ticker},"${a.name}","${a.category == AssetCategory.crypto ? a.cryptoLocation : a.bank}",${a.quantity},${a.entryPrice},${a.currentPrice},${a.totalGrossValue},${a.totalNetValue},${a.currency}');
      }

      Clipboard.setData(ClipboardData(text: csv.toString()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dati CSV copiati negli appunti.'), backgroundColor: Colors.green));
    });
  }
}

class _MetricCol extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricCol({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String title;

  const _Legend({required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 13), softlyWrap: true)),
      ],
    );
  }
}
