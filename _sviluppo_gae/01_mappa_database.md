> [!NOTE]
> SINTESI: Questo documento traccia la mappa esatta del Database NoSQL (Firebase Firestore) e delle relative strutture dati lato Dart (Modelli), indispensabile per future espansioni o per far comprendere ad altre IA la struttura dell'informazione del progetto.

# Mappa del Database: Portafoglio Aurelius

## Struttura Dati Principale (Modelli Dart)

### 1. `Asset` (Modello Universale)
Il cuore dell'applicazione. Un `Asset` rappresenta tramite un approccio polimorfico sia posizioni finanziarie, asset illiquidi, sia liquidità.
- `id` (String?): Identificativo univoco univoco
- `ticker` (String): Simbolo (es. NVDA) o nome leggibile
- `name` (String): Nome completo dell'asset
- `category` (AssetCategory): Enum `[finance, crypto, realEstate, luxury, cash, metal, previdenza]`
- `quantity` (double): Quantità in portafoglio
- `entryPrice` (double): Prezzo di carico originario
- `currentPrice` (double): Prezzo attuale di mercato
- `currency` (String): Valuta base dell'asset (default 'EUR')
- `bank` (String): Custode/Broker/Piattaforma associata
- `cryptoLocation` (String?): Wallet o Exchange (per criptovalute)
- `remainingMortgage` (double?): Mutuo residuo (per Real Estate)
- `monthlyRent` (double?): Affitto mensile (per Real Estate)
- `expirationDate` (DateTime?): Scadenza vincolo (per Previdenza/Cash)
- `description` (String?): Note libere associate

### 2. `SubscriptionTier` (Modello Abbonamenti)
Sistema di ruoli SaaS per gating (blocchi logici).
- Enum: `[free, base, pro, wealth]`
- Regola: Il piano `wealth` sblocca la `Master Dashboard`, Family office e reportistica Tax. Il piano `pro` sblocca lo `Scanner` screenshot e l'`Ai Advisor`. Il piano `base/free` limita gli asset o integra manual tracking.

## STATO FIRESTORE ATTUALE
- Progetto: portafoglio-aurelius
- Region: eur3 (Europe-west)
- Modalità: Production
- Regole sicurezza: ATTIVE (`auth.uid == userId`)

## COLLECTIONS ATTIVE
```
users/{userId}/
  ├── portfolio/{assetId}
  └── historical_sales/{saleId}
```

## AUTH
- Provider: Email/Password
- Stato: ATTIVO
- UID dinamico: sì

## Albero di Connessioni (Firestore - Lato Database)

Il database è strutturato per l'utilizzo multi-tenant (SaaS):
```
/users (Collection)
 └── {userId} (Document)
     ├── profile (Map: nome, email, subscription_tier)
     ├── settings (Map: targetCurrency, isPrivacyMode)
     └── /portfolio (Subcollection)
         ├── {assetId1} -> { ...dati Asset... }
         ├── {assetId2} -> { ...dati Asset... }
         └── {assetId3} -> { ...dati Asset... }
```

### Regole Logiche Aggiuntive
- **Conversioni Forex**: Se un Asset in portafoglio ha `currency == 'USD'` e la `targetCurrency` utente è 'EUR', il suo valore nel ricalcolo del Net Worth totale viene convertito a run-time.
- **Zainetto Fiscale**: Viene generato sommando dinamicamente il delta (`currentPrice` - `entryPrice`) di ogni posizione investita. 
- **Motore Offline-First**: Oltre alla sincronizzazione Cloud con Firestore, i dati del portafoglio sono cacheati in locale per l'accesso immediato anche in assenza di rete (es. utente in volo o restrizioni privacy massime).
