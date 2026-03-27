> [!NOTE]
> SINTESI: Questo documento funge da "Bussola" del progetto *Portafoglio Aurelius*. Riassume esattamente a che punto siamo, quali sono gli obiettivi immediati e cosa manca al completamento dell'App.

# Stato del Progetto e Roadmap Obiettivi

## 1. Cosa fa oggi il Progetto (Stato dell'Arte)
- **Fondamenta Architetturali Inizializzate**: La codebase Flutter è stata strutturata con un'architettura a strati scalabile e resiliente.
- **Integrazione Premium**: È stato implementato il routing dichiarativo tramite `go_router`, lo state management puro con `Riverpod` e la generazione di codice affidabile tramite `Freezed` / `json_serializable`.
- **Firebase/Cloud Native**: Il progetto è pronto per la logica Multi-tenant (SaaS) con isolamento dati e Firebase Auth/Firestore.
- **Design System Preparato**: Elementi core come `app_theme` e design Glassmorphism/Dark Mode (con `shimmer` per il caricamento) sono stati previsti, in linea con l'aspetto estetico *Altissima Gamma* del manifesto.
- **Obiettivo Principale Appurato**: Permettere agli utenti di ottenere il Net Worth esatto del loro patrimonio distribuito tra Finanza Tradizionale, Immobiliare, Crypto e Luxury.

## 2. Quali sono i vari Obiettivi (Short-term Roadmap)
- [ ] **Data Model & Mock**: Connettere effettivamente le dashboard UI ai modelli Freezed. Stabilizzazione dei dati di prova prima di andare live con le reali letture da db.
- [ ] **Sviluppo UI "Master Dashboard"**: Creazione concreta degli schermi per i vari livelli di abbonamento (Free, Pro, Wealth Elite).
- [ ] **Scanner AI e Parsing OCR**: Strutturare e integrare ai veri motori LLM Vision (Gemini / Vertex AI) il `scanner_service` per la lettura automatica e istantanea di estratti conto in PDF/Immagini.
- [ ] **Sistema Forex Real-Time**: Implementare la logica esatta per convertire asset con valute diverse verso la `targetCurrency` principale del tenant in tempo reale.

## 3. Cosa manca attualmente nello sviluppo
Rappresentando il progetto un ambiente di sviluppo alle battute inziali dopo l'"Hard Reset" di sistema:
- Mancano le implementazioni complete e logiche delle schermate `screens/` (sono solo abbozzate). Nessun widget concreto tranne alcuni placeholder o file mancanti.
- Manca l'effettivo "Motore Pricing" asincrono in background (`price_service.dart` è solo un'interfaccia/concetto).
- Manca il Gate Biometrico (`biometric_gate.dart`) effettivo connesso alle librerie native di iOS/Android.
- Manca il gestore di "Zainetto Fiscale" (il generatore del CSV per le plus/minusvalenze).
- Manca ancora il deployment di configurazioni di base di Firebase Core reali (`google-services.json` o `GoogleService-Info.plist`).
