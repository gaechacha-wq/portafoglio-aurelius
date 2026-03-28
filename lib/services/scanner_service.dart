import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  factory ScannedAsset.fromJson(Map<String, dynamic> json) {
    return ScannedAsset(
      ticker: json['ticker'] ?? '',
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      averageLoadPrice: (json['averageLoadPrice'] ?? 0.0).toDouble(),
    );
  }
}

final scannerServiceProvider = Provider<ScannerService>((ref) {
  return ScannerService();
});

class ScannerService {
  late final GenerativeModel? _model;

  ScannerService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_KEY_HERE') {
      _model = null;
    } else {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
    }
  }

  Future<List<ScannedAsset>> processImage(Uint8List imageBytes) async {
    if (_model == null) throw Exception("Servizio AI non disponibile. Controlla la configurazione.");

    final prompt = "Analizza questo estratto conto o documento finanziario. Estrai TUTTI gli asset presenti e restituisci un JSON array con questo formato:\n"
                   "[\{\n"
                   "  \"ticker\": \"NVDA\",\n"
                   "  \"name\": \"NVIDIA Corporation\",\n"
                   "  \"quantity\": 15.0,\n"
                   "  \"averageLoadPrice\": 420.00\n"
                   "\}]\n"
                   "Rispondi SOLO con il JSON, nessun testo extra. Se non trovi asset finanziari, rispondi: []";

    try {
      final content = [
        Content.multi([
          DataPart('image/jpeg', imageBytes),
          TextPart(prompt)
        ])
      ];
      final response = await _model!.generateContent(content);
      String text = response.text ?? "[]";
      
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      
      final List<dynamic> jsonList = jsonDecode(text);
      return jsonList.map((j) => ScannedAsset.fromJson(Map<String,dynamic>.from(j))).toList();
    } catch (e) {
      return [];
    }
  }
}
