import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/asset_model.dart';

// Stato globale per la Privacy Mode e Target Currency
final privacyModeProvider = StateProvider<bool>((ref) => false);
final targetCurrencyProvider = StateProvider<String>((ref) => 'EUR'); // 'EUR', 'USD', 'GBP'

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

// Classe Asset e _forexRates migrate in lib/models/asset_model.dart

// Filtro corrente della dashboard
final selectedBankFilterProvider = StateProvider<String>((ref) => 'Tutte');
final selectedCategoryFilterProvider = StateProvider<String>((ref) => 'Tutte');

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
  final categoryFilter = ref.watch(selectedCategoryFilterProvider);
  final portfolioAsync = ref.watch(portfolioProvider);
  
  return portfolioAsync.maybeWhen(
    data: (assets) {
      List<Asset> result = assets;

      if (categoryFilter != 'Tutte') {
        result = result.where((a) {
          switch (categoryFilter) {
            case 'Finanza': return a.category == AssetCategory.finanza;
            case 'Crypto': return a.category == AssetCategory.crypto;
            case 'Immobili': return a.category == AssetCategory.realEstate;
            case 'Lusso': return a.category == AssetCategory.lusso;
            case 'Liquidità': return a.category == AssetCategory.cash;
            case 'Metalli': return a.category == AssetCategory.metalli;
            case 'Previdenza': return a.category == AssetCategory.previdenza;
            default: return true;
          }
        }).toList();
      }

      if (bankFilter != 'Tutte') {
        result = result.where((a) => a.bank == bankFilter || a.category != AssetCategory.finanza).toList();
      }

      return result;
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
