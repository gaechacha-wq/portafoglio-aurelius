import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informazioni App'), // Predisposto per L10n
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(Icons.account_balance_wallet, color: AureliusTheme.accentGold, size: 80),
                  SizedBox(height: 16),
                  Text('Portafoglio Aurelius', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
                  Text('Versione 1.0.0 Alpha', style: TextStyle(color: Colors.white54)),
                  Text('Ultimo Aggiornamento: 11 Marzo 2026', style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            GlassContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Row(
                     children: [
                       Icon(Icons.history, color: AureliusTheme.accentGold),
                       SizedBox(width: 8),
                       Text('Changelog (Modulo Omega & I18N)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                     ],
                   ),
                   const SizedBox(height: 12),
                   const Divider(color: Colors.white24),
                   const SizedBox(height: 12),
                   _ChangelogItem(date: 'v1.0.0-rc2', text: 'Integrazione Modulo I18N (Localizzazione multilingua), Cashflow Familiari, Selettore Valuta Net Worth (EUR/USD/GBP), e supporto Accessibilità (Semantics).'),
                   _ChangelogItem(date: 'v1.0.0-rc1', text: 'Completamento Modulo Omega: Privacy Mode, Forex Engine USD -> EUR, Export Report Fiscale.'),
                   _ChangelogItem(date: 'v0.9.0-beta', text: 'Completamento Impero (Modulo Z): Aggiunti Metalli Preziosi, Lusso, Previdenza, e Deep Liquidity Risk Analysis.'),
                   _ChangelogItem(date: 'v0.8.0-beta', text: 'Integrazione SaaS Paywall, Report Pdf Generation e Aurelius Sales Pitch.'),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const Text('Aurelius Wealth Management © 2026', style: TextStyle(color: Colors.white24, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ChangelogItem extends StatelessWidget {
  final String date;
  final String text;

  const _ChangelogItem({required this.date, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold, fontSize: 12))),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}
