import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_glass_container.dart';
import '../services/price_service.dart';
import 'rientro_post_vendita.dart';
import 'ai_advisor_screen.dart';
import 'scanner_screen.dart';
import 'master_dashboard_screen.dart';
import 'help_screen.dart';
import 'info_screen.dart';
import '../services/subscription_service.dart';
import 'subscription_screen.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

final onboardingShownProvider = StateProvider<bool>((ref) => false);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankFilter = ref.watch(selectedBankFilterProvider);
    final portfolioAsync = ref.watch(portfolioProvider); // Per la lista completa
    final filteredAssets = ref.watch(filteredPortfolioProvider); // Per i calcoli
    final totalValue = ref.watch(totalFilteredValueProvider);
    final totalPerformance = ref.watch(totalFilteredPerformanceProvider);
    final isPrivacy = ref.watch(privacyModeProvider);
    
    final currencyFormatter = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(onboardingShownProvider)) {
        ref.read(onboardingShownProvider.notifier).state = true;
        _showAureliusWelcomeDialog(context);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buongiorno, Utente', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text('Portfolio Aurelius', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoScreen())),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white12,
                          child: Icon(Icons.info_outline, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => ref.read(privacyModeProvider.notifier).state = !isPrivacy,
                        child: CircleAvatar(
                          backgroundColor: Colors.white12,
                          child: Icon(isPrivacy ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white12,
                          child: Icon(CupertinoIcons.question_circle, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
                        child: const CircleAvatar(
                          backgroundColor: AureliusTheme.accentGold,
                          child: Icon(Icons.workspace_premium, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bank Filters (Apple style circular buttons)
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(label: 'Tutte', isSelected: bankFilter == 'Tutte', onTap: () => ref.read(selectedBankFilterProvider.notifier).state = 'Tutte'),
                    _FilterChip(label: 'Fineco', isSelected: bankFilter == 'Fineco', onTap: () => ref.read(selectedBankFilterProvider.notifier).state = 'Fineco'),
                    _FilterChip(label: 'Intesa', isSelected: bankFilter == 'Intesa', onTap: () => ref.read(selectedBankFilterProvider.notifier).state = 'Intesa'),
                    _FilterChip(label: 'Revolut', isSelected: bankFilter == 'Revolut', onTap: () => ref.read(selectedBankFilterProvider.notifier).state = 'Revolut'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Main Balance Card
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patrimonio ${bankFilter == "Tutte" ? "Totale" : bankFilter}', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Hero(
                      tag: 'master_balance',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Semantics(
                          label: 'Patrimonio Totale visualizzato',
                          value: currencyFormatter.format(totalValue),
                          child: isPrivacy 
                            ? ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Text('€ *******', style: Theme.of(context).textTheme.displayLarge),
                              )
                            : Text(currencyFormatter.format(totalValue), style: Theme.of(context).textTheme.displayLarge),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          totalPerformance >= 0 ? Icons.trending_up : Icons.trending_down, 
                          color: totalPerformance >= 0 ? Colors.greenAccent : Colors.redAccent, 
                          size: 20
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${totalPerformance >= 0 ? '+' : ''}${totalPerformance.toStringAsFixed(2)}% Totale', 
                          style: TextStyle(
                            color: totalPerformance >= 0 ? Colors.greenAccent : Colors.redAccent, 
                            fontSize: 14
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Zainetto Fiscale Widget
              Text('Zainetto Fiscale', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _ZainettoFiscaleWidget(assets: filteredAssets),
              const SizedBox(height: 30),

              // Scanner Screenshot Button (PRIMARY CTA)
              GestureDetector(
                onTap: () {
                   if (ref.read(subscriptionProvider).canAccessScanner) {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerScreen()));
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Richiede Piano Pro o superiore')));
                     Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
                   }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AureliusTheme.accentGold, Color(0xFFC5A059)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AureliusTheme.accentGold.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.camera_viewfinder, color: Colors.black, size: 30),
                      const SizedBox(width: 12),
                      const Text(
                        'Upload & Scan Dati', 
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black,
                          letterSpacing: 0.5,
                        )
                      ),
                      if (!ref.watch(subscriptionProvider).canAccessScanner)
                         const Padding(
                           padding: EdgeInsets.only(left: 8.0),
                           child: Icon(Icons.lock, color: Colors.black54, size: 20),
                         )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.account_balance_wallet,
                      label: 'Master Wealth',
                      isLocked: !ref.watch(subscriptionProvider).canAccessMasterWealth,
                      onTap: () {
                        if (ref.read(subscriptionProvider).canAccessMasterWealth) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MasterDashboardScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Esclusiva Piano Wealth Eliite')));
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.analytics,
                      label: 'Rientro Post-Vendita',
                      isLocked: false,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RientroPostVenditaScreen())),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.smart_toy,
                      label: 'AI Advisor',
                      isLocked: false,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiAdvisorScreen())),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Asset List
              Text('Posizioni ${bankFilter == "Tutte" ? "" : "($bankFilter)"}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              
              portfolioAsync.when(
                data: (allAssets) {
                  if (filteredAssets.isEmpty) {
                    return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Nessuna posizione in $bankFilter.', style: Theme.of(context).textTheme.bodyMedium)));
                  }
                  return Column(
                    children: filteredAssets.map((asset) => _AssetListItem(asset: asset)).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AureliusTheme.accentGold)),
                error: (error, stack) => Center(child: Text('Errore: $error')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAureliusWelcomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AureliusTheme.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AureliusTheme.accentGold, width: 1)),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AureliusTheme.accentGold,
              child: Icon(Icons.psychology, color: Colors.black),
            ),
            const SizedBox(width: 12),
            const Text('Aurelius Advisor', style: TextStyle(color: AureliusTheme.accentGold, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Benvenuto nel tuo nuovo centro di comando finanziario, Portafoglio Aurelius.\n\n'
          'Siamo pronti per mappare ogni tua fonte di ricchezza: dalla Liquidità alle Crypto, fino a Immobili e Lusso.\n\n'
          'Ho caricato il tuo Manuale Operativo in memoria. Suggerisco di leggerlo prima di iniziare ad allocare i capitali.',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            child: const Text('Inizia a Esplorare', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AureliusTheme.accentGold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Apri Manuale d\'Uso', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()));
            },
          )
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AureliusTheme.accentGold : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AureliusTheme.accentGold : Colors.white10),
        ),
        child: Center(
          child: Text(
            label, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: isSelected ? Colors.black : Colors.white,
            )
          ),
        ),
      ),
    );
  }
}

// Widget per Zainetto Fiscale
class _ZainettoFiscaleWidget extends ConsumerWidget {
  final List<Asset> assets;
  const _ZainettoFiscaleWidget({required this.assets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPrivacy = ref.watch(privacyModeProvider);
    double plusvalenze = 0;
    double minusvalenze = 0;
    
    for (var asset in assets) {
      if (asset.profitLoss > 0) {
        plusvalenze += asset.profitLoss;
      } else {
        minusvalenze += asset.profitLoss.abs();
      }
    }

    final currencyFormatter = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Plusvalenze Latenti', style: Theme.of(context).textTheme.bodyMedium),
              Text('+ ${currencyFormatter.format(plusvalenze)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Minusvalenze Latenti', style: Theme.of(context).textTheme.bodyMedium),
              Text('- ${currencyFormatter.format(minusvalenze)}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bilancio Fiscale', style: TextStyle(fontWeight: FontWeight.bold)),
              isPrivacy
                ? ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Text('€ ***', style: TextStyle(color: Colors.white)))
                : Text(
                    currencyFormatter.format(plusvalenze - minusvalenze), 
                    style: TextStyle(
                      color: (plusvalenze - minusvalenze) >= 0 ? Colors.greenAccent : Colors.redAccent, 
                      fontWeight: FontWeight.bold
                    )
                  ),
            ],
          ),
        ],
      ),
    );
  }
}


class _AssetListItem extends ConsumerWidget {
  final Asset asset;

  const _AssetListItem({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetCurr = ref.watch(targetCurrencyProvider);
    String symbol = '€';
    String locale = 'it_IT';
    if (targetCurr == 'USD') { symbol = '\$'; locale = 'en_US'; }
    if (targetCurr == 'GBP') { symbol = '£'; locale = 'en_GB'; }
    
    final currencyFormatter = NumberFormat.currency(locale: asset.currency == 'USD' ? 'en_US' : 'it_IT', symbol: asset.currency == 'USD' ? '\$' : '€');
    final isProfit = asset.profitLossPercent >= 0;
    final isCrypto = asset.category == AssetCategory.crypto;
    final isPrivacy = ref.watch(privacyModeProvider);

    Widget content = Semantics(
      label: 'Dettagli Asset',
      value: '${asset.name}, ticker ${asset.ticker}, current price',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(asset.ticker, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isCrypto ? null : null, shadows: isCrypto ? [Shadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 4)] : null)),
              Text(asset.name, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                    child: Text(asset.bank, style: const TextStyle(fontSize: 10, color: AureliusTheme.secondaryText)),
                  ),
                  if (isCrypto && asset.cryptoLocation.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(asset.cryptoLocation, style: const TextStyle(fontSize: 10, color: Colors.lightBlueAccent)),
                    ),
                  ]
                ],
              )
            ],
          ),
        ),
        // Middle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('In: ${currencyFormatter.format(asset.entryPrice)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
              isPrivacy 
                ? ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), child: const Text('***', style: TextStyle(fontWeight: FontWeight.bold)))
                : Text('Att: ${currencyFormatter.format(asset.currentPrice)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Right side
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isProfit ? '+' : ''}${asset.profitLossPercent.toStringAsFixed(2)}%',
              style: TextStyle(
                color: isProfit ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(isCrypto ? '${asset.quantity} pz' : '${asset.quantity.toInt()} pz', style: Theme.of(context).textTheme.bodyMedium),
          ],
        )
      ],
    ));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: isCrypto 
        ? NeonGlassContainer(
            padding: const EdgeInsets.all(16.0),
            glowColor: Colors.blueAccent,
            child: content,
          )
        : GlassContainer(
            padding: const EdgeInsets.all(16.0),
            child: content,
          ),
    );
  }
}


class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLocked;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                Icon(icon, color: isLocked ? Colors.white54 : AureliusTheme.accentGold, size: 28),
                if (isLocked)
                  const Positioned(
                    right: -5,
                    top: -5,
                    child: Icon(Icons.lock, color: Colors.white, size: 14),
                  )
              ],
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: isLocked ? Colors.white54 : Colors.white)),
          ],
        ),
      ),
    );
  }
}
