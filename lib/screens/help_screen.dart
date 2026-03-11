import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manuale Operativo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AureliusTheme.accentGold,
                  child: Icon(Icons.psychology, color: Colors.black, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Benvenuto in Portafoglio Aurelius. Sono il tuo AI Advisor. Ecco la guida strategica per dominare il tuo patrimonio.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, color: AureliusTheme.accentGold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),

            _HelpSection(
              title: 'Master Dashboard (Moduli A-Z)',
              icon: Icons.account_balance_wallet,
              content: 'La sezione Master Wealth, esclusiva del piano Wealth Elite, aggrega ogni singola componente del tuo Net Worth (Patrimonio Netto).\n\n'
                  '• Finanza: Azioni, obbligazioni e fondi.\n'
                  '• Crypto: I tuoi asset digitali (es. Bitcoin, Solana), suddivisi per locazione (Exchange o Ledger).\n'
                  '• Immobili: Le tue proprietà, scalando in automatico il mutuo residuo come passività.\n'
                  '• Modulo Z: Beni rifugio (Metalli preziosi), beni di Lusso (Orologi, Auto, Arte) e Previdenza (Fondi pensione con data di scadenza).\n\n'
                  'Aurelius analizza costantemente la Liquidabilità del Portafoglio avvisandoti se sei sovraesposto in asset non liquidi.',
            ),
            const SizedBox(height: 16),

            _HelpSection(
              title: 'Aurelius AI & Scanner Intelligence',
              icon: Icons.smart_toy,
              content: 'Usa il pulsante "Scan Screenshot" per digitalizzare rapidamente le tue posizioni. L\'IA di Aurelius estrae Ticket, Prezzi medi di carico e Quantità direttamente dalle immagini (Piano Pro+).\n\n'
                  'Nella schermata "AI Advisor", Aurelius incrocia il tuo portafoglio con le notizie globali in tempo reale dai \'Big 5\' (Bloomberg, Reuters, FT, WSJ, CNBC), fornendoti un briefing giornaliero personalizzato come un consulente Senior con 30 anni di esperienza.',
            ),
            const SizedBox(height: 16),

            _HelpSection(
              title: 'Rientro Post-Vendita & Zainetto Fiscale',
              icon: Icons.analytics,
              content: 'Quando vendi una posizione, l\'operazione viene registrata atomicamente in Firebase. La view "Rientro Post-Vendita" confronta i prezzi attuali coi tuoi prezzi di uscita passati, avvisandoti con un banner dorato quando il mercato ti offre un ghiotto sconto percentuale per riacquistare l\'asset.\n\n'
                  'Lo Zainetto Fiscale, presente in Dashboard, calcola invece costantemente le tue plusvalenze e minusvalenze latenti, permettendoti di ottimizzare il carico scale di fine anno.',
            ),
            const SizedBox(height: 16),

            _HelpSection(
              title: 'Architettura SaaS & Privacy',
              icon: Icons.security,
              content: 'L\'App è Cloud-Native con Firestore. I tuoi dati sono rigorosamente separati per Tenant (User ID) e sincronizzati in real-time. In caso di connessione assente, la modalità Offline-First ti permette di visualizzare l\'ultima foto del tuo patrimonio e salvare offline i nuovi caricamenti, che verranno allineati al Cloud non appena ritornerai sotto copertura.',
            ),
            const SizedBox(height: 16),

            _HelpSection(
              title: 'Privacy & Trust: Dove sono i miei dati?',
              icon: Icons.shield_moon,
              content: 'La tua sicurezza è il Pilastro Zero di Aurelius.\n\n'
                  '• Infrastruttura Google: Tutti i dati sono ospitati sui server enterprise criptati di Firebase Cloud (Google Cloud Platform).\n'
                  '• Isolamento Silos: L\'architettura SaaS prevede che i tuoi database siano totalmente isolati tramite rigide Security Rules. Neanche tu puoi in alcun modo interrogare record al di fuori del tuo specifico Tenant ID (User ID).\n'
                  '• Zero Track Policy: Aurelius non vende i tuoi dati. Il modello di business è interamente sostenuto dagli abbonamenti Premium, garantendo un allineamento etico totale tra utente e piattaforma.',
            ),
            const SizedBox(height: 40),
            
            Center(
              child: Text(
                'Aurelius Wealth Management © 2026',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _HelpSection({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AureliusTheme.accentGold),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(height: 1.5, color: AureliusTheme.secondaryText)),
        ],
      ),
    );
  }
}
