import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'price_service.dart';
import '../models/asset_model.dart';
final aiAdvisorProvider = Provider<AiAureliusService>((ref) {
  return AiAureliusService(ref);
});

class AiAureliusService {
  final ProviderRef ref;
  AiAureliusService(this.ref);

  /// Recupera le analisi simulative delle varie fonti e formula un responso aggregato globale
  Future<String> fetchGlobalNewsAnalysis() async {
    // Simulazione di un profondo terminal-scraping su Big 5
    await Future.delayed(const Duration(seconds: 4));

    final assetsAsync = ref.read(portfolioProvider);
    final assets = assetsAsync.valueOrNull ?? [];
    final myTickers = assets.map((a) => a.ticker).toSet();

    String report = "Aurelius Intelligence - Executive Briefing Globale\n(Fonti analizzate: Bloomberg, Reuters, Financial Times, WSJ, CNBC)\n\n";
    report += "Benvenuto. Ho appena concluso il ricalcolo mattutino sui terminali istituzionali. Dopo 30 anni su questi mercati, ho imparato a separare il rumore dai segnali reali. Ecco la mia sintesi strategica calibrata esattamente sulle tue attuali esposizioni:\n\n";

    bool hasNews = false;

    if (myTickers.contains('NVDA')) {
      report += "• NVIDIA (NVDA): Fonti WSJ confermano l'incessante accelerazione dei capex tech per l'infrastruttura AI europea. Il titolo esibisce una forza relativa impressionante. Il mio consiglio: hold strutturale sul lungo termine, la tesi di investimento resta d'acciaio.\n\n";
      hasNews = true;
    }
    
    if (myTickers.contains('RTX')) {
      report += "• RTX Corp (RTX): Il Financial Times segnala un sensibile allentamento dei colli di bottiglia nella supply chain aerospaziale. Il risk-reward su questi livelli è decisamente a tuo favore. Non intravedo turbolenze per il trimestre in corso.\n\n";
      hasNews = true;
    }

    if (myTickers.contains('ENI')) {
       report += "• Eni S.p.A. (ENI): Secondo Reuters, la volatilità dei futures del Brent è ottimamente assorbita dai solidi fondamentali e dalle ristrutturazioni (spin-off) in atto. È il tuo cuscinetto 'value'. Ottimo yield, lascia che i dividendi lavorino per te.\n\n";
       hasNews = true;
    }

    if (myTickers.contains('LDO.MI')) {
      report += "• Leonardo (LDO.MI): I bollettini di Bloomberg sono inequivocabili: la spesa per la difesa europea resterà storicamente alta. Il trend di fondo è un ciclo secolare. Questa esposizione funziona come corazzata per il tuo portafoglio.\n\n";
      hasNews = true;
    }

    if (myTickers.contains('BTC') || myTickers.contains('SOL') || myTickers.contains('ETH')) {
      report += "• Digital Assets (Crypto): CNBC intercetta continui afflussi istituzionali sugli ETF spot. L'euforia è tangibile, ma ricorda le decadi passate: l'avidità logora i portafogli. Mantieni le size sotto controllo per non compromettere il profilo di rischio della tua ricchezza.\n\n";
      hasNews = true;
    }

    if (!hasNews) {
       report += "Allo stato attuale, non percepisco market mover drastici per le tue specifiche piazze. Manteniamo la rotta; nei portafogli di spessore, l'assenza di notizie è spesso il clima migliore per generare valore.\n\n";
    }

    report += "Sono a tua disposizione. Puoi pormi quesiti specifici o selezionare le 'Azioni Rapide' se desideri uno stress test sulle dinamiche di allocation.";

    return report;
  }

  /// Risposta mock ai messaggi dell'utente
  Future<String> getAdvice(String userQuery, Map<String, dynamic> portfolioContext) async {
    await Future.delayed(const Duration(seconds: 2));
    if (userQuery.toLowerCase().contains("vendere")) {
      return "Come tuo consulente esclusivo, ti invito a considerare l'impatto fiscale prima di liquidare le posizioni azionarie.";
    }
    if (userQuery.toLowerCase().contains("crypto") || userQuery.toLowerCase().contains("bitcoin")) {
      return "Le criptovalute sono asset ad alta volatilità (Beta > 2.5). Se vuoi, premi su 'Analisi Allocation' per un Deep-Scan sul rischio del tuo portafoglio totale.";
    }
    return "Sei allineato coi target previsti. Tuttavia, per un approfondimento su misura ti preme il tasto 'Analisi Allocation'.";
  }

  /// Asset Allocation Advice logic basato sulla composizione del Net Worth corrente
  Future<String> analyzeAllocation() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final assetsAsync = ref.read(portfolioProvider);
    final assets = assetsAsync.valueOrNull ?? [];
    
    if (assets.isEmpty) return "Nessun dato su cui lavorare. Compila il portafoglio.";

    double realEstateValue = assets.where((a) => a.category == AssetCategory.realEstate).fold(0.0, (s, a) => s + a.totalNetValue);
    double finanzaValue = assets.where((a) => a.category == AssetCategory.finanza).fold(0.0, (s, a) => s + a.totalNetValue);
    double cashValue = assets.where((a) => a.category == AssetCategory.cash).fold(0.0, (s, a) => s + a.totalNetValue);
    double cryptoValue = assets.where((a) => a.category == AssetCategory.crypto).fold(0.0, (s, a) => s + a.totalNetValue);
    double lussoValue = assets.where((a) => a.category == AssetCategory.lusso).fold(0.0, (s, a) => s + a.totalNetValue);
    double previdenzaValue = assets.where((a) => a.category == AssetCategory.previdenza).fold(0.0, (s, a) => s + a.totalNetValue);
    
    double totalWealth = realEstateValue + finanzaValue + cashValue + cryptoValue + lussoValue + previdenzaValue;
    if (totalWealth == 0) return "Inizia aggiungendo fondi.";

    // Liquidity Analysis
    double illiquidAssetsValue = realEstateValue + lussoValue + previdenzaValue;
    double illiquidPercent = (illiquidAssetsValue / totalWealth) * 100;
    
    double cryptoPercent = (cryptoValue / totalWealth) * 100;

    if (illiquidPercent > 40.0) {
      return "⚠️ DEEP INSIGHT: Il tuo patrimonio è solido, ma il ${illiquidPercent.toStringAsFixed(1)}% è bloccato in asset non liquidi (Immobili, Arte, Previdenza). In caso di emergenza, la tua disponibilità immediata è fortemente limitata. Valuta di accumulare cash-equivalents p puri.";
    } else if (cryptoPercent > 10.0) {
      return "⚠️ ALLERTA RISCHIO AURELIUS: Il tuo portafoglio ha un Beta Crypto estremo (${cryptoPercent.toStringAsFixed(1)}% del Net Worth). I tuoi Assets Digitali sono sovraesposti rispetto ai canoni istituzionali. Strategia suggerita: Prendi profitti sul lato Exchange e consolida le eccedenze verso Finanza Tradizionale o Private Cold Wallet.";
    }

    return "✅ Eccellente diversificazione! Il patrimonio è distribuito organicamente tra assets produttivi (Finanza, Immobili), liquidità strategica e asset alternativi, con un solido indice di liquidabilità.";
  }
}
