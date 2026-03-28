import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../services/price_service.dart';
import '../services/subscription_service.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(targetCurrencyProvider);
    final isPrivacy = ref.watch(privacyModeProvider);
    final savingsGoal = ref.watch(savingsGoalProvider);
    final subTier = ref.watch(subscriptionProvider);

    final currencyFormat = NumberFormat.currency(
      locale: 'it_IT', 
      symbol: currency == 'EUR' ? '€' : (currency == 'USD' ? '\$' : '£')
    );

    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        title: Text("Impostazioni", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel("PREFERENZE"),
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRowItem(
                    icon: Icons.currency_exchange_rounded,
                    title: "Valuta di riferimento",
                    subtitle: currency,
                    trailing: DropdownButton<String>(
                      value: currency,
                      dropdownColor: const Color(0xFF1C1C1E),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: AureliusTheme.accentGold),
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      items: ['EUR', 'USD', 'GBP'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) {
                        if (val != null) ref.read(targetCurrencyProvider.notifier).state = val;
                      },
                    ),
                  ),
                  _buildDivider(),
                  _buildRowItem(
                    icon: Icons.visibility_off_rounded,
                    title: "Privacy Mode",
                    subtitle: "Oscura tutti i valori",
                    trailing: Switch(
                      value: isPrivacy,
                      activeColor: AureliusTheme.accentGold,
                      onChanged: (val) => ref.read(privacyModeProvider.notifier).state = val,
                    ),
                  ),
                  _buildDivider(),
                  _buildRowItem(
                    icon: Icons.flag_rounded,
                    title: "Obiettivo Patrimoniale",
                    subtitle: currencyFormat.format(savingsGoal),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_rounded, color: AureliusTheme.secondaryText),
                      onPressed: () {
                        final ctrl = TextEditingController(text: savingsGoal.toStringAsFixed(0));
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF1C1C1E),
                            title: Text("Obiettivo", style: GoogleFonts.inter(color: Colors.white)),
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
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annulla", style: TextStyle(color: Colors.grey))),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black),
                                onPressed: () {
                                  final val = double.tryParse(ctrl.text);
                                  if (val != null && val > 0) ref.read(savingsGoalProvider.notifier).state = val;
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Salva", style: TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel("ABBONAMENTO"),
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: _buildRowItem(
                icon: Icons.workspace_premium_rounded,
                title: "Piano attuale",
                subtitle: subTier == SubscriptionTier.base ? "Base" : (subTier == SubscriptionTier.pro ? "Pro" : "Wealth"),
                trailing: TextButton(
                  onPressed: () => context.push('/subscription'),
                  child: Text("Cambia", style: GoogleFonts.inter(color: AureliusTheme.accentGold, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel("INFORMAZIONI"),
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRowItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: AureliusTheme.secondaryText,
                    title: "Versione",
                    trailing: Text("1.0.0", style: GoogleFonts.inter(color: AureliusTheme.secondaryText)),
                  ),
                  _buildDivider(),
                  _buildRowItem(
                    icon: Icons.favorite_rounded,
                    title: "Portafoglio Aurelius",
                    subtitle: "Fatto con ❤️ in Italia",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AureliusTheme.secondaryText)),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: Colors.white.withOpacity(0.05),
    );
  }

  Widget _buildRowItem({required IconData icon, required String title, String? subtitle, Widget? trailing, Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? AureliusTheme.accentGold, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(color: AureliusTheme.secondaryText, fontSize: 13)),
              ]
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing,
        ]
      ],
    );
  }
}
