# 08 — MASTER PROMPT ANTIGRAVITY
## Portafoglio Aurelius — Piano di Sviluppo Completo
## Versione: 1.0 | Data: Marzo 2026
## Redatto da: Claude (Analista di Progetto)
## Codice Documento: AURELIUS-MP-08

---

> ⚠️ PRIMA DI TUTTO: LEGGI QUESTE REGOLE. SONO NON NEGOZIABILI.

---

## REGOLE OPERATIVE PERMANENTI

### REGOLA 1 — CARTELLA DI OUTPUT
Tutti i file prodotti, aggiornati o modificati devono essere
salvati ESCLUSIVAMENTE nella cartella: `_sviluppo_gae/`

- I file esistenti vanno aggiornati mantenendo il loro numero.
- I file nuovi vanno numerati in sequenza progressiva
  (attualmente il documento più recente è 07_, quindi il
  prossimo nuovo file sarà 08_, poi 09_, etc.)
- Formato nome sempre: `NN_nome_descrittivo.ext`

### REGOLA 2 — CONFERMA OBBLIGATORIA A CLAUDE
Prima di eseguire QUALSIASI delle seguenti azioni,
Antigravity DEVE fermarsi e inviare a Claude
(analista del progetto) una richiesta di conferma
nel formato esatto indicato di seguito:

Azioni che richiedono conferma obbligatoria:
- Modificare un file di codice esistente
- Eliminare o sovrascrivere codice esistente
- Aggiungere una nuova dipendenza al pubspec.yaml
- Cambiare la struttura di navigazione (app_router.dart)
- Cambiare un modello dati (qualsiasi file in models/)
- Cambiare il Design System (theme.dart)
- Qualsiasi scelta architetturale non già documentata
  nei file di progetto in _sviluppo_gae/

**FORMATO OBBLIGATORIO DELLA RICHIESTA:**
```
⚠️ RICHIESTA CONFERMA CLAUDE [AURELIUS-MP-08]:
Sto per: [descrizione esatta dell'azione]
File coinvolto: [path completo]
Motivazione: [perché è necessario]
Alternativa se esiste: [opzione B]
Procedo?
```

Antigravity NON PROCEDE finché non riceve
risposta affermativa esplicita da Claude o Gaetano.

### REGOLA 3 — INTEGRITÀ DEL PROGETTO
L'app deve rimanere SEMPRE:
- POTENTE → dati granulari, calcoli precisi, logica robusta
- SEMPLICE → interfaccia pulita, zero clutter, gesti intuitivi
- BELLA → Glassmorphism, Dark Mode, Oro #D4AF37, Font Inter
- FUNZIONALE → comprensibile anche a chi non è esperto di finanza

La complessità è sotto il cofano. Mai in superficie.
Qualsiasi feature complessa deve essere presentata
all'utente finale in forma semplice e immediata.

---

## CONTESTO PROGETTO

Stai lavorando su "Portafoglio Aurelius", un'app Flutter
premium per il monitoraggio del patrimonio personale (HNWI).
Aggrega: Finanza Tradizionale, Crypto, Immobiliare, Lusso.

**Stack tecnico confermato (NON modificare versioni):**
- Flutter + Dart SDK >=3.3.0
- State management: flutter_riverpod ^2.5.1 (PURO, nessun mix)
- Routing: go_router ^13.2.0
- Database: Firebase Firestore (offline-first)
- Code gen: freezed ^2.4.7 + json_serializable ^6.7.1
- UI: shimmer ^3.0.0, fl_chart ^0.66.0, flutter_svg ^2.0.10
- Font: Google Fonts Inter

**Design Tokens confermati (NON modificare):**
- Background: #000000
- Card Surface: #1C1C1E
- Accent Oro: #D4AF37
- Testo primario: #FFFFFF
- Testo secondario: #8E8E93
- Blur glassmorphism: sigmaX 10.0 / sigmaY 10.0
- Border radius card: 20.0
- Border width: 1.5, opacità 10%
- Padding interno card: 16.0

**Stato attuale confermato:**
- COMPLETI: main.dart, theme.dart, app_router.dart (parziale),
  user_profile.dart, firebase_service.dart, price_service.dart,
  subscription_service.dart, glass_container.dart,
  skeleton_loader.dart, neon_glass_container.dart
- NON ESISTENTE: asset_model.dart (la classe Asset è
  attualmente dentro price_service.dart — va estratta)
- STUB TOTALI: scanner_service.dart, ai_aurelius_service.dart,
  biometric_gate.dart, dashboard_screen.dart,
  master_dashboard_screen.dart, scanner_screen.dart,
  ai_advisor_screen.dart, help_screen.dart,
  subscription_screen.dart

---

## PIANO DI SVILUPPO — FASI ORDINATE

Segui le fasi nell'ordine esatto. Non saltare fasi.
Non iniziare una fase senza completare la precedente.
Ogni fase che modifica codice richiede conferma Claude.

---

## FASE 1 — FONDAMENTA DATI
### Codice Interno: AURELIUS-MP-08-F1
### Priorità: CRITICA — Tutto dipende da questa fase

**OBIETTIVO:**
Estrarre la classe Asset da price_service.dart e creare
un file dedicato lib/models/asset_model.dart con il
modello completo, immutabile e serializzabile.

**AZIONE RICHIESTA:**

⚠️ Prima di toccare price_service.dart, chiedi conferma
a Claude con il formato standard.

Crea: `lib/models/asset_model.dart`

Il modello Asset deve contenere TUTTI questi campi:
```
- id (String, required)
- ticker (String, required)
- name (String, required)
- category (AssetCategory enum, required)
- quantity (double, required)
- entryPrice (double, required)
- currentPrice (double, required)
- currency (String, default 'EUR')
- bank (String, required)
- mortgageResidual (double, default 0.0) → per immobili
- monthlyRent (double, default 0.0) → per immobili a reddito
- cryptoLocation (String, default '') → wallet/exchange
- expirationDate (DateTime?) → per previdenza/polizze
- notes (String?) → annotazioni personali utente
```

Enum AssetCategory confermato:
`[finanza, crypto, realEstate, cash, metalli, lusso, previdenza]`

Metodi calcolati da mantenere sul modello:
- `totalGrossValue` → currentPrice * quantity
- `totalNetValue` → totalGrossValue - mortgageResidual
- `totalEntryValue` → entryPrice * quantity
- `profitLoss` → totalGrossValue - totalEntryValue
- `profitLossPercent` → ((currentPrice - entryPrice) / entryPrice) * 100
- `conversionRate(String targetCurrency)` → dal map forex
- `totalNetValueIn(String targetCurrency)` → con conversione
- `totalGrossValueIn(String targetCurrency)` → con conversione

Usa @freezed per immutabilità.
Includi fromFirestore(DocumentSnapshot) e toMap().

Dopo la creazione del file, aggiorna price_service.dart
rimuovendo la classe Asset duplicata e importando il nuovo
asset_model.dart. Richiedi conferma prima di modificare
price_service.dart.

**OUTPUT ATTESO:**
- `lib/models/asset_model.dart` (nuovo)
- `price_service.dart` aggiornato (richiede conferma)
- Nessun errore di compilazione

---

## FASE 2 — BIOMETRIC GATE
### Codice Interno: AURELIUS-MP-08-F2
### Priorità: ALTA — È la prima schermata che l'utente vede

**OBIETTIVO:**
Implementare la schermata di accesso biometrico.
Deve essere visivamente impeccabile ed emotivamente
rassicurante. L'utente deve sentirsi nel caveau
digitale della sua vita finanziaria.

**FILE DA CREARE:** `lib/screens/biometric_gate.dart`

**SPECIFICHE UI/UX:**
Layout centrato, sfondo #000000 puro.

Elementi dall'alto verso il basso:
1. Logo/icona Aurelius (usa flutter_svg o Icon sfumata oro)
   con leggero shimmer animato sul bordo dorato
2. Testo "Portafoglio Aurelius" in Inter Bold 28px, oro
3. Testo secondario "Il tuo patrimonio. Sempre con te."
   in Inter Regular 15px, colore #8E8E93
4. Spazio verticale generoso (40px)
5. Pulsante biometrico centrale: cerchio GlassContainer
   con icona lucchetto o impronta. Al tap: simula
   autenticazione con Future.delayed(800ms) poi naviga
   a /dashboard via go_router context.go('/dashboard')
6. In basso: link testuale piccolo "Accedi con PIN"
   (non implementato, solo placeholder visivo)

**LOGICA:**
- Usa StatefulWidget o ConsumerWidget
- Stato: isAuthenticating (bool) per mostrare loading
- Durante isAuthenticating: mostra CircularProgressIndicator
  colorato oro (#D4AF37) al posto del pulsante
- Dopo autenticazione simulata: context.go('/dashboard')
- Privacy Mode: NON applicabile su questa schermata

**NOTA IMPORTANTE:**
Autenticazione biometrica REALE (local_auth package)
richiede conferma Claude prima di essere aggiunta.
Per ora: simulazione con Future.delayed è corretta.

---

## FASE 3 — DASHBOARD PRINCIPALE
### Codice Interno: AURELIUS-MP-08-F3
### Priorità: ALTA — È il cuore dell'app

**OBIETTIVO:**
Implementare dashboard_screen.dart. Questa è la schermata
principale che l'utente vedrà ogni giorno. Deve mostrare
il patrimonio in modo chiaro, bello e immediato.
Principio guida: "Un colpo d'occhio deve bastare."

**FILE DA CREARE/COMPLETARE:** `lib/screens/dashboard_screen.dart`

**STRUTTURA SCHERMATA:**

La schermata è uno Scaffold con:
- AppBar trasparente (già configurata nel theme)
- Body: CustomScrollView con SliverList
- BottomNavigationBar con 4 tab (vedi sotto)
- FAB (FloatingActionButton) oro in basso a destra:
  icona + (aggiungi asset) — per ora naviga a placeholder

**SEZIONE A — HEADER PATRIMONIO (Top Card)**
GlassContainer full-width, padding 20px.
Contiene:
- Riga superiore: "Il mio Patrimonio" (label piccolo, #8E8E93)
  + icona occhio a destra (toggle Privacy Mode)
- Valore Net Worth principale: numero grande Inter Bold 36px
  bianco. Se Privacy Mode attivo: mostra "••••••" invece
  del numero. Usa masterNetWorthProvider da price_service.
- Valuta selezionata (EUR/USD/GBP) come badge piccolo oro
- Riga inferiore: Performance globale (+12.4% ↑) colorata
  verde se positivo, rossa se negativo
- Skeleton loader (BaseSkeletonLoader) mentre i dati caricano

**SEZIONE B — BARRE CATEGORIE (Asset Allocation)**
Riga orizzontale scrollabile di chip/badge:
"Tutte" | "Finanza" | "Crypto" | "Immobili" | "Lusso" | "Liquidità"
Al tap su un chip: filtra il portfolio sottostante.
Chip selezionato: bordo oro, sfondo lievemente illuminato.
Chip non selezionato: GlassContainer standard.
Usa selectedBankFilterProvider (già esistente) o crea
un provider equivalente per categoria.

⚠️ RICHIESTA CONFERMA CLAUDE se crei un nuovo provider
che modifica la logica di filtraggio esistente.

**SEZIONE C — LISTA ASSET**
Lista verticale scrollabile di AssetCard.
Ogni AssetCard (widget separato in lib/widgets/asset_card.dart)
è un GlassContainer con:
- Sinistra: icona categoria (colore per categoria:
  oro per finanza, neon cyan per crypto, verde per
  immobili, viola per lusso, grigio per cash)
- Centro: nome asset (Inter SemiBold 16px) + ticker
  (Inter Regular 13px, #8E8E93) + nome banca/custodia
- Destra: valore totale (Inter Bold 16px bianco) +
  performance % (verde/rossa) sulla riga sotto
- Se Privacy Mode: tutti i valori numerici mostrano "••••"
- Skeleton loader mentre carica

**BOTTOM NAVIGATION BAR (4 tab fissi):**
Tab 1: 🏠 Home → /dashboard (schermata corrente)
Tab 2: 📊 Master → /master (gate subscription wealth)
Tab 3: 🤖 AI → /advisor (gate subscription pro)
Tab 4: ⚙️ Impostazioni → /settings (placeholder)

Usa GlassContainer come sfondo della bottom bar.
Tab selezionato: icona e label in oro #D4AF37.
Tab non selezionato: icona #8E8E93.

**SUBSCRIPTION GATE:**
Se utente tenta di accedere a Master o AI senza
il piano corretto: mostra BottomSheet con presentazione
del piano necessario e pulsante "Scopri i Piani".
Usa subscriptionProvider già implementato.

**DATI:**
Usa filteredPortfolioProvider per la lista.
Usa masterNetWorthProvider per il totale.
Usa totalFilteredPerformanceProvider per la performance.
Tutti già presenti in price_service.dart.

---

## FASE 4 — MASTER DASHBOARD (Piano Wealth)
### Codice Interno: AURELIUS-MP-08-F4
### Priorità: MEDIA-ALTA

**OBIETTIVO:**
Implementare master_dashboard_screen.dart.
Visione patrimoniale d'insieme per utenti Wealth.
Deve sembrare una pagina estratta da un report
di private banking svizzero — ma semplice e immediata.

**FILE DA CREARE:** `lib/screens/master_dashboard_screen.dart`

**GATE:** Solo per SubscriptionTier.wealth.
Se utente non ha il piano: mostra paywall inline.

**STRUTTURA SCHERMATA:**

**Card 1 — Net Worth Globale**
GlassContainer prominente con:
- "Net Worth Totale" label
- Valore grande (masterNetWorthProvider)
- Asset lordi vs Passivi (mutui etc.)
  usando masterAssetsGrossValueProvider e masterLiabilitiesProvider
- Privacy Mode: oscura tutti i valori

**Card 2 — Pie Chart Allocazione**
Usa fl_chart (PieChart widget).
Ogni spicchio = una categoria Asset.
Colori per categoria (usa palette già definita):
- Finanza: #D4AF37 (oro)
- Crypto: #00FFFF (cyan neon)
- Immobili: #4CAF50 (verde)
- Lusso: #9C27B0 (viola)
- Liquidità: #607D8B (grigio)
- Metalli: #FF9800 (ambra)
- Previdenza: #03A9F4 (azzurro)

Sotto il grafico: legenda con nome categoria + % + valore.
Se Privacy Mode: mostra solo le % senza valori assoluti.

**Card 3 — Performance per Categoria**
Lista verticale, una riga per categoria:
[icona] [nome categoria] [valore totale] [% gain/loss]
Con barra orizzontale colorata proporzionale alla % di allocazione.

**Card 4 — Cashflow Mensile** (se dati disponibili)
Mostra: redditi da affitti (monthlyRent aggregato)
vs costi stimati (placeholder per ora).

**Card 5 — Obiettivo Finanziario**
Usa savingsGoalProvider (già in price_service).
Mostra barra di progresso lineare oro verso l'obiettivo.
Testo: "Hai raggiunto il X% del tuo obiettivo"

---

## FASE 5 — SCHERMATA AGGIUNGI ASSET
### Codice Interno: AURELIUS-MP-08-F5
### Priorità: ALTA — Senza questa non si può usare l'app

**OBIETTIVO:**
Creare la schermata per aggiungere manualmente un asset.
Deve essere guidata, passo-passo, senza tecnicismi.
L'utente non deve sentirsi su un foglio Excel.

**FILE DA CREARE:** `lib/screens/add_asset_screen.dart`

**UX PRINCIPLE:** Un campo alla volta. Wizard a step.

**STEP 1 — Categoria**
Griglia 2x4 di GlassContainer selezionabili.
Ogni box: icona grande + label sotto.
Le 7 categorie: Azioni/ETF | Crypto | Immobile |
Oro & Metalli | Lusso | Liquidità | Previdenza
Al tap: il box si illumina con bordo oro e si avanza.

**STEP 2 — Informazioni Base**
Campi TextField in stile scuro con bordo gold sottile:
- Nome asset (es. "Appartamento Milano")
- Ticker/Codice (opzionale, es. "NVDA", "BTC")
- Banca / Custodia / Posizione (es. "Fineco", "Ledger")

**STEP 3 — Valori Economici**
- Quantità (numerico)
- Prezzo di carico (prezzo medio di acquisto)
- Valore attuale stimato
- Valuta (dropdown: EUR / USD / GBP)

**STEP 4 — Dettagli Specifici** (condizionale per categoria)
- Se Immobile: mostra campo "Debito residuo mutuo" e "Affitto mensile"
- Se Crypto: mostra campo "Wallet / Exchange"
- Se Previdenza: mostra campo "Data scadenza polizza"
- Altrimenti: nessun campo aggiuntivo

**STEP 5 — Conferma e Salvataggio**
Riepilogo visivo card con tutti i dati inseriti.
Pulsante "Aggiungi al Portafoglio" oro, full-width.
Al tap: chiama firebaseService.saveAsset() e
naviga back alla dashboard con messaggio di successo.

**NOTA:** Aggiungi route /add-asset in app_router.dart.
⚠️ Modifica di app_router.dart richiede conferma Claude.

---

## FASE 6 — SUBSCRIPTION SCREEN (Paywall)
### Codice Interno: AURELIUS-MP-08-F6
### Priorità: MEDIA

**OBIETTIVO:**
Schermata paywall elegante. Non deve sembrare
una pubblicità aggressiva. Deve sembrare un invito
esclusivo a un club privato.

**FILE DA CREARE:** `lib/screens/subscription_screen.dart`

**STRUTTURA:**

Header: "Sblocca il tuo Potenziale Finanziario"
Sottotitolo: "Scegli il piano che si adatta al tuo patrimonio"

3 card piani (GlassContainer, scrollabile orizzontalmente):

**PIANO CORE — €9,99/mese**
Badge: "Per iniziare"
Features: Asset illimitati manuali, 2 integrazioni
bancarie, storico 12 mesi, Privacy Mode, export CSV
Pulsante: "Inizia ora" (bordo gold)

**PIANO PRO — €24,99/mese** ← EVIDENZIATO
Badge: "Il più scelto" con sfondo oro
Features: Tutto di Core + integrazioni automatiche
illimitate, performance per categoria, scenario
planner, document vault, advisor sharing
Pulsante: "Scegli Pro" (sfondo oro, testo nero)

**PIANO WEALTH — €79,99/mese**
Badge: "Per patrimoni complessi"
Features: Tutto di Pro + family office, portafogli
annidati, tax engine avanzato, report PDF, supporto
dedicato
Pulsante: "Scegli Wealth" (bordo oro platino)

In fondo: "Tutti i piani includono 14 giorni di prova
gratuita. Nessun addebito immediato."

Logica: Al tap su un piano chiama
subscriptionProvider.notifier.upgradeTo() e naviga back.
(Integrazione pagamento reale: RevenueCat, richiederà
conferma Claude in futuro.)

---

## FASE 7 — AGGIORNA ROUTER
### Codice Interno: AURELIUS-MP-08-F7
### Priorità: NECESSARIA al termine delle Fasi 2-6

⚠️ RICHIESTA CONFERMA CLAUDE OBBLIGATORIA
prima di toccare app_router.dart.

Dopo conferma, aggiorna lib/core/router/app_router.dart
aggiungendo tutte le route delle nuove schermate:

```
/gate          → BiometricGate (già presente)
/dashboard     → DashboardScreen (già presente)
/master        → MasterDashboardScreen (nuova)
/advisor       → AiAdvisorScreen (nuova, placeholder)
/scanner       → ScannerScreen (nuova, placeholder)
/add-asset     → AddAssetScreen (nuova)
/subscription  → SubscriptionScreen (nuova)
/settings      → SettingsScreen (placeholder)
```

Aggiungi la logica di redirect per subscription gate:
se l'utente prova ad accedere a /master senza tier wealth,
redirect a /subscription con parametro ?from=master

---

## FASE 8 — COMPLETAMENTO DESIGN TOKENS
### Codice Interno: AURELIUS-MP-08-F8
### Priorità: MEDIA

**OBIETTIVO:**
Completare i valori [DA DEFINIRE] identificati
in 07_design_tokens.md e aggiungerli a theme.dart.

⚠️ Modifica di theme.dart richiede conferma Claude.

Valori da definire e aggiungere:
- successColor (verde gain): proposta #4CAF50
- errorColor (rosso loss): proposta #F44336
- cryptoNeonColor (cyan crypto): proposta #00E5FF
- Margine laterale pagina: proposta 16.0
- Gap verticale tra sezioni: proposta 12.0
- Altezza bottom navigation bar: proposta 60.0
- Durata transizioni navigazione: proposta 300ms
- Durata animazioni valori: proposta 600ms
- Curva animazione: proposta Curves.easeInOut

Prima di modificare: presenta i valori proposti
a Claude per approvazione con il formato standard.

---

## PRIORITÀ DI ESECUZIONE RIEPILOGATA

```
FASE 1 [AURELIUS-MP-08-F1] → asset_model.dart    ← INIZIA QUI
FASE 2 [AURELIUS-MP-08-F2] → biometric_gate.dart
FASE 3 [AURELIUS-MP-08-F3] → dashboard_screen.dart
FASE 5 [AURELIUS-MP-08-F5] → add_asset_screen.dart
FASE 4 [AURELIUS-MP-08-F4] → master_dashboard_screen.dart
FASE 6 [AURELIUS-MP-08-F6] → subscription_screen.dart
FASE 7 [AURELIUS-MP-08-F7] → app_router.dart update
FASE 8 [AURELIUS-MP-08-F8] → theme.dart update
```

Le fasi 3, 4, 5 possono procedere in parallelo
dopo che la Fase 1 è confermata e stabile.

---

## RIFERIMENTO MOCK DATA (usa questi per popolare la UI)

```dart
// Mock assets da usare in _cachedMockAssets
// Già presenti in price_service.dart — NON duplicare

// Finanza
{ ticker: 'NVDA', name: 'NVIDIA Corporation',
  category: finanza, quantity: 15, entryPrice: 420.00,
  currentPrice: 850.50, currency: 'USD', bank: 'Fineco' }

{ ticker: 'ENI.MI', name: 'Eni S.p.A.',
  category: finanza, quantity: 500, entryPrice: 13.40,
  currentPrice: 14.60, currency: 'EUR', bank: 'Intesa Sanpaolo' }

{ ticker: 'VWCE.DE', name: 'Vanguard FTSE All-World',
  category: finanza, quantity: 125, entryPrice: 105.20,
  currentPrice: 118.40, currency: 'EUR', bank: 'Directa' }

// Crypto
{ ticker: 'BTC', name: 'Bitcoin',
  category: crypto, quantity: 0.45, entryPrice: 45000,
  currentPrice: 65200, currency: 'USD', bank: 'Ledger Cold Wallet' }

{ ticker: 'ETH', name: 'Ethereum',
  category: crypto, quantity: 5, entryPrice: 2200,
  currentPrice: 3450, currency: 'USD', bank: 'Binance' }

// Real Estate
{ ticker: 'IMMOBILE', name: 'Appartamento Milano (Brera)',
  category: realEstate, quantity: 1, entryPrice: 400000,
  currentPrice: 520000, currency: 'EUR', bank: 'BPM (Mutuo)',
  mortgageResidual: 180000, monthlyRent: 2200 }

// Luxury
{ ticker: 'RLX-DAY', name: 'Rolex Daytona Ceramica',
  category: lusso, quantity: 1, entryPrice: 14500,
  currentPrice: 28000, currency: 'EUR', bank: 'Cassetta Sicurezza' }

// Cash
{ ticker: 'CASH-EUR', name: 'Liquido C/C Fineco',
  category: cash, quantity: 1, entryPrice: 12500,
  currentPrice: 12500, currency: 'EUR', bank: 'Fineco' }
```

---

## DOCUMENTAZIONE OBBLIGATORIA

Al completamento di OGNI fase, Antigravity deve:

1. Creare o aggiornare il file di log nella cartella
   _sviluppo_gae/ con il progressivo corretto:
   `NN_log_fase_[codice].md`

2. Il log deve contenere:
   - Codice fase completata (es. AURELIUS-MP-08-F1)
   - File creati (con path completo)
   - File modificati (con descrizione della modifica)
   - File NON toccati (conferma integrità)
   - Eventuali problemi riscontrati
   - Prossimo step suggerito

3. Se durante una fase emerge una scelta
   architetturale non prevista da questo documento:
   STOP. Richiedi conferma Claude con formato standard
   includendo il codice della fase nel messaggio.

---

*Fine documento AURELIUS-MP-08*
*Redatto da Claude — Analista di Progetto Portafoglio Aurelius*
*Qualsiasi modifica a questo documento richiede notifica a Claude*