import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AssetCategory { finanza, realEstate, cash, crypto, metalli, lusso, previdenza }

// Stato globale per la Privacy Mode e Target Currency
final privacyModeProvider = StateProvider<bool>((ref) => false);
final targetCurrencyProvider = StateProvider<String>((ref) => 'EUR'); // 'EUR', 'USD', 'GBP'

// Tassi di cambio simulati
const Map<String, Map<String, double>> _forexRates = {
  'EUR': {'USD': 1.08, 'GBP': 0.85, 'EUR': 1.0},
  'USD': {'EUR': 0.92, 'GBP': 0.78, 'USD': 1.0},
  'GBP': {'EUR': 1.17, 'USD': 1.28, 'GBP': 1.0},
};

// Obiettivo Finanziario (Savings Goal)
final savingsGoalProvider = StateProvider<double>((ref) => 1000000.0); // 1 Milione di default

// Cashflow Model
class CashflowProfile {
  final double personalIncome;
  final double spouseIncome;
  
  double get familyIncome => personalIncome + spouseIncome;
  
  const CashflowProfile({this.personalIncome = 0.0, this.spouseIncome = 0.0});
}
final cashflowProvider = Provider<CashflowProfile>((ref) => const CashflowProfile(personalIncome: 45000, spouseIncome: 38000));

class Asset {
  final String id;
  final String ticker;
  final String name;
  final double entryPrice;
  final double currentPrice;
  final double quantity;
  final String bank;
  final AssetCategory category;
  
  // Specifico per gli Immobili
  final double mortgageResidual;
  final double monthlyRent;

  // Specifico per le Criptovalute
  final String cryptoLocation; // Es. "Binance", "Cold Wallet Ledger"

  // Specifico per Previdenza/Assicurazioni
  final DateTime? expirationDate;

  // Valuta di Denominazione
  final String currency; // 'EUR' o 'USD'

  // Annotazioni personali
  final String? notes;

  // Ritorna il tasso di conversione verso una valuta target
  double conversionRate(String targetCurrency) {
    return _forexRates[currency]?[targetCurrency] ?? 1.0;
  }

  // Valore corretto in una valuta specifica (Forex Engine)
  double totalNetValueIn(String targetCurrency) => totalNetValue * conversionRate(targetCurrency);
  double totalGrossValueIn(String targetCurrency) => totalGrossValue * conversionRate(targetCurrency);

  // Manteniamo questi per compatibilità retroattiva o default
  double get totalNetValueEur => totalNetValueIn('EUR');
  double get totalGrossValueEur => totalGrossValueIn('EUR');

  Asset({
    required this.id,
    required this.ticker,
    required this.name,
    required this.entryPrice,
    required this.currentPrice,
    required this.quantity,
    required this.bank,
    this.category = AssetCategory.finanza,
    this.mortgageResidual = 0.0,
    this.monthlyRent = 0.0,
    this.cryptoLocation = '',
    this.expirationDate,
    this.currency = 'EUR',
    this.notes,
  });

  factory Asset.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Asset(
      id: doc.id,
      ticker: data['ticker'] ?? '',
      name: data['name'] ?? '',
      entryPrice: (data['entryPrice'] ?? 0.0).toDouble(),
      currentPrice: (data['currentPrice'] ?? 0.0).toDouble(),
      quantity: (data['quantity'] ?? 0.0).toDouble(),
      bank: data['bank'] ?? 'Non Assegnata',
      category: _parseCategory(data['category']),
      mortgageResidual: (data['mortgageResidual'] ?? 0.0).toDouble(),
      monthlyRent: (data['monthlyRent'] ?? 0.0).toDouble(),
      cryptoLocation: data['cryptoLocation'] ?? '',
      expirationDate: data['expirationDate'] != null ? (data['expirationDate'] as Timestamp).toDate() : null,
      currency: data['currency'] ?? 'EUR',
      notes: data['notes'],
    );
  }

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

  Map<String, dynamic> toMap() {
    return {
      'ticker': ticker,
      'name': name,
      'entryPrice': entryPrice,
      'currentPrice': currentPrice,
      'quantity': quantity,
      'bank': bank,
      'category': category.name,
      'mortgageResidual': mortgageResidual,
      'monthlyRent': monthlyRent,
      'cryptoLocation': cryptoLocation,
      'expirationDate': expirationDate != null ? Timestamp.fromDate(expirationDate!) : null,
      'currency': currency,
      'notes': notes,
    };
  }

  // Il valore patrimoniale lordo
  double get totalGrossValue => currentPrice * quantity;
  
  // Valore patrimoniale netto (Sottrae il debito residuo se presente)
  double get totalNetValue => totalGrossValue - mortgageResidual;
  
  double get totalEntryValue => entryPrice * quantity;
  double get profitLoss => totalGrossValue - totalEntryValue;
  double get profitLossPercent => (currentPrice - entryPrice) / entryPrice * 100;

  Asset copyWith({
    String? id,
    String? ticker,
    String? name,
    double? entryPrice,
    double? currentPrice,
    double? quantity,
    String? bank,
    AssetCategory? category,
    double? mortgageResidual,
    double? monthlyRent,
    String? cryptoLocation,
    DateTime? expirationDate,
    String? currency,
    String? notes,
  }) {
    return Asset(
      id: id ?? this.id,
      ticker: ticker ?? this.ticker,
      name: name ?? this.name,
      entryPrice: entryPrice ?? this.entryPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      quantity: quantity ?? this.quantity,
      bank: bank ?? this.bank,
      category: category ?? this.category,
      mortgageResidual: mortgageResidual ?? this.mortgageResidual,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      cryptoLocation: cryptoLocation ?? this.cryptoLocation,
      expirationDate: expirationDate ?? this.expirationDate,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
    );
  }
}

// Filtro corrente della dashboard
final selectedBankFilterProvider = StateProvider<String>((ref) => 'Tutte');

// Stream da Firebase
final portfolioProvider = StreamProvider<List<Asset>>((ref) {
  try {
    return FirebaseFirestore.instance.collection('portfolio').snapshots().asyncMap((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _simulatePricesOffline(); // Fallback per Demo
      }
      return snapshot.docs.map((doc) => Asset.fromFirestore(doc)).toList();
    });
  } catch (e) {
    return _createHybridSimulationStream();
  }
});

// Stream personalizzato per fallback offline con logiche Crypto (5s) e Finanza (10s) differenti
Stream<List<Asset>> _createHybridSimulationStream() async* {
  final random = Random();
  int tick = 0;

  while (true) {
    // Al ciclo, aggiorniamo solo in base al tempo.
    // Il provider si triggera ogni volta che le crypto si muovono.
    // tick % 1 == 0 (ogni ciclo 5s) per crypto
    // tick % 2 == 0 (ogni 2 cicli = 10s) per finanza
    _cachedMockAssets = _cachedMockAssets.map((asset) {
      if (asset.category == AssetCategory.cash || asset.category == AssetCategory.realEstate || asset.category == AssetCategory.lusso || asset.category == AssetCategory.previdenza) {
        return asset; // Non variano ad alta frequenza
      }
      
      if (asset.category == AssetCategory.crypto) {
        // Altissima volatilità crypto: +/- 3%
        double changePercent = (random.nextDouble() * 6 - 3) / 100;
        double newPrice = asset.currentPrice * (1 + changePercent);
        return asset.copyWith(currentPrice: newPrice);
      }
      
      if (asset.category == AssetCategory.finanza && tick % 2 == 0) {
        // Volatilità standard: +/- 1%
        double changePercent = (random.nextDouble() * 2 - 1) / 100; 
        double newPrice = asset.currentPrice * (1 + changePercent);
        return asset.copyWith(currentPrice: newPrice);
      }

      if (asset.category == AssetCategory.metalli && tick % 2 == 0) {
        // Bassa volatilità oro: +/- 0.5%
        double changePercent = (random.nextDouble() * 1 - 0.5) / 100; 
        double newPrice = asset.currentPrice * (1 + changePercent);
        return asset.copyWith(currentPrice: newPrice);
      }
      return asset;
    }).toList();

    yield List<Asset>.from(_cachedMockAssets);
    
    // Attendi 5 secondi effettivi, che è il battito per le crypto
    await Future.delayed(const Duration(seconds: 5));
    tick++;
  }
}


// Getter per calcoli globali o filtrati
final filteredPortfolioProvider = Provider<List<Asset>>((ref) {
  final bankFilter = ref.watch(selectedBankFilterProvider);
  final portfolioAsync = ref.watch(portfolioProvider);
  
  return portfolioAsync.maybeWhen(
    data: (assets) {
      if (bankFilter == 'Tutte') return assets;
      // Immobili, Crypto e Lusso spesso si filtrano diversamente. Mostriamo tutto il patrimonio trasversale.
      return assets.where((a) => a.bank == bankFilter || a.category != AssetCategory.finanza).toList();
    },
    orElse: () => [],
  );
});

// Calcoli Patrimoniali MASTER (Globali e Multi-Currency)
final masterNetWorthProvider = Provider<double>((ref) {
  final assetsAsync = ref.watch(portfolioProvider);
  final targetCurr = ref.watch(targetCurrencyProvider);
  return assetsAsync.maybeWhen(
    data: (assets) => assets.fold(0.0, (sum, asset) => sum + asset.totalNetValueIn(targetCurr)),
    orElse: () => 0.0,
  );
});

final masterAssetsGrossValueProvider = Provider<double>((ref) {
  final assetsAsync = ref.watch(portfolioProvider);
  final targetCurr = ref.watch(targetCurrencyProvider);
  return assetsAsync.maybeWhen(
    data: (assets) => assets.fold(0.0, (sum, asset) => sum + asset.totalGrossValueIn(targetCurr)),
    orElse: () => 0.0,
  );
});

final masterLiabilitiesProvider = Provider<double>((ref) {
  final assetsAsync = ref.watch(portfolioProvider);
  final targetCurr = ref.watch(targetCurrencyProvider);
  return assetsAsync.maybeWhen(
    data: (assets) => assets.fold(0.0, (sum, asset) => sum + (asset.mortgageResidual * asset.conversionRate(targetCurr))),
    orElse: () => 0.0,
  );
});


// Calcoli per schermata specifica/filtri
final totalFilteredValueProvider = Provider<double>((ref) {
  final assets = ref.watch(filteredPortfolioProvider);
  final targetCurr = ref.watch(targetCurrencyProvider);
  return assets.fold(0.0, (sum, asset) => sum + asset.totalNetValueIn(targetCurr));
});

final totalFilteredPerformanceProvider = Provider<double>((ref) {
  final assets = ref.watch(filteredPortfolioProvider);
  final targetCurr = ref.watch(targetCurrencyProvider);
  double totalEntry = assets.fold(0.0, (sum, asset) => sum + (asset.entryPrice * asset.quantity * asset.conversionRate(targetCurr)));
  double totalCurrentGross = assets.fold(0.0, (sum, asset) => sum + asset.totalGrossValueIn(targetCurr));
  if (totalEntry == 0) return 0.0;
  return (totalCurrentGross - totalEntry) / totalEntry * 100;
});


// MOCK OFFLINE (usato se firebase vuoto o offline)
List<Asset> _cachedMockAssets = [
  Asset(id: '1', ticker: 'RTX', name: 'RTX Corp', entryPrice: 85.50, currentPrice: 90.20, quantity: 50, bank: 'Fineco', category: AssetCategory.finanza, currency: 'USD'),
  Asset(id: '2', ticker: 'NVDA', name: 'Nvidia', entryPrice: 420.00, currentPrice: 850.50, quantity: 15, bank: 'Intesa', category: AssetCategory.finanza, currency: 'USD'),
  Asset(id: '3', ticker: 'ENI', name: 'Eni S.p.A.', entryPrice: 13.40, currentPrice: 14.60, quantity: 500, bank: 'Intesa', category: AssetCategory.finanza, currency: 'EUR'),
  Asset(id: '5', ticker: 'CASH-REV', name: 'Liquidità EUR', entryPrice: 1.0, currentPrice: 1.0, quantity: 15000, bank: 'Revolut', category: AssetCategory.cash, currency: 'EUR'),
  Asset(id: '4', ticker: 'IMMOBILE-1', name: 'Appartamento Milano', entryPrice: 400000.0, currentPrice: 520000.0, quantity: 1, bank: 'Intesa', category: AssetCategory.realEstate, mortgageResidual: 180000.0, monthlyRent: 2200.0, currency: 'EUR'),
  
  // Crypto Mock
  Asset(id: '6', ticker: 'BTC', name: 'Bitcoin', entryPrice: 50000.0, currentPrice: 65200.0, quantity: 0.5, bank: 'Crypto', category: AssetCategory.crypto, cryptoLocation: 'Ledger Cold Wallet', currency: 'USD'),
  Asset(id: '7', ticker: 'SOL', name: 'Solana', entryPrice: 80.0, currentPrice: 145.0, quantity: 50, bank: 'Crypto', category: AssetCategory.crypto, cryptoLocation: 'Binance Exchange', currency: 'USD'),

  // Z Modulo Mock
  Asset(id: '8', ticker: 'XAU', name: 'Lingotti d\'Oro 999.9', entryPrice: 65.0, currentPrice: 72.50, quantity: 500, bank: 'Cassetta Sicurezza', category: AssetCategory.metalli, currency: 'USD'),
  Asset(id: '9', ticker: 'RLX-DAY', name: 'Rolex Daytona Ceramica', entryPrice: 14500.0, currentPrice: 28000.0, quantity: 1, bank: 'Cassaforte Domestica', category: AssetCategory.lusso, currency: 'EUR'),
  Asset(id: '10', ticker: 'PIP-ALL', name: 'Fondo Pensione Allianz', entryPrice: 24000.0, currentPrice: 27500.0, quantity: 1, bank: 'Allianz', category: AssetCategory.previdenza, expirationDate: DateTime(2045, 6, 1), currency: 'EUR'),
];

List<Asset> _simulatePricesOffline() {
  return _cachedMockAssets; // Ora gestito dal gen custom stream _createHybridSimulationStream
}
