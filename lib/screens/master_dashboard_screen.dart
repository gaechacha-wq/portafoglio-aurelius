import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme.dart';
import '../models/asset_model.dart';
import '../services/price_service.dart';
import '../services/subscription_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/geographical_risk_widget.dart';

final touchedCategoryIndexProvider = StateProvider.autoDispose<int>((ref) => -1);

class MasterDashboardScreen extends ConsumerWidget {
  const MasterDashboardScreen({super.key});

  Color _getCategoryColor(AssetCategory cat) {
    switch (cat) {
      case AssetCategory.finanza: return const Color(0xFFD4AF37);
      case AssetCategory.crypto: return const Color(0xFF00E5FF);
      case AssetCategory.realEstate: return const Color(0xFF4CAF50);
      case AssetCategory.lusso: return const Color(0xFF9C27B0);
      case AssetCategory.cash: return const Color(0xFF607D8B);
      case AssetCategory.metalli: return const Color(0xFFFF9800);
      case AssetCategory.previdenza: return const Color(0xFF03A9F4);
    }
  }

  String _getCategoryName(AssetCategory cat) {
    switch (cat) {
      case AssetCategory.finanza: return "Finanza";
      case AssetCategory.crypto: return "Crypto";
      case AssetCategory.realEstate: return "Immobili";
      case AssetCategory.lusso: return "Lusso";
      case AssetCategory.cash: return "Liquidità";
      case AssetCategory.metalli: return "Metalli";
      case AssetCategory.previdenza: return "Previdenza";
    }
  }

  IconData _getCategoryIcon(AssetCategory cat) {
    switch (cat) {
      case AssetCategory.finanza: return Icons.trending_up;
      case AssetCategory.crypto: return Icons.currency_bitcoin;
      case AssetCategory.realEstate: return Icons.home;
      case AssetCategory.lusso: return Icons.diamond;
      case AssetCategory.cash: return Icons.account_balance_wallet;
      case AssetCategory.metalli: return Icons.savings;
      case AssetCategory.previdenza: return Icons.shield;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subTier = ref.watch(subscriptionProvider);
    
    // GATE ESCLUSIVO: WEALTH
    if (!subTier.canAccessMasterWealth) {
      return Scaffold(
        backgroundColor: AureliusTheme.backgroundBlack,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, size: 80, color: AureliusTheme.accentGold),
                const SizedBox(height: 24),
                Text("Funzione Wealth Exclusive", style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Text("Questa vista è disponibile\nper il piano Wealth.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AureliusTheme.accentGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => context.go('/subscription'),
                    child: Text("Scopri il Piano Wealth", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isPrivacyActive = ref.watch(privacyModeProvider);
    final targetCurrency = ref.watch(targetCurrencyProvider);
    final netWorth = ref.watch(masterNetWorthProvider);
    final grossValue = ref.watch(masterAssetsGrossValueProvider);
    final liabilities = ref.watch(masterLiabilitiesProvider);
    final savingsGoal = ref.watch(savingsGoalProvider);
    final portfolioAsync = ref.watch(portfolioProvider);

    final currencyFormat = NumberFormat.currency(
      locale: 'it_IT', 
      symbol: targetCurrency == 'EUR' ? '€' : (targetCurrency == 'USD' ? '\$' : '£')
    );

    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Patrimonio Globale", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFFD4AF37),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isPrivacyActive ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.white),
            onPressed: () => ref.read(privacyModeProvider.notifier).state = !isPrivacyActive,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            _buildCard1(isPrivacyActive, netWorth, grossValue, liabilities, currencyFormat, targetCurrency),
            const SizedBox(height: 16),
            portfolioAsync.when(
              data: (assets) => _buildCard2And3Info(context, ref, assets, targetCurrency, isPrivacyActive, currencyFormat),
              loading: () => const Center(child: CircularProgressIndicator(color: AureliusTheme.accentGold)),
              error: (e, st) => GlassContainer(child: Text("Errore", style: GoogleFonts.inter(color: Colors.red))),
            ),
            const SizedBox(height: 16),
            portfolioAsync.when(
              data: (assets) => _buildCard4(assets, targetCurrency, isPrivacyActive, currencyFormat),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            _buildCard5(context, ref, netWorth, savingsGoal, currencyFormat),
            const SizedBox(height: 16),
            const GeographicalRiskWidget(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AureliusTheme.accentGold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go('/scenario'),
                icon: const Text("📊", style: TextStyle(fontSize: 18)),
                label: Text("Scenario Planner", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // CARD 1 — Net Worth Globale
  Widget _buildCard1(bool isPrivacy, double netWorth, double grossValue, double liabilities, NumberFormat format, String cur) {
    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("NET WORTH TOTALE", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(border: Border.all(color: AureliusTheme.accentGold), borderRadius: BorderRadius.circular(8)),
                child: Text(cur, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AureliusTheme.accentGold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isPrivacy ? "••••••••" : format.format(netWorth),
            style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ASSET LORDI", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      isPrivacy ? "••••••" : format.format(grossValue),
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PASSIVI", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      isPrivacy ? "••••••" : "-${format.format(liabilities)}",
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFFF44336)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Logic Wrapper per CARD 2 & 3
  Widget _buildCard2And3Info(BuildContext context, WidgetRef ref, List<Asset> assets, String targetCurr, bool isPrivacy, NumberFormat format) {
    if (assets.isEmpty) return const SizedBox.shrink();

    Map<AssetCategory, double> catValues = {};
    Map<AssetCategory, double> catEntryValues = {};
    Map<AssetCategory, double> catGrossValues = {};
    double totalVal = 0.0;

    for (var a in assets) {
      double val = a.totalNetValueIn(targetCurr);
      double cGross = a.totalGrossValueIn(targetCurr);
      double cEntry = (a.entryPrice * a.quantity) * a.conversionRate(targetCurr);

      catValues[a.category] = (catValues[a.category] ?? 0.0) + val;
      catEntryValues[a.category] = (catEntryValues[a.category] ?? 0.0) + cEntry;
      catGrossValues[a.category] = (catGrossValues[a.category] ?? 0.0) + cGross;
      totalVal += val;
    }

    if (totalVal == 0) return const SizedBox.shrink();

    return Column(
      children: [
        _buildCard2(ref, catValues, totalVal, isPrivacy, format),
        const SizedBox(height: 16),
        _buildCard3(catValues, catEntryValues, catGrossValues, totalVal, isPrivacy, format),
      ],
    );
  }

  // CARD 2 — Grafico ad Anello con Legenda
  Widget _buildCard2(WidgetRef ref, Map<AssetCategory, double> catValues, double totalVal, bool isPrivacy, NumberFormat format) {
    final touchedIndex = ref.watch(touchedCategoryIndexProvider);
    int i = 0;
    
    final sortedCats = catValues.keys.toList()..sort((a,b) => catValues[b]!.compareTo(catValues[a]!));

    List<PieChartSectionData> sections = [];
    for (var cat in sortedCats) {
      final isTouched = i == touchedIndex;
      final val = catValues[cat]!;
      final pct = (val / totalVal) * 100;

      sections.add(
        PieChartSectionData(
          color: _getCategoryColor(cat),
          value: val,
          radius: isTouched ? 90.0 : 80.0,
          title: isTouched ? "${pct.toStringAsFixed(1)}%" : "",
          titleStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        )
      );
      i++;
    }

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ALLOCAZIONE PATRIMONIO", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: sections,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                      ref.read(touchedCategoryIndexProvider.notifier).state = -1;
                      return;
                    }
                    ref.read(touchedCategoryIndexProvider.notifier).state = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ...sortedCats.map((cat) {
            final val = catValues[cat]!;
            final pct = (val / totalVal) * 100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: _getCategoryColor(cat))),
                  const SizedBox(width: 8),
                  Text(_getCategoryName(cat), style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
                  const Spacer(),
                  Text("${pct.toStringAsFixed(1)}%", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 13)),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 90,
                    child: Text(
                      isPrivacy ? "••••" : format.format(val),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // CARD 3 — Performance % Per Categoria con Progress Bar
  Widget _buildCard3(Map<AssetCategory, double> catValues, Map<AssetCategory, double> catEntryValues, Map<AssetCategory, double> catGrossValues, double totalVal, bool isPrivacy, NumberFormat format) {
    final sortedCats = catValues.keys.toList()..sort((a,b) => catValues[b]!.compareTo(catValues[a]!));

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PERFORMANCE PER CATEGORIA", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          ...sortedCats.map((cat) {
            final entry = catEntryValues[cat] ?? 0;
            final gross = catGrossValues[cat] ?? 0;
            final val = catValues[cat] ?? 0;
            final pctWeight = (val / totalVal);
            
            double perfPct = entry == 0 ? 0.0 : ((gross - entry) / entry) * 100;
            bool isPositive = perfPct >= 0;
            final perfColor = isPositive ? const Color(0xFF4CAF50) : const Color(0xFFF44336);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Icon(_getCategoryIcon(cat), color: _getCategoryColor(cat), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getCategoryName(cat), style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 6),
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: pctWeight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getCategoryColor(cat),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(isPrivacy ? "••••" : format.format(val), style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        isPrivacy ? "••%" : "${isPositive ? '+' : ''}${perfPct.toStringAsFixed(2)}%",
                        style: GoogleFonts.inter(color: isPrivacy ? const Color(0xFF8E8E93) : perfColor, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // CARD 4 — Cashflow Immobiliare
  Widget _buildCard4(List<Asset> assets, String targetCurr, bool isPrivacy, NumberFormat format) {
    double totalMonthlyRent = 0.0;
    for (var a in assets) {
      if (a.monthlyRent > 0) {
         totalMonthlyRent += a.monthlyRent * a.conversionRate(targetCurr);
      }
    }

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CASHFLOW MENSILE STIMATO", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          if (totalMonthlyRent == 0)
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Nessun immobile a reddito nel portafoglio", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 13)),
            ))
          else ...[
            Row(
              children: [
                const Icon(Icons.arrow_upward_rounded, color: Color(0xFF4CAF50), size: 18),
                const SizedBox(width: 8),
                Text("Entrate da affitti", style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                const Spacer(),
                Text(isPrivacy ? "••••" : "+${format.format(totalMonthlyRent)}", style: GoogleFonts.inter(color: const Color(0xFF4CAF50), fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF8E8E93), size: 18),
                const SizedBox(width: 8),
                Text("Altre entrate / uscite", style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                const Spacer(),
                Text("Configura  ➔", style: GoogleFonts.inter(color: AureliusTheme.accentGold, fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ]
        ],
      ),
    );
  }

  // CARD 5 — Objective & Savings Goal
  Widget _buildCard5(BuildContext context, WidgetRef ref, double netWorth, double savingsGoal, NumberFormat format) {
    double progressPercent = (netWorth / savingsGoal);
    if (progressPercent < 0) progressPercent = 0.0;
    if (progressPercent > 1) progressPercent = 1.0;

    final diff = savingsGoal - netWorth;

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("OBIETTIVO PATRIMONIALE", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit_rounded, color: AureliusTheme.accentGold, size: 16),
                onPressed: () {
                  final ctrl = TextEditingController(text: savingsGoal.toStringAsFixed(0));
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1C1C1E),
                      title: Text("Aggiorna Obiettivo", style: GoogleFonts.inter(color: Colors.white)),
                      content: TextField(
                        controller: ctrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.inter(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AureliusTheme.accentGold)),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text("Annulla", style: GoogleFonts.inter(color: Colors.grey)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black),
                          onPressed: () {
                            final val = double.tryParse(ctrl.text);
                            if (val != null && val > 0) {
                              ref.read(savingsGoalProvider.notifier).state = val;
                            }
                            Navigator.pop(ctx);
                          },
                          child: Text("Aggiorna", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(format.format(savingsGoal), style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
              Text("${(progressPercent * 100).toStringAsFixed(1)}% raggiunto", style: GoogleFonts.inter(fontSize: 13, color: AureliusTheme.accentGold, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressPercent,
              minHeight: 8,
              color: AureliusTheme.accentGold,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 12),
          progressPercent >= 1.0
              ? Text("🎯 Obiettivo raggiunto!", style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold))
              : Text("Ti mancano ${format.format(diff)}", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93))),
        ],
      ),
    );
  }
}
