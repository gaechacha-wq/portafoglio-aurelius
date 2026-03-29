# LOG CICLO AURELIUS-MP-18-THEME
## Data: 29 Marzo 2026

### OBIETTIVO
Adattamento automatico dark/light mode basato sul tema del sistema operativo. Toggle manuale in Settings.

### FILE MODIFICATI
- lib/core/theme.dart
  (aggiunto lightTheme)
- lib/main.dart
  (ThemeMode.system)
- lib/widgets/glass_container.dart
  (adattivo al tema)
- lib/widgets/asset_card.dart
  (colori tema-aware)
- lib/screens/settings_screen.dart
  (toggle tema manuale)
- lib/services/price_service.dart
  (themeModeProvider)

### PALETTE LIGHT MODE
- Background: #F5F0E8 (crema calda)
- Card: #FFFFFF
- Border: #E8DFC0 (oro tenue)
- Testo primario: #1A1A1A
- Testo secondario: #666666
- Accent oro: #D4AF37 (invariato)

### COMPORTAMENTO
- Di giorno: tema chiaro automatico
- Di notte: tema scuro automatico
- Override manuale in Impostazioni
