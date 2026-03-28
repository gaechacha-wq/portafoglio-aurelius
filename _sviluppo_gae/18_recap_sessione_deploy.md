# 18 — RECAP SESSIONE MARZO 2026
## Portafoglio Aurelius — Stato al 28 Marzo 2026
## Codice: AURELIUS-MP-09-DEPLOY
## Redatto da: Claude (Analista di Progetto)

---

> ⚠️ DOCUMENTO DI RIFERIMENTO PER TUTTO IL TEAM
> Chiunque prenda in carico il progetto —
> sviluppatori, AI agent, consulenti —
> deve leggere questo file prima di operare.

---

## 1. COSA È PORTAFOGLIO AURELIUS

App Flutter premium per il monitoraggio
del patrimonio personale (HNWI).
Aggrega: Finanza Tradizionale, Crypto,
Immobiliare, Lusso, Metalli, Previdenza.

Target: individui ad alto patrimonio netti
italiani (HNWI), con distribuzione B2B2C
tramite commercialisti e wealth manager.

Design system: Glassmorphism Dark Mode,
Oro #D4AF37, Font Inter, sfondo #000000.

Principio guida: POTENTE sotto il cofano,
SEMPLICE in superficie, BELLO sempre.

---

## 2. REGOLE OPERATIVE PERMANENTI

### REGOLA 1 — CARTELLA DI OUTPUT
Tutti i file prodotti vanno in: _sviluppo_gae/
Numerazione progressiva: NN_nome_file.ext

### REGOLA 2 — CONFERMA OBBLIGATORIA
Qualsiasi modifica a file esistenti,
dipendenze, router, modelli dati o
design system RICHIEDE conferma esplicita
di Claude (analista di progetto) nel formato:

⚠️ RICHIESTA CONFERMA CLAUDE [CODICE]:
Sto per: [azione]
File coinvolto: [path]
Motivazione: [perché]
Alternativa: [opzione B]
Procedo?

### REGOLA 3 — INTEGRITÀ PROGETTO
L'app deve restare sempre:
POTENTE — SEMPLICE — BELLA — FUNZIONALE

---

## 3. STACK TECNICO CONFERMATO

- Flutter 3.19.6 + Dart 3.3.4
- State management: flutter_riverpod 2.6.1
  (PURO — nessun mix con altri manager)
- Routing: go_router 13.2.5
- Database: Firebase Firestore (offline-first)
- Code gen: freezed 2.5.2 + json_serializable
- UI: shimmer, fl_chart 0.66.2, flutter_svg
- Font: Google Fonts Inter
- AI: google_generative_ai 0.4.7 (Gemini)
- Image: image_picker 1.1.2
- Env: flutter_dotenv 5.2.1
- Infra: Firebase Hosting (deploy web)

---

## 4. ARCHITETTURA FILE PROGETTO

```
lib/
├── main.dart                    ✅ COMPLETO
├── core/
│   ├── theme.dart               ✅ COMPLETO
│   └── router/app_router.dart  ✅ COMPLETO (8 route)
├── models/
│   ├── asset_model.dart         ✅ COMPLETO (Freezed)
│   └── user_profile.dart        ✅ COMPLETO
├── services/
│   ├── firebase_service.dart    ✅ COMPLETO
│   ├── price_service.dart       ✅ COMPLETO
│   ├── subscription_service.dart ✅ COMPLETO
│   ├── ai_aurelius_service.dart ✅ GEMINI REALE
│   └── scanner_service.dart     ✅ VISION REALE
├── widgets/
│   ├── glass_container.dart     ✅ COMPLETO
│   ├── neon_glass_container.dart ✅ COMPLETO
│   ├── skeleton_loader.dart     ✅ COMPLETO
│   └── asset_card.dart          ✅ COMPLETO
└── screens/
    ├── biometric_gate.dart      ✅ COMPLETO
    ├── dashboard_screen.dart    ✅ COMPLETO
    ├── master_dashboard_screen.dart ✅ COMPLETO
    ├── add_asset_screen.dart    ✅ COMPLETO
    ├── subscription_screen.dart ✅ COMPLETO
    ├── settings_screen.dart     ✅ REALE
    ├── ai_advisor_screen.dart   ✅ REALE (Gemini)
    └── scanner_screen.dart      ✅ REALE (Vision)
```

---

## 5. ROUTING — 8 ROUTE ATTIVE

```
/gate         → BiometricGate (entry point)
/dashboard    → DashboardScreen (home)
/master       → MasterDashboardScreen
              → GATE: solo tier Wealth
              → Redirect: /subscription?from=master
/advisor      → AiAdvisorScreen
              → GATE: Pro e Wealth
/scanner      → ScannerScreen
              → GATE: Pro e Wealth
/add-asset    → AddAssetScreen
/subscription → SubscriptionScreen (paywall)
/settings     → SettingsScreen
```

---

## 6. PIANI ABBONAMENTO

```
Free  → 5 asset max, nessuna integrazione
Core  → €9,99/mese — asset illimitati manuali
Pro   → €24,99/mese — scanner, AI advisor
Wealth → €79,99/mese — master dashboard,
         family office, tax engine
```

Provider: subscriptionProvider (Riverpod)
Enum: SubscriptionTier {base, pro, wealth}

---

## 7. DESIGN TOKENS

```
Background:     #000000
Card Surface:   #1C1C1E
Accent Oro:     #D4AF37  ← colore signature
Testo primario: #FFFFFF
Testo secondario: #8E8E93
Gain (verde):   #4CAF50
Loss (rosso):   #F44336
Crypto (cyan):  #00E5FF
Blur glass:     sigmaX 10.0 / sigmaY 10.0
Border radius:  20.0
Border width:   1.5px, opacità 10%
Padding card:   16.0px
```

---

## 8. CONFIGURAZIONE AMBIENTE

### File .env (NON nel repository)
```
GEMINI_API_KEY=LA_TUA_CHIAVE_REALE_QUI
```
La chiave si ottiene su: aistudio.google.com
NON scrivere mai la chiave in chat o commit.

### Firebase
- Progetto: portafoglio-aurelius
- Piano: Spark (gratuito)
- Hosting: Firebase Hosting
- Database: Firestore (non ancora attivato)
- Auth: non ancora configurato

### Flutter PATH (Mac M5 Pro di Gaetano)
```
export PATH="$HOME/development/flutter/bin:$PATH"
```

---

## 9. STATO DEPLOY WEB
- Firebase Hosting: ONLINE ✅
- URL pubblico: https://portafoglio-aurelius.web.app
- Localhost: http://localhost:8080 ✅
- Build: flutter build web --release
- Data deploy: 28 Marzo 2026
- Prossimo step: attivare Firebase Auth
  e Firestore per utenti reali

---

## 10. COSA NON È ANCORA FATTO

### Bloccante per utenti reali:
- Firebase Auth (login/registrazione)
- Firestore attivato con regole sicurezza
- google-services.json (Android)
- GoogleService-Info.plist (iOS)

### Feature future pianificate:
- Tax Engine italiano (imposta sostitutiva 26%)
- Connettività bancaria Salt Edge (API)
- Monte Carlo stress test
- Geographical Risk Mapping
- Estate planning / passaggio generazionale
- Family office (5 utenti collaboratori)
- Refactoring colori hard-coded → token theme

### Platform future:
- iOS (richiede Xcode + Apple Developer €99/anno)
- Android (richiede Android Studio + Google Play €25)

---

## 11. COMANDI UTILI

```bash
# Avvia in locale su Chrome
flutter run -d chrome --web-port 8080

# Build per produzione web
flutter build web --release

# Deploy su Firebase Hosting
firebase deploy --only hosting

# Rigenera codice Freezed
dart run build_runner build --delete-conflicting-outputs

# Installa dipendenze
flutter pub get
```

---

## 12. LOG DELLE SESSIONI

| File | Contenuto |
|------|-----------|
| 09_log_fase_AURELIUS-MP-08-F1.md | asset_model.dart |
| 10_log_fase_AURELIUS-MP-08-F2.md | biometric_gate |
| 11_log_fase_AURELIUS-MP-08-F3.md | dashboard |
| 12_log_fase_AURELIUS-MP-08-F5.md | add_asset |
| 13_log_fase_AURELIUS-MP-08-F4.md | master dashboard |
| 14_log_fase_AURELIUS-MP-08-F6.md | subscription |
| 15_log_fase_AURELIUS-MP-08-F7.md | router |
| 16_log_fase_AURELIUS-MP-08-F8.md | design tokens |
| 17_log_ciclo_AURELIUS-MP-09.md | AI + Scanner |
| 18_recap_sessione_deploy.md | questo file |

---

*Redatto da Claude — Analista di Progetto*
*Data: 28 Marzo 2026*
*Prossimo aggiornamento: dopo deploy completato*