# LOG CICLO AURELIUS-MP-15
## Data: 29 Marzo 2026

### FILE CREATI
- `lib/services/monte_carlo_service.dart`
- `lib/screens/scenario_screen.dart`
- `lib/widgets/geographical_risk_widget.dart`

### FILE MODIFICATI
- `lib/screens/master_dashboard_screen.dart`
- `lib/screens/dashboard_screen.dart`
- `lib/core/router/app_router.dart`

### FEATURE AGGIUNTE
- Simulazione Monte Carlo (500/1000/5000/10000 scenari)
- Scenario Planner con orizzonte 1-30 anni
- Grafico distribuzione probabilità
- Insight testuali automatici
- Geographical Risk Mapping
- Pulsante Scenario Planner in Master Dashboard

### ALGORITMO MONTE CARLO
- Modello: Geometric Brownian Motion
- Volatilità per categoria asset
- Rendimento atteso per categoria
- Box-Muller per distribuzione normale

### PROSSIMI STEP
- Salt Edge connettività bancaria
- iOS build nativa
- Android build nativa
