> [!NOTE]
> SINTESI: Questo documento traccia la mappa esatta del Database NoSQL (Firebase Firestore) e delle relative strutture dati lato Dart (Modelli), indispensabile per future espansioni o per far comprendere ad altre IA la struttura dell'informazione del progetto.

# Mappa del Database: Portafoglio Aurelius

## Struttura Dati Principale (Modelli Dart)

### 1. `Asset` (Modello Universale)
Il cuore dell'applicazione. Un `Asset` rappresenta tramite un approccio polimorfico sia posizioni finanziarie, asset illiquidi, sia liquidità.
- `id` (String): Identificativo univoco
- `ticker` (String): Simbolo (es. NVDA) o nome leggibile
- `name` (String): Nome completo dell'asset
- `category` (AssetCategory): Enum `[finance, crypto, realEstate, metal, luxury, pension, cash]`
- `quantity` (double): Quantità in portafoglio
- `entryPrice` (double): Prezzo di carico originario
- `currentPrice` (double): Prezzo attuale di mercato
- `currency` (String): Valuta base dell'asset (EUR, USD, GBP)
- `bank` (String): Custode/Broker/Piattaforma associata (Fineco, Intesa, Revolut)
- `cryptoLocation` (String): Wallet o Exchange (per criptovalute)

### 2. `SubscriptionTier` (Modello Abbonamenti)
Sistema di ruoli SaaS per gating (blocchi logici).
- Enum: `[free, base, pro, wealth]`
- Regola: Il piano `wealth` sblocca la `Master Dashboard`, il piano `pro` lo `Scanner`.

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
