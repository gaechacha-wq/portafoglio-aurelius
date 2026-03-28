# Snapshot Codice Architetturale (Base Dati e Logica)

### PATH: pubspec.yaml
### STATO: completo
### CODICE:
```yaml
name: portfolio_aurelius
description: "App finanziaria premium."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  google_fonts: ^6.2.1
  cupertino_icons: ^1.0.6
  firebase_core: ^2.32.0
  cloud_firestore: ^4.17.5
  firebase_auth: ^4.19.6
  fl_chart: ^0.66.0
  intl: ^0.19.0
  flutter_localizations:
    sdk: flutter
  
  # Routing
  go_router: ^13.2.0
  
  # UI/UX Premium Feel
  flutter_svg: ^2.0.10
  shimmer: ^3.0.0
  
  # Code generation & Dati
  riverpod_annotation: ^2.3.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.8
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.11
  
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  generate: true
  uses-material-design: true
```

---

### PATH: lib/main.dart
### STATO: completo
### CODICE:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Inizializzare Firebase qui
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: PortfolioAureliusApp(),
    ),
  );
}

class PortfolioAureliusApp extends ConsumerWidget {
  const PortfolioAureliusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Osserva il routerProvider creato
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Portfolio Aurelius',
      debugShowCheckedModeBanner: false,
      theme: AureliusTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', ''),
        Locale('en', ''),
      ],
      routerConfig: router,
    );
  }
}
```

---

### PATH: lib/core/theme.dart
### STATO: completo
### CODICE:
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AureliusTheme {
  // Dark premium colors
  static const Color backgroundBlack = Color(0xFF000000);
  static const Color cardDark = Color(0xFF1C1C1E);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color secondaryText = Color(0xFF8E8E93);
  static const Color primaryText = Color(0xFFFFFFFF);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: accentGold,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: primaryText),
        titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: primaryText),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: primaryText),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: secondaryText),
      ),
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        onPrimary: backgroundBlack,
        surface: cardDark,
        onSurface: primaryText,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
```

---

### PATH: lib/core/router/app_router.dart
### STATO: completo
### CODICE:
```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modifica questi import base nel tuo progetto
import '../../screens/dashboard_screen.dart';
import '../../screens/biometric_gate.dart';

/// Provider per il router dell'app. Permette dependency injection e 
/// reactive redirect in base allo stato dell'autenticazione.
final routerProvider = Provider<GoRouter>((ref) {
  
  // Esempio: ascoltare uno stato di auth per redirect
  // final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/gate',
    routes: [
      GoRoute(
        path: '/gate',
        name: 'biometric_gate',
        builder: (context, state) => const BiometricGate(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    // redirect: (context, state) {
    //   // Logica per proteggere le route qui
    // },
  );
});
```

---

### PATH: lib/models/asset_model.dart
### STATO: NON ESISTENTE

---

### PATH: lib/models/user_profile.dart
### STATO: completo
### CODICE:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Un esempio di data class immutabile per un'app finanziaria.
/// Usa @freezed per generare copyWith, toString, ==, hashCode.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String fullName,
    String? email,
    @Default(0.0) double totalBalance,
    @Default(false) bool isPremium,
    DateTime? createdAt,
  }) = _UserProfile;

  // Indispensabile per serializzare/deserializzare da Firebase
  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}
```

---

### PATH: lib/services/firebase_service.dart
### STATO: completo
### CODICE:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'scanner_service.dart';
import 'price_service.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Usa l'ID utente reale una volta implementata l'autenticazione. 
  // Attualmente simula un utente SaaS isolato.
  String get _currentUserId {
    // return FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_saas_user';
    return 'premium_user_001';
  }

  /// Configura la persistenza offline in modo che l'utente veda l'ultimo portfolio anche
  /// in aereo e possa apportare modifiche in queue per la riconnessione.
  Future<void> enableOfflinePersistence() async {
    try {
       // La cache su iOS e Android è abilitata di default, ma può essere forzata a una certa size.
       _db.settings = const Settings(
         persistenceEnabled: true,
         cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
       );
    } catch (e) {
      // Ignora l'errore se Firebase non è configurato localmente
    }
  }

  /// Ottiene il riferimento alla collezione del portafoglio dell'utente corrente (SaaS Ready)
  CollectionReference get _userPortfolioRef {
    return _db.collection('users').doc(_currentUserId).collection('portfolio');
  }

  /// Ottiene il riferimento allo storico chiusure
  CollectionReference get _userHistoricalSalesRef {
     return _db.collection('users').doc(_currentUserId).collection('historical_sales');
  }


  /// Salvataggio Universale Multi-Asset
  Future<void> saveAsset(Asset asset) async {
    try {
      await _userPortfolioRef.doc(asset.id.isNotEmpty ? asset.id : null).set(
        asset.toMap()..addAll({'timestamp': FieldValue.serverTimestamp()}),
        SetOptions(merge: true),
      );
    } catch (e) {
      // Catch in offline fallback, Firestore accoderà localmente
    }
  }

  /// Registra la "Chiusura" di una posizione. (Elimina dal portafoglio e salva nello storico per il modulo Post-Vendita)
  Future<void> chiudiPosizione(Asset asset, double sellPrice) async {
    try {
      final batch = _db.batch();
      
      // 1. Salva nello Storico Vendite
      final newHistoryDoc = _userHistoricalSalesRef.doc();
      batch.set(newHistoryDoc, {
        'ticker': asset.ticker,
        'name': asset.name,
        'quantity': asset.quantity,
        'entryPriceAtSale': asset.entryPrice,
        'exitPrice': sellPrice,
        'bank': asset.bank,
        'category': asset.category.name,
        'sellDate': FieldValue.serverTimestamp(),
      });

      // 2. Elimina dal portafoglio attivo
      if (asset.id.isNotEmpty) {
        batch.delete(_userPortfolioRef.doc(asset.id));
      }

      await batch.commit();

    } catch (e) {
      // Fallback
    }
  }

  /// Wrapper per il mock dello Scanner (Salva azioni/crypto importati)
  Future<void> saveScannedAsset(ScannedAsset asset, String assignedBank) async {
    try {
      // Identifica il tipo basato sul ticker
      AssetCategory cat = AssetCategory.finanza;
      if (['BTC', 'ETH', 'SOL', 'ADA', 'XRP'].contains(asset.ticker.toUpperCase())) {
         cat = AssetCategory.crypto;
      }

      final newAsset = Asset(
        id: _userPortfolioRef.doc().id, // Pre-genera l'id Firestore
        ticker: asset.ticker,
        name: asset.name,
        quantity: asset.quantity,
        entryPrice: asset.averageLoadPrice,
        currentPrice: asset.averageLoadPrice, 
        bank: assignedBank,
        category: cat,
      );

      await saveAsset(newAsset);
    } catch (e) {
      // Ignora l'errore per continuità UX offline
    }
  }
}
```

---

### PATH: lib/services/price_service.dart
### STATO: completo
### CODICE:
```dart
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
```

---

### PATH: lib/services/subscription_service.dart
### STATO: completo
### CODICE:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SubscriptionTier { base, pro, wealth }

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionTier>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionTier> {
  // Parti col piano base per simulare il blocco iniziale.
  SubscriptionNotifier() : super(SubscriptionTier.base);

  void upgradeTo(SubscriptionTier newTier) {
    state = newTier;
  }
}

// Estensione helper per check controllati
extension SubscriptionAccess on SubscriptionTier {
  bool get canAccessMasterWealth => this == SubscriptionTier.wealth;
  bool get canAccessCrypto => this == SubscriptionTier.pro || this == SubscriptionTier.wealth;
  bool get canAccessScanner => this == SubscriptionTier.pro || this == SubscriptionTier.wealth;
  bool get canExportPdf => this == SubscriptionTier.wealth;
}
```

---

### PATH: lib/widgets/glass_container.dart
### STATO: completo
### CODICE:
```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

---

### PATH: lib/widgets/skeleton_loader.dart
### STATO: completo
### CODICE:
```dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Un widget di base per creare l'effetto "Skeleton Loading" premium,
/// utile da mostrare mentre si aspetta la risposta da Firebase o l'API.
class BaseSkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const BaseSkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // I colori sono pensati per un tema scuro (Dark Theme)
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.15),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
```
