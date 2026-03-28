> [!IMPORTANT]
> REGOLE OPERATIVE PERMANENTI — PORTAFOGLIO AURELIUS
> Questo documento contiene i pilastri operativi che l'AI (Antigravity/Aurelius) deve rispettare nello sviluppo del progetto.

# Regole Operative Permanenti

## REGOLA 1 — CARTELLA DI OUTPUT
Tutti i file prodotti, aggiornati o modificati devono essere salvati ESCLUSIVAMENTE nella cartella:
`/sviluppo GAE/` (o `_sviluppo_gae/` in base alla root attuale).

I file esistenti vanno aggiornati mantenendo il loro numero. I file nuovi vanno numerati in sequenza progressiva rispetto all'ultimo presente nella cartella (es. il progressivo attuale `04_`). Il formato del nome è sempre: `NN_nome_descrittivo.ext`.

## REGOLA 2 — CONFERMA OBBLIGATORIA (CLAUDE / ANALISTA)
Prima di eseguire qualsiasi delle seguenti azioni, l'AI DEVE fermarsi e chiedere conferma esplicita all'analista del progetto (Claude/Gaetano):
- Modificare un file esistente
- Eliminare o sovrascrivere codice esistente
- Aggiungere una nuova dipendenza al `pubspec.yaml`
- Cambiare la struttura di navigazione (router)
- Cambiare un modello dati (`models/`)
- Cambiare il Design System (`theme.dart`)
- Eseguire qualsiasi scelta architetturale non esplicitamente già documentata nei file di progetto

**Il formato della richiesta di conferma è strettamente il seguente:**

> ⚠️ RICHIESTA CONFERMA CLAUDE:
> Sto per [descrizione azione].
> Motivazione: [perché].
> Alternativa: [se esiste].
> Procedo?

L'IA **NON PROCEDE** finché non riceve risposta affermativa.

## REGOLA 3 — INTEGRITÀ DEL PROGETTO
L'app deve rimanere sempre:
- **POTENTE** nei dati e nelle funzionalità
- **SEMPLICE** nell'interfaccia e nell'uso
- **BELLA** nel design (Glassmorphism / Dark / Oro)
- **FUNZIONALE** e intuitiva anche per utenti non esperti di finanza

Qualsiasi feature complessa deve essere presentata all'utente finale in forma semplice. La complessità è sotto il cofano, mai in superficie.
