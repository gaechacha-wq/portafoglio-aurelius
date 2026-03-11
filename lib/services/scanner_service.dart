import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scannerProvider = Provider<ScannerService>((ref) {
  return ScannerService();
});

class ScannedAsset {
  final String ticker;
  final String name;
  final double quantity;
  final double averageLoadPrice;

  ScannedAsset({
    required this.ticker,
    required this.name,
    required this.quantity,
    required this.averageLoadPrice,
  });
}

class ScannerService {
  /// Simula l'elaborazione di un'immagine tramite l'agente AI (Vision LLM)
  /// L'agente è ora in grado di leggere interi estratti conto, capendo redditi e posizioni.
  Future<List<ScannedAsset>> processScreenshot(String imagePath) async {
    // Simulazione di una profonda analisi OCR/Vision LLM su documenti complessi
    await Future.delayed(const Duration(seconds: 4));
    
    final random = Random();
    
    // Ritorna un estratto misto intelligente (Azioni, Conti e Redditi mascherati da asset per il parsing)
    return [
      ScannedAsset(
        ticker: 'CASH', 
        name: 'Estratto Conto - Saldo Liquido', 
        quantity: 1.0, 
        averageLoadPrice: 15400.00 + (random.nextDouble() * 1000),
      ),
      ScannedAsset(
        ticker: 'INCOME', 
        name: 'Bonifico Stipendio Mese Corrente', 
        quantity: 1.0, 
        averageLoadPrice: 3850.00,
      ),
      ScannedAsset(
        ticker: 'VOO', 
        name: 'Vanguard S&P 500 ETF', 
        quantity: 12.0 + random.nextInt(5), 
        averageLoadPrice: 420.00 + (random.nextDouble() * 10),
      ),
      ScannedAsset(
        ticker: 'BTC', 
        name: 'Bitcoin - Trasferimento In Rete', 
        quantity: 0.15 + (random.nextDouble() * 0.1), 
        averageLoadPrice: 65000.00,
      ),
    ];
  }
}
