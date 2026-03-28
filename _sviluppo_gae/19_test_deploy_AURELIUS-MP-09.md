# 19 — TEST DEPLOY
## Data: 28 Marzo 2026
## Codice: AURELIUS-MP-09-TEST

### RISULTATI TEST

| Test | Risultato | Note |
|------|-----------|------|
| URL online raggiungibile | ✅ | HTTP status 200 |
| Localhost attivo | ✅ | HTTP status 200 (Python istance port 8080) |
| File build presenti | ✅ | presenti: `index.html`, `main.dart.js`, `manifest.json`, `flutter.js`, `assets/` |
| main.dart.js presente | ✅ | Dimensione: ~3.17 MB |
| Firebase deploy OK | ✅ | Progetto `portafoglio-aurelius` pingato su canali hosting live |
| Chrome aperto | ✅ | URL `https://portafoglio-aurelius.web.app` e `localhost:8080` aperti nativamente via shell `open` |

### URL ATTIVI
- Pubblico: https://portafoglio-aurelius.web.app
- Locale: http://localhost:8080

### PROSSIMI STEP
- Attivare Firebase Auth per login reali
- Attivare Firestore per dati persistenti
- Testare AI Advisor con chiave Gemini reale
- Testare Scanner OCR con immagine reale
