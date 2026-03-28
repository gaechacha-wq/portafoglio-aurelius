import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/asset_model.dart';

final aiAureliusServiceProvider = Provider<AiAureliusService>((ref) {
  return AiAureliusService();
});

class AiAureliusService {
  late final GenerativeModel? _model;
  
  AiAureliusService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_KEY_HERE') {
      _model = null; // Fallback d'errore graceful control
    } else {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
    }
  }

  String _formatPortfolio(List<Asset> assets) {
    if (assets.isEmpty) return "Nessun asset in portafoglio.";
    return assets.map((a) {
      double pl = (a.currentPrice * a.quantity) - (a.entryPrice * a.quantity);
      double plPct = a.entryPrice == 0 ? 0 : (pl / (a.entryPrice * a.quantity)) * 100;
      return "- ${a.name} (${a.ticker}) cat: ${a.category.name}, V.Attuale: ${a.currentPrice}, Gain/Loss: ${plPct.toStringAsFixed(1)}%";
    }).join("\n");
  }

  Future<String> analyzePortfolio(List<Asset> assets) async {
    if (_model == null) return "Servizio AI non disponibile. Controlla la configurazione.";
    
    final portfolioData = _formatPortfolio(assets);
    final prompt = "Sei un consulente finanziario esperto. Analizza questo portafoglio e fornisci una valutazione concisa in italiano (massimo 150 parole):\n"
                   "$portfolioData\n"
                   "Focus su: diversificazione, rischi principali, punto di forza del portafoglio.";
                   
    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      return response.text ?? "Nessuna analisi generata.";
    } catch (e) {
      return "Servizio AI non disponibile. Controlla la configurazione.";
    }
  }

  Future<String> getSimpleAdvice(String question, List<Asset> assets) async {
    if (_model == null) return "Servizio AI non disponibile. Controlla la configurazione.";

    final portfolioData = _formatPortfolio(assets);
    final prompt = "Contesto portafoglio utente:\n$portfolioData\n\n"
                   "Domanda dell'utente: $question\n"
                   "Rispondi in massimo 100 parole in italiano con un tono professionale ma comprensibile ai non esperti.";
                   
    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      return response.text ?? "Nessuna risposta generata.";
    } catch (e) {
      return "Servizio AI non disponibile. Controlla la configurazione.";
    }
  }
}
