> [!NOTE]
> SINTESI: Log storico e sequenziale delle scelte architetturali concordate durante lo sviluppo tra l'utente (Gaetano) e l'Agente AI (Aurelius). Utile come track-record per le scelte progettuali future in modo da non ricominciare da capo.

# Log Navigazionale e Storyline del Progetto

1. **Iniziazione del Progetto**: Visione chiara di un aggregatore globale (Finanza Tradizionale, Real Estate, Criptovalute, Auto di Lusso) basato su un tema di altissima gamma "Apple-inspired / Glassmorphism / Dark Mode / Oro antico".
2. **Gestione Stato Pura**: La codebase è cresciuta basandosi totalmente e rigorosamente su `Riverpod`. Nessuna mescolanza con altri state manager standard. 
3. **Il Concetto Universale di `Asset`**: Finzione o realtà, una posizione liquida o fissa viene passata al motore calcolatore tramite un singolo oggetto universale polimorfico. Questo rende l'app ultra-leggera.
4. **Generazioni Moduli Espansione**: 
   - *Modulo Z (Impero)*: Espansione a oro, collezionismo e previdenza illiquida (Deep Liquidity check). 
   - *Modulo I18N (Scalabilità Estera)*: Inserimento multi-valuta con Forex converter istantaneo per il Ricalcolo del Net Worth Globale e testi tradotti in Inglese e Italiano.
   - *Modulo Privacy & Sicurezza*: FaceID al login e Modalità Privacy (Privacy Mode con Blur in-app dei valori con tap sull'icona dell'Occhio).
5. **Crisi della Compilazione Web (Marzo 2026)**: Il tentativo di distribuzione rapida e anteprima web via IDE Cloud (come Zapp.run o FlutLab) ha comportato limitazioni architetturali severissime causate dalla vetustà degli interpreti cloud fermi a Dart 2.19 rispetto ai pacchetti moderni utilizzati in questo progetto d'avanguardia (come Flutter Lints, Riverpod e Firebase Core aggiornati).
6. **Hard Reset / Web Build Nativa**: Dopo svariati tentativi di downgrade forzato per retro-compatibilità col cloud gratuito, si è deciso un **Hard Reset** ai file moderni e incontaminati. La scelta strategica virò definitivamente verso la *Compilazione Locale Dedicata* (su Mac via Terminale) allo scopo di estrarre un pacchetto binario Web purificato e pronto per l'hosting professionale tramite Server Dedicati (come un Plesk IONOS). In questo modo si supera ogni limite pre-impostato via webIDE.
7. **Setup Architettura Premium (Marzo 2026)**: Inserimento delle dipendenze avanzate necessarie per un'app di alto livello. È stato configurato `go_router` associato a Riverpod per la navigazione dichiarativa e sicura. Integrazione di `@freezed` e `json_serializable` per modelli dati immutabili e type-safe (es. `UserProfile`). Aggiunti pacchetti per la UI Premium come `shimmer` (per skeleton loaders eleganti) e `flutter_svg`. Creazione dei primi file architetturali in `lib/core/router/app_router.dart`, `lib/models/user_profile.dart` e `lib/widgets/skeleton_loader.dart`.
8. **Fase Attuale (Inizio Sviluppo Moduli)**: Architettura consolidata. Il focus attuale è lo sviluppo dei Widget UI (`screens/` e `widgets/`), la connessione reale a Firebase Core e l'integrazione del motore LLM (Vision) per lo Scanner Fiscale. L'obiettivo primario è rendere operativo il calcolo in tempo reale del Net Worth.

*Da questo punto in poi l'integrità del codice originario è ripristinata e documentata. Chiunque, o qualsiasi AI lo prenda in carico, possiede le coordinate corrette per il decollo tecnico dell'applicativo.*
