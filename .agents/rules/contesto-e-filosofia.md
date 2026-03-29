---
trigger: always_on
---

[AURELIUS-RULE-0001] — CONTESTO E FILOSOFIA

Stai lavorando su PORTAFOGLIO AURELIUS
— app Flutter SaaS premium per la
gestione del patrimonio personale
rivolta a HNWI italiani.

URL produzione:
https://portafoglio-aurelius.web.app

FILOSOFIA DEL PRODOTTO:
"La complessità è sotto il cofano.
Mai in superficie."

L'app deve essere sempre:
— POTENTE nei dati e nei calcoli
— SEMPLICE nell'interfaccia
— BELLA nel design premium
— FUNZIONALE per tutti gli utenti
  dai 25 ai 70 anni

CHI SONO GLI UTENTI:

Utente 1 — Il Millennial Curioso
25-35 anni, €10k-€100k patrimonio.
Ha soglia attenzione breve.
Se non capisce in 3 secondi abbandona.
NON sa cosa sono le plusvalenze.

Utente 2 — Il Professionista
35-55 anni, €100k-€2M patrimonio.
Vuole report automatici.
Stanco di aggiornare Excel.
Disposto a pagare per risparmiare tempo.

Utente 3 — L'HNWI Esigente
45-70 anni, €2M+ patrimonio.
Si aspetta private banking digitale.
Sicurezza dati è priorità assoluta.
Vuole eleganza e discrezione.

PRINCIPI DI DESIGN INVIOLABILI:

1. Una cosa alla volta per schermata
2. Zero gergo tecnico senza spiegazione
   NON scrivere "plusvalenze fiscali"
   SCRIVI "quanto hai guadagnato"
3. Feedback visivo sempre presente
   Loading → skeleton oro
   Successo → snackbar verde
   Errore → snackbar rossa + soluzione
4. Max 3 tap per qualsiasi azione
5. Errori amichevoli con via d'uscita
6. Testo minimo 13px ovunque
7. Sempre ▲▼ per gain/loss
   non solo colore verde/rosso
8. Privacy Mode su ogni valore numerico
9. Dark/Light mode su ogni schermata

STACK TECNICO CONFERMATO:
— Flutter 3.19.6 + Dart 3.3.4
— Riverpod 2.6.1 PURO (no mix)
— go_router 13.2.5
— Firebase Firestore (eur3)
— Firebase Auth (Email/Password)
— Firebase Hosting
— Gemini 1.5 Flash (AI + Vision)
— google_generative_ai 0.4.7
— flutter_dotenv 5.2.1
— fl_chart 0.66.2

DESIGN TOKENS CONFERMATI:
— Background: #000000
— Card Surface: #1C1C1E
— Accent Oro: #D4AF37
— Testo primario: #FFFFFF
— Testo secondario: #8E8E93
— Gain verde: #4CAF50
— Loss rosso: #F44336
— Crypto cyan: #00E5FF
— Light bg: #F5F0E8
— Light card: #FFFFFF

FILE CRITICI — MAI MODIFICARE
SENZA CONFERMA ESPLICITA DI CLAUDE:
— lib/core/theme.dart
— lib/core/router/app_router.dart
— lib/models/asset_model.dart
— lib/services/price_service.dart
— pubspec.yaml

FORMATO CONFERMA OBBLIGATORIO:
⚠️ RICHIESTA CONFERMA CLAUDE [CODICE]:
Sto per: [azione esatta]
File coinvolto: [path completo]
Motivazione: [perché è necessario]
Alternativa: [opzione B se esiste]
Procedo?

OUTPUT DOCUMENTAZIONE:
Tutti i file prodotti vanno in:
_sviluppo_gae/
Con numerazione progressiva:
NN_nome_descrittivo.md

CHECKLIST PRE-DEPLOY OBBLIGATORIA:
□ Ogni schermata ha UN dato principale?
□ Zero termini tecnici senza spiegazione?
□ Ogni azione ha feedback visivo?
□ Ogni errore ha messaggio amichevole?
□ Max 3 tap per azioni principali?
□ Testo minimo 13px ovunque?
□ ▲▼ presenti per tutti i gain/loss?
□ Privacy Mode su ogni valore?
□ Dark e Light mode funzionanti?
□ Flutter analyze: zero warning?

Se anche uno solo non è soddisfatto:
NON si deploya.