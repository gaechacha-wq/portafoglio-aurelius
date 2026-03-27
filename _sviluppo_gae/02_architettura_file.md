> [!NOTE]
> SINTESI: Questo documento mappa l'architettura dei file e delle cartelle all'interno del progetto Flutter `Portafoglio Aurelius`. Serve come navigatore strutturale.

# Architettura del Codice: Portafoglio Aurelius

Il progetto utilizza l'architettura a Livelli (Layered Architecture) implementata nativamente con Flutter Riverpod per la gestione dello Stato.

## Struttura Cartella `lib/`

1. **`core/`**
   - Contiene file essenziali di configurazione e routing.
   - `theme.dart`: Il "Design System" Glassmorphism (colori, dark theme, font Apple iOS).
   - `router/app_router.dart`: Navigazione dichiarativa sicura gestita tramite `go_router` integrato in Riverpod.
2. **`models/`**
   - Strutture Dati della Business Logic.
   - `asset_model.dart`, `subscription_model.dart` etc.

3. **`services/`**
   - I "Motori" dell'applicazione (Nessuna UI qui).
   - `firebase_service.dart`: Interfaccia comunicazioni server/cloud.
   - `price_service.dart`: Sistema asincrono (Stream) fittizio/reale per aggiornamento ticker ogni tot secondi.
   - `scanner_service.dart`: Interfaccia verso OCR / AI Gemini (Vision LLM) per parsing automatico di estratti conto / screenshot bancari.
   - `subscription_service.dart`: Gestione stato abbonamenti (Riverpod `Notifier`).
   - `tax_export_service.dart`: (Pianificato) Generatore asincrono del report fiscale CSV "Zainetto Fiscale".

4. **`screens/`**
   - Le viste principali (Pagine intere).
   - `dashboard_screen.dart`: Visualizzazione filtrata per Banca. Dashboard Finanziaria principale.
   - `master_dashboard_screen.dart`: Esclusiva per livelli Wealth Hierarchy. Visione patrimoniale d'insieme con Pie Charts.
   - `ai_advisor_screen.dart`: Intelligenza Artificiale basata su report storici / Big 5.
   - `scanner_screen.dart`: Vista caricamento OCR e feedback intelligenza visiva.
   - `biometric_gate.dart`: FaceID / TouchID simulati all'avvio.
   - `help_screen.dart`: Manuale di istruzioni interattivo integrato per l'onboarding.
   - `subscription_screen.dart`: Paywall form per i piani (Base, Pro, Wealth).

5. **`widgets/`**
   - Componenti UI riutilizzabili.
   - `glass_container.dart`: L'effetto visivo centrale (blur, bordi light).
   - `neon_glass_container.dart`: Variante illuminata per le Criptovalute.

6. **`l10n/`**
   - **(Cartella Esterna Root)** File `.arb` (`app_it.arb`, `app_en.arb`) per la traduzione i18n multilingua dell'interfaccia.
