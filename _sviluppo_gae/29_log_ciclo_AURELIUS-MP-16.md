# LOG CICLO AURELIUS-MP-16
## Data: 29 Marzo 2026

### FILE CREATI
- lib/widgets/aurelius_snackbar.dart

### FILE MODIFICATI
- lib/screens/profile_screen.dart
- lib/screens/onboarding_screen.dart
- lib/screens/add_asset_screen.dart
- lib/screens/login_screen.dart
- lib/screens/tax_screen.dart
- lib/screens/scanner_screen.dart
- lib/screens/ai_advisor_screen.dart

### FEATURE AGGIUNTE
- Avatar con iniziali utente
- Statistiche portafoglio in profilo
- Onboarding step 4 obiettivo
- Sistema notifiche AureliusSnackBar
- Notifiche consistenti in tutta l'app

### VERIFICA CONNESSIONE FIRESTORE
- Salvataggio asset: Esito Positivo (corretto passaggio tramite FirebaseService)
- UID dinamico: Esito Positivo (FirebaseAuth.instance.currentUser?.uid)
- Subcollection corretta: Esito Positivo (users/{uid}/portfolio)

### PROSSIMI STEP
- Pagamenti RevenueCat (MP-17)
- iOS build (MP-18)
- Android build (MP-19)
