# Mock Data e Stato dei Servizi Architetturali

Questo documento cristallizza i set di dati di test (Mock) essenziali per lo sviluppo UI, analizza nel dettaglio lo stato di implementazione dei "Motori" dell'app (`services/`) e verifica la configurazione dell'infrastruttura Cloud (Firebase).

---

## SEZIONE A — MOCK DATA (Marzo 2026)

Dati campione realistici progettati per popolare la UI in assenza di backend o in modalità *Offline-First*.

```json
[
  {
    "id": "mock_nvda_01",
    "ticker": "NVDA",
    "name": "NVIDIA Corporation",
    "category": "finanza",
    "quantity": 15.0,
    "entryPrice": 420.00,
    "currentPrice": 850.50,
    "currency": "USD",
    "bank": "Fineco"
  },
  {
    "id": "mock_eni_02",
    "ticker": "ENI.MI",
    "name": "Eni S.p.A.",
    "category": "finanza",
    "quantity": 500.0,
    "entryPrice": 13.40,
    "currentPrice": 14.60,
    "currency": "EUR",
    "bank": "Intesa Sanpaolo"
  },
  {
    "id": "mock_vwce_03",
    "ticker": "VWCE.DE",
    "name": "Vanguard FTSE All-World UCITS ETF",
    "category": "finanza",
    "quantity": 125.0,
    "entryPrice": 105.20,
    "currentPrice": 118.40,
    "currency": "EUR",
    "bank": "Directa"
  },
  {
    "id": "mock_btc_04",
    "ticker": "BTC",
    "name": "Bitcoin",
    "category": "crypto",
    "quantity": 0.45,
    "entryPrice": 45000.00,
    "currentPrice": 65200.00,
    "currency": "USD",
    "bank": "Ledger Cold Wallet"
  },
  {
    "id": "mock_eth_05",
    "ticker": "ETH",
    "name": "Ethereum",
    "category": "crypto",
    "quantity": 5.0,
    "entryPrice": 2200.00,
    "currentPrice": 3450.00,
    "currency": "USD",
    "bank": "Binance"
  },
  {
    "id": "mock_re_06",
    "ticker": "IMMOBILE",
    "name": "Appartamento Milano (Brera)",
    "category": "realEstate",
    "quantity": 1.0,
    "entryPrice": 400000.00,
    "currentPrice": 520000.00,
    "currency": "EUR",
    "bank": "BPM (Mutuo)"
  },
  {
    "id": "mock_lux_07",
    "ticker": "RLX-DAY",
    "name": "Rolex Daytona Ceramica",
    "category": "lusso",
    "quantity": 1.0,
    "entryPrice": 14500.00,
    "currentPrice": 28000.00,
    "currency": "EUR",
    "bank": "Cassetta di Sicurezza"
  },
  {
    "id": "mock_cash_08",
    "ticker": "CASH-EUR",
    "name": "Liquido C/C Fineco",
    "category": "cash",
    "quantity": 1.0,
    "entryPrice": 12500.00,
    "currentPrice": 12500.00,
    "currency": "EUR",
    "bank": "Fineco"
  }
]
```

---

## SEZIONE B — STATO DEI SERVIZI (`lib/services/`)

Analisi approfondita dei file di service (i "Motori" dell'app) e loro maturità.

### 1. `firebase_service.dart`
- **Metodi implementati:**
  - `Future<void> enableOfflinePersistence()`
  - `CollectionReference get _userPortfolioRef`
  - `CollectionReference get _userHistoricalSalesRef`
  - `Future<void> saveAsset(Asset asset)`
  - `Future<void> chiudiPosizione(Asset asset, double sellPrice)`
  - `Future<void> saveScannedAsset(ScannedAsset asset, String assignedBank)`
- **Metodi Stub/TODO:**
  - `String get _currentUserId`: Attualmente restituisce l'hardcode `'premium_user_001'` al posto del vero UID in attesa dell'integrazione di Firebase Auth.
- **Dipendenze esterne necessarie:** Pacchetto `cloud_firestore` (già installato).

### 2. `price_service.dart`
- **Metodi implementati:**
  - `Stream<List<Asset>> _createHybridSimulationStream()` (Motore Mock)
  - Logica su Riverpod Providers: `portfolioProvider`, `masterNetWorthProvider`, `masterLiabilitiesProvider`, `totalFilteredPerformanceProvider`.
- **Metodi Stub/TODO:**
  - Tutto il file funge attualmente da "Mock Intelligente" (elabora variazioni random in locale) o Stream diretto da Firestore. Manca un vero layer di fetch API (es. *AlphaVantage* o *CoinGecko*) per l'aggiornamento reale dei ticker "Finanza" e "Crypto" non gestiti manualmente.
- **Dipendenze esterne necessarie:** API Finanziarie per prezzi Live (In futuro).

### 3. `subscription_service.dart`
- **Metodi implementati:**
  - `void upgradeTo(SubscriptionTier newTier)`
  - Varie property extension (`canAccessMasterWealth`, `canAccessCrypto`, etc.)
- **Metodi Stub/TODO:**
  - Nessuno. L'implementazione logica statica è completa.
- **Dipendenze esterne necessarie:** Integrazione SDK di pagamento (es. *RevenueCat*) per lo sblocco reale dei tier.

### 4. `ai_aurelius_service.dart`
- **Metodi implementati:**
  - `Future<String> fetchGlobalNewsAnalysis()`
  - `Future<String> getAdvice(String userQuery, Map<String, dynamic> portfolioContext)`
  - `Future<String> analyzeAllocation()`
- **Metodi Stub/TODO:**
  - I metodi sono attualmente dei **puri Mock** (*Stub*). Usano `Future.delayed` per simulare l'attesa di rete e restituiscono testi hard-coded in base ai ticker presenti.
- **Dipendenze esterne necessarie:** SDK ufficiale Gemini (es. `@google/genai` Dart port) o invocazioni Vertex AI.

### 5. `scanner_service.dart`
- **Metodi implementati:**
  - `Future<List<ScannedAsset>> processScreenshot(String imagePath)`
- **Metodi Stub/TODO:**
  - **Stub totale**. Il metodo analitico aspetta 4 secondi e genera 4 elementi fittizi hardcoded. Non estrae fisicamente dal Path dell'immagine inserita.
- **Dipendenze esterne necessarie:** Vision LLM API (es. Google Gemini Vision) e un package per image-picking.

---

## SEZIONE C — FIREBASE

Stato dell'infrastruttura Cloud nel workspace locale:

- `google-services.json` presente? **No** (La cartella nativa `android/` non è presente / generata nel progetto).
- `GoogleService-Info.plist` presente? **No** (La cartella nativa `ios/` non è presente / generata nel progetto).
- **Collection Firestore già create:** Teoricamente chiamate nel codice come sub-collection del Tenant: 
  - `users/{uid}/portfolio`
  - `users/{uid}/historical_sales`
- **Firebase Auth attivo? Provider configurati?** **No**. Firebase Auth commentato nel codice (`// import 'package:firebase_auth/firebase_auth.dart';`) e ID Utente Stubbato staticamente (`premium_user_001`). Nessun provider configurato localmente.
- **Firebase Storage configurato?** **No**. Non vi è alcuna chiamata o import SDK per l'upload di immagini / screenshot nello space Firebase allo stato attuale.
