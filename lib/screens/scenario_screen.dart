import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme.dart';
import '../models/asset_model.dart';
import '../services/price_service.dart';
import '../services/subscription_service.dart';
import '../services/monte_carlo_service.dart';
import '../widgets/glass_container.dart';

class ScenarioScreen extends ConsumerStatefulWidget {
  const ScenarioScreen({super.key});

  @override
  ConsumerState<ScenarioScreen> createState() => _ScenarioScreenState();
}

class _ScenarioScreenState extends ConsumerState<ScenarioScreen> {
  int _years = 10;
  int _simulations = 1000;
  MonteCarloResult? _result;
  bool _isSimulating = false;

  @override
  Widget build(BuildContext context) {
    final subTier = ref.watch(subscriptionProvider);
    final isPrivacyMode = ref.watch(privacyModeProvider);

    if (subTier == SubscriptionTier.base) {
      return Scaffold(
        backgroundColor: AureliusTheme.backgroundBlack,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Scenario Planner", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: AureliusTheme.accentGold),
            onPressed: () => context.canPop() ? context.pop() : context.go('/dashboard'),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassContainer(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_rounded, size: 64, color: AureliusTheme.accentGold),
                  const SizedBox(height: 24),
                  Text("Scenario Planner", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  Text(
                    "Il modulo di stress test Monte Carlo e proiezione statistica richiede il piano Pro o Wealth. Prevedi i crash e le bull run.",
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
                    child: Text("Aggiorna Piano", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Scenario Planner", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AureliusTheme.accentGold),
          onPressed: () => context.canPop() ? context.pop() : context.go('/dashboard'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD 1: PARAMETRI
            GlassContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CONFIGURA SIMULAZIONE", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Orizzonte temporale", style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
                            const SizedBox(height: 8),
                            Text("$_years anni", style: GoogleFonts.inter(color: AureliusTheme.accentGold, fontSize: 28, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.remove_circle_outline, color: AureliusTheme.accentGold),
                                  onPressed: () { if (_years > 1) setState(() => _years--); },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.add_circle_outline, color: AureliusTheme.accentGold),
                                  onPressed: () { if (_years < 30) setState(() => _years++); },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 60, color: Colors.white.withOpacity(0.1)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Simulazioni", style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
                            const SizedBox(height: 8),
                            DropdownButton<int>(
                              value: _simulations,
                              dropdownColor: AureliusTheme.cardDark,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down, color: AureliusTheme.accentGold),
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              items: [500, 1000, 5000, 10000].map((int val) {
                                return DropdownMenuItem<int>(
                                  value: val,
                                  child: Text(NumberFormat.decimalPattern('it_IT').format(val)),
                                );
                              }).toList(),
                              onChanged: (val) { if (val != null) setState(() => _simulations = val); },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AureliusTheme.accentGold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isSimulating ? null : () async {
                        setState(() => _isSimulating = true);
                        try {
                          final assets = ref.read(portfolioProvider).valueOrNull ?? [];
                          final targetCurr = ref.read(targetCurrencyProvider);
                          final service = ref.read(monteCarloServiceProvider);
                          // simulazione off-thread se possibile (qui tramite future logica isolata non strict microtask delay)
                          await Future.delayed(const Duration(milliseconds: 300)); 
                          final res = service.simulate(assets: assets, years: _years, simulations: _simulations, targetCurrency: targetCurr);
                          if(mounted) setState(() => _result = res);
                        } finally {
                          if(mounted) setState(() => _isSimulating = false);
                        }
                      },
                      child: _isSimulating 
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text("Avvia Simulazione", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
            
            if (_result != null) ...[
              const SizedBox(height: 20),
              
              // CARD 2: RISULTATI
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("RISULTATI TRA $_years ANNI", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildPercentileRow("Scenario peggiore (5%)", _result!.percentile5, const Color(0xFFF44336), 18, isPrivacyMode),
                    const SizedBox(height: 12),
                    _buildPercentileRow("Scenario conservativo (25%)", _result!.percentile25, const Color(0xFFFF9800), 18, isPrivacyMode),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: AureliusTheme.accentGold, width: 2), borderRadius: BorderRadius.circular(8)),
                      child: _buildPercentileRow("Scenario mediano (50%)", _result!.percentile50, Colors.white, 22, isPrivacyMode),
                    ),
                    const SizedBox(height: 12),
                    _buildPercentileRow("Scenario ottimistico (75%)", _result!.percentile75, const Color(0xFF4CAF50), 18, isPrivacyMode),
                    const SizedBox(height: 12),
                    _buildPercentileRow("Scenario migliore (95%)", _result!.percentile95, const Color(0xFF4CAF50), 18, isPrivacyMode),
                    const SizedBox(height: 16),
                    Divider(color: AureliusTheme.accentGold.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    _buildPercentileRow("Valore atteso medio", _result!.expectedValue, AureliusTheme.accentGold, 20, isPrivacyMode),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // CARD 3: GRAFICO DISTRIBUZIONE
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DISTRIBUZIONE PROBABILITÀ", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: _buildChart(_result!.simulationPaths, isPrivacyMode),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Basato su $_simulations simulazioni con dati storici di volatilità per categoria asset.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // CARD 4: INSIGHT TESTUALI
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("INTERPRETAZIONE", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93))),
                    const SizedBox(height: 16),
                    _buildInsights(ref, _result!, _years),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentileRow(String label, double val, Color color, double fontSize, bool privacy) {
    final targetCurrency = ref.read(targetCurrencyProvider);
    final formatter = NumberFormat.currency(locale: 'it_IT', symbol: targetCurrency == 'GBP' ? '£' : (targetCurrency=='USD'? '\$' : '€'));
    final display = privacy ? "••••••" : formatter.format(val);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 13))),
        Text(display, style: GoogleFonts.inter(color: color, fontSize: fontSize, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildChart(List<double> paths, bool privacy) {
    if (paths.isEmpty) return const SizedBox();
    
    final minVal = paths.first;
    final maxVal = paths.last;
    if (maxVal == minVal) return const Center(child: Text("Dati insufficienti o volatilità nulla."));

    final range = maxVal - minVal;
    final bucketSize = range / 10;
    
    List<int> buckets = List.filled(10, 0);
    for (var v in paths) {
      int idx = ((v - minVal) / bucketSize).floor();
      if (idx == 10) idx = 9;
      buckets[idx]++;
    }

    final maxBucket = buckets.reduce(max);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxBucket.toDouble() * 1.1,
        barTouchData: BarTouchData(enabled: false), // semplificato
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(10, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: buckets[i].toDouble(),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF44336), Color(0xFF4CAF50)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 16,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInsights(WidgetRef ref, MonteCarloResult res, int years) {
    final assets = ref.read(portfolioProvider).valueOrNull ?? [];
    final targetCurrency = ref.read(targetCurrencyProvider);
    final totalNow = assets.fold(0.0, (s, a) => s + a.totalNetValueIn(targetCurrency));
    
    if (totalNow <= 0) return const Text("Nessun patrimonio da analizzare.");

    int growthCount = res.simulationPaths.where((p) => p > totalNow).length;
    double probability = (growthCount / res.simulationPaths.length) * 100;

    double cryptoVal = assets.where((a) => a.category == AssetCategory.crypto).fold(0.0, (s, a) => s + a.totalNetValueIn(targetCurrency));
    double cryptoPct = cryptoVal / totalNow;

    final formatter = NumberFormat.currency(locale: 'it_IT', symbol: targetCurrency == 'GBP' ? '£' : (targetCurrency=='USD'? '\$' : '€'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _insightRow(Icons.trending_up, "Il tuo portafoglio ha una probabilità del ${probability.toStringAsFixed(1)}% di crescere nei prossimi $years anni."),
        const SizedBox(height: 12),
        _insightRow(Icons.center_focus_strong, "Nello scenario più probabile, il tuo patrimonio raggiungerà ${formatter.format(res.percentile50)}."),
        const SizedBox(height: 12),
        if (cryptoPct > 0.20)
          _insightRow(Icons.warning_amber_rounded, "L'alta esposizione crypto (${(cryptoPct*100).toStringAsFixed(1)}%) aumenta significativamente la volatilità del portafoglio.")
        else
          _insightRow(Icons.shield_rounded, "Il tuo portafoglio mostra un buon equilibrio rischio/rendimento."),
      ],
    );
  }

  Widget _insightRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AureliusTheme.accentGold, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: GoogleFonts.inter(color: Colors.white, fontSize: 13, height: 1.5))),
      ],
    );
  }
}
