# LOG CICLO AURELIUS-MP-17
## Data: 29 Marzo 2026

### OBIETTIVO
Persistenza completa dati utente su Firestore. Preferenze salvate e ripristinate ad ogni accesso.

### FILE MODIFICATI
- lib/services/firebase_service.dart
  (3 nuovi metodi profilo)
- lib/screens/login_screen.dart
  (caricamento profilo al login)
- lib/screens/settings_screen.dart
  (salvataggio automatico preferenze)
- lib/screens/add_asset_screen.dart
  (feedback migliorato)

### STRUTTURA FIRESTORE AGGIORNATA
users/{userId}/
  ├── displayName
  ├── subscriptionTier
  ├── savingsGoal
  ├── targetCurrency
  ├── privacyMode
  ├── lastUpdated
  ├── createdAt
  └── portfolio/{assetId}

### PROSSIMI STEP
- RevenueCat pagamenti (MP-18)
- iOS build (MP-19)
- Android build (MP-20)
