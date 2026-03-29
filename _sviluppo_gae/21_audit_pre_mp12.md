# 21 — AUDIT PRE-MP12
## Data: 28 Marzo 2026

### SCHERMATE — STATO
Per ogni schermata in `lib/screens/`:
- `add_asset_screen.dart`: Sì. Pienamente funzionante e connessa a Firestore.
- `ai_advisor_screen.dart`: Sì. Connessa all'Aurelius Service (Gemini reale).
- `biometric_gate.dart`: Parziale. UI completata, richiede integrazione nativa local_auth.
- `dashboard_screen.dart`: Sì. Completiva con menu utente Auth e UI patrimoniale.
- `help_screen.dart`: Parziale. Stub visuale, da integrare.
- `info_screen.dart`: Parziale. Stub visuale, manca wiring.
- `login_screen.dart`: Sì. Firebase Auth + Riverpod fully wired (SignIn/SignUp distinction).
- `master_dashboard_screen.dart`: Sì. Grafici interattivi e protezione router per piano Wealth.
- `onboarding_screen.dart`: Sì. Wizard post-registrazione completato.
- `rientro_post_vendita.dart`: **No**. Presenta errore sintattico di classe `Asset` non referenziata correttamente.
- `scanner_screen.dart`: Sì. Vision LLM integrato e funzionante con Firestore import.
- `settings_screen.dart`: Sì. Preference UI con update statale.
- `subscription_screen.dart`: Sì. UI paywall integrata.

### SERVIZI — STATO
Per ogni file in `lib/services/`:
- `ai_aurelius_service.dart`: REALE. Connesso a Google Generative AI.
- `auth_service.dart`: REALE. Connesso a FirebaseAuth.
- `firebase_service.dart`: REALE. Connesso a Cloud Firestore.
- `price_service.dart`: IBRIDO. Mock pre-login, Reale post-login (Firestore Collection).
- `scanner_service.dart`: REALE. Connesso a API Vision LLM.
- `subscription_service.dart`: MOCK. Riverpod state non persistito, propedeutico a RevenueCat/Stripe.

### WARNING FLUTTER ANALYZE
Lista completa (7 issues found):
1. `lib/screens/help_screen.dart` — Unnecessary import `cupertino.dart`.
2. `lib/screens/rientro_post_vendita.dart` — **ERROR**: The method `Asset` isn't defined per `RientroPostVenditaScreen`. Missing model import.
3. `lib/services/ai_aurelius_service.dart` — Unnecessary `!` operator.
4. `lib/services/ai_aurelius_service.dart` — Unnecessary `!` operator.
5. `lib/services/firebase_service.dart` — Unused import `price_service.dart`.
6. `lib/services/price_service.dart` — Unused element `_simulatePricesOffline`.
7. `lib/services/scanner_service.dart` — Unnecessary `!` operator.

### FEATURE MANCANTI PRIORITARIE
In ordine di impatto sul business:
1. **Tax Engine Italiano**: Logica per calcolo differito e reportistica del 26% sulle plusvalenze aggregate (cruciale per investitori pro e feature killer vs. altri competitor).
2. **Integrazioni Bancarie / API**: Connessione via Plaid o SaltEdge nativa per estrarre direttamente i portfolio passivi.
3. **Pagamento Paywall (RevenueCat)**: Convertire il mock del SubscriptionService in veri gateway acquisto In-App per sbloccare la monetizzazione.

### DEBITO TECNICO
Lista problemi noti da risolvere:
- Errore di import/undefined class su `rientro_post_vendita.dart` che blocca potenziali strict check del CI/CD.
- Refactoring warning in cleanup (unused imports & unused functions come `_simulatePricesOffline`).
- `biometric_gate.dart` è limitato a un workaround temporale mockup e necessita l'aggiunta plugin `local_auth`. 
- Le API Keys Gemnin attualmente iniettate con `!`, le firme retro-compatibili generano hint sintattici di warning a causa dell'SDK Google Generative AI su Flutter.
