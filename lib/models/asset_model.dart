import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

enum AssetCategory {
  finanza,
  crypto,
  realEstate,
  cash,
  metalli,
  lusso,
  previdenza
}

// Tassi di cambio simulati (Mappatura Forex Engine)
const Map<String, Map<String, double>> _forexRates = {
  'EUR': {'USD': 1.08, 'GBP': 0.85, 'EUR': 1.0},
  'USD': {'EUR': 0.92, 'GBP': 0.78, 'USD': 1.0},
  'GBP': {'EUR': 1.17, 'USD': 1.28, 'GBP': 1.0},
};

@freezed
class Asset with _$Asset {
  const Asset._();

  const factory Asset({
    required String id,
    required String ticker,
    required String name,
    required AssetCategory category,
    required double quantity,
    required double entryPrice,
    required double currentPrice,
    @Default('EUR') String currency,
    required String bank,
    @Default(0.0) double mortgageResidual,
    @Default(0.0) double monthlyRent,
    @Default('') String cryptoLocation,
    DateTime? expirationDate,
    String? notes,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  // Metodo Factory personalizzato per il mapping di Cloud Firestore
  factory Asset.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Asset(
      id: doc.id,
      ticker: data['ticker'] ?? '',
      name: data['name'] ?? '',
      category: _parseCategory(data['category']),
      quantity: (data['quantity'] ?? 0.0).toDouble(),
      entryPrice: (data['entryPrice'] ?? 0.0).toDouble(),
      currentPrice: (data['currentPrice'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'EUR',
      bank: data['bank'] ?? 'Non Assegnata',
      mortgageResidual: (data['mortgageResidual'] ?? 0.0).toDouble(),
      monthlyRent: (data['monthlyRent'] ?? 0.0).toDouble(),
      cryptoLocation: data['cryptoLocation'] ?? '',
      expirationDate: data['expirationDate'] != null ? (data['expirationDate'] as Timestamp).toDate() : null,
      notes: data['notes'],
    );
  }

  // Deserializza Categoria da String
  static AssetCategory _parseCategory(String? catStr) {
    switch (catStr) {
      case 'realEstate': return AssetCategory.realEstate;
      case 'cash': return AssetCategory.cash;
      case 'crypto': return AssetCategory.crypto;
      case 'metalli': return AssetCategory.metalli;
      case 'lusso': return AssetCategory.lusso;
      case 'previdenza': return AssetCategory.previdenza;
      default: return AssetCategory.finanza;
    }
  }

  // Serializza su Firestore (risolvendo il formato Timestamp)
  Map<String, dynamic> toMap() {
    return {
      'ticker': ticker,
      'name': name,
      'category': category.name,
      'quantity': quantity,
      'entryPrice': entryPrice,
      'currentPrice': currentPrice,
      'currency': currency,
      'bank': bank,
      'mortgageResidual': mortgageResidual,
      'monthlyRent': monthlyRent,
      'cryptoLocation': cryptoLocation,
      'expirationDate': expirationDate != null ? Timestamp.fromDate(expirationDate!) : null,
      'notes': notes,
    };
  }

  // --- Calcoli Patrimoniali Interni (Domain Logic) ---

  double get totalGrossValue => currentPrice * quantity;
  
  double get totalNetValue => totalGrossValue - mortgageResidual;
  
  double get totalEntryValue => entryPrice * quantity;
  
  double get profitLoss => totalGrossValue - totalEntryValue;
  
  double get profitLossPercent => entryPrice == 0 ? 0 : ((currentPrice - entryPrice) / entryPrice) * 100;

  double conversionRate(String targetCurrency) {
    return _forexRates[currency]?[targetCurrency] ?? 1.0;
  }

  double totalNetValueIn(String targetCurrency) => totalNetValue * conversionRate(targetCurrency);
  
  double totalGrossValueIn(String targetCurrency) => totalGrossValue * conversionRate(targetCurrency);
}
