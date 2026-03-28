import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../services/price_service.dart';
import '../services/subscription_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/asset_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 0) return;
    
    final subTier = ref.read(subscriptionProvider);
    
    if (index == 1) { 
      subTier.canAccessMasterWealth 
          ? context.go('/master') 
          : _showPaywallBottomSheet('Piano Wealth', 'Accedi a funzionalità avanzate, portafogli annidati e reportistica PDF.');
    } else if (index == 2) { 
      (subTier == SubscriptionTier.pro || subTier == SubscriptionTier.wealth) 
          ? context.go('/advisor') 
          : _showPaywallBottomSheet('Piano Pro o superiore', 'L\'intelligenza artificiale di Aurelius richiede un piano premium per generare raccomandazioni.');
    } else if (index == 3) { 
      context.go('/settings');
    }
  }

  void _showPaywallBottomSheet(String requiredPlan, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: GlassContainer(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Icon(Icons.lock_rounded, color: AureliusTheme.accentGold, size: 48),
              const SizedBox(height: 16),
              Text("Funzione Premium", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AureliusTheme.primaryText)),
              const SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: AureliusTheme.secondaryText)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AureliusTheme.accentGold, 
                    foregroundColor: Colors.black, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/subscription');
                  },
                  child: Text("Scopri i Piani", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Non ora", style: GoogleFonts.inter(color: AureliusTheme.secondaryText)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPrivacyActive = ref.watch(privacyModeProvider);
    final targetCurrency = ref.watch(targetCurrencyProvider);
    final netWorthAsync = ref.watch(portfolioProvider); 
    final netWorth = ref.watch(masterNetWorthProvider);
    final globalPerformance = ref.watch(totalFilteredPerformanceProvider);

    // Lettura dal provider reale
    final String currentCategory = ref.watch(selectedCategoryFilterProvider); 
    
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: targetCurrency == 'EUR' ? '€' : (targetCurrency == 'USD' ? '\$' : '£'));
    final String displayValue = isPrivacyActive ? "••••••" : currencyFormat.format(netWorth);
    final bool isPositive = globalPerformance >= 0;
    final String perfPrefix = isPositive ? "▲ +" : "▼ ";
    final String displayPerf = isPrivacyActive ? "▲ ••.••%" : "${perfPrefix}${globalPerformance.abs().toStringAsFixed(2)}%";

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        title: Text("Aurelius", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: CircleAvatar(backgroundColor: AureliusTheme.accentGold, child: Icon(Icons.person, color: Colors.black, size: 16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.grey),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SEZIONE 1: HEADER PATRIMONIO
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: GlassContainer(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Il mio Patrimonio", style: GoogleFonts.inter(fontSize: 13, color: AureliusTheme.secondaryText)),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(isPrivacyActive ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AureliusTheme.secondaryText, size: 20),
                          onPressed: () => ref.read(privacyModeProvider.notifier).state = !isPrivacyActive,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    netWorthAsync.when(
                      data: (_) => Text(displayValue, style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: AureliusTheme.primaryText)),
                      loading: () => const BaseSkeletonLoader(width: 200, height: 40),
                      error: (_, __) => Text("••••••", style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: AureliusTheme.primaryText)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AureliusTheme.cardDark,
                                title: Text("Seleziona Valuta", style: GoogleFonts.inter(color: Colors.white)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: ['EUR', 'USD', 'GBP'].map((c) => ListTile(
                                    title: Text(c, style: GoogleFonts.inter(color: Colors.white)),
                                    onTap: () {
                                      ref.read(targetCurrencyProvider.notifier).state = c;
                                      Navigator.pop(ctx);
                                    },
                                  )).toList(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(border: Border.all(color: AureliusTheme.accentGold), borderRadius: BorderRadius.circular(8)),
                            child: Text(targetCurrency, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AureliusTheme.accentGold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(displayPerf, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isPrivacyActive ? AureliusTheme.secondaryText : (isPositive ? const Color(0xFF4CAF50) : const Color(0xFFF44336)))),
                  ],
                ),
              ),
            ),
          ),

          // SEZIONE 2: FILTRO CATEGORIE
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ["Tutte", "Finanza", "Crypto", "Immobili", "Lusso", "Liquidità", "Metalli", "Previdenza"].map((cat) {
                  final isSelected = currentCategory == cat;
                  return GestureDetector(
                    onTap: () => ref.read(selectedCategoryFilterProvider.notifier).state = cat,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.05),
                        border: Border.all(color: isSelected ? AureliusTheme.accentGold : Colors.white.withOpacity(0.1), width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? AureliusTheme.accentGold : AureliusTheme.secondaryText)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // SEZIONE 3: LISTA ASSET
          netWorthAsync.when(
            data: (assets) {
              final filtered = ref.watch(filteredPortfolioProvider);
              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.account_balance_wallet_rounded, size: 64, color: Color(0xFF8E8E93)),
                        const SizedBox(height: 16),
                        Text("Nessun asset trovato", style: GoogleFonts.inter(fontSize: 16, color: AureliusTheme.secondaryText)),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(foregroundColor: AureliusTheme.accentGold, side: const BorderSide(color: AureliusTheme.accentGold)),
                          onPressed: () => context.go('/add-asset'),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text("Aggiungi il primo asset"),
                        )
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => AssetCard(asset: filtered[index], isPrivacyMode: isPrivacyActive, targetCurrency: targetCurrency),
                    childCount: filtered.length,
                  ),
                ),
              );
            },
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate((context, index) => const Padding(padding: EdgeInsets.only(left: 16, right: 16, bottom: 16), child: BaseSkeletonLoader(width: double.infinity, height: 80)), childCount: 3),
            ),
            error: (e, st) => SliverFillRemaining(child: Center(child: Text("Errore", style: GoogleFonts.inter(color: Colors.red)))),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AureliusTheme.accentGold,
        onPressed: () => context.go('/add-asset'),
        child: const Icon(Icons.add_rounded, color: Colors.black),
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              selectedItemColor: AureliusTheme.accentGold,
              unselectedItemColor: const Color(0xFF8E8E93),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
              onTap: _onTabTapped,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.pie_chart_rounded), label: "Master"),
                BottomNavigationBarItem(icon: Icon(Icons.smart_toy_rounded), label: "AI"),
                BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Impostazioni"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
