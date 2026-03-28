# Design Tokens — Portafoglio Aurelius

Questo documento sintetizza i *Design Tokens* estrapolati dalla codebase attuale (prevalentemente da `theme.dart`, `glass_container.dart` e `neon_glass_container.dart`).

## COLORI (Hex Esatti)
- **Background principale**: `#000000`
- **Surface / Card background**: `#1C1C1E`
- **Accent oro** (Signature): `#D4AF37`
- **Testo primario**: `#FFFFFF`
- **Testo secondario / hint**: `#8E8E93`
- **Colore positivo (gain/verde)**: `[DA DEFINIRE]`
- **Colore negativo (loss/rosso)**: `[DA DEFINIRE]`
- **Colore crypto (neon accent)**: `[DA DEFINIRE]` *(N.B. In `neon_glass_container.dart` la variabile `glowColor` è passata dinamicamente senza un token di default stabilito)*
- **Bordi glass**: `#FFFFFF` con opacità `10%` (`0.1`) per contenitori normali, opacità variabile `40%` (`0.4`) per i bordi neon.

## TIPOGRAFIA
- **Font family principale**: `Inter` (tramite `GoogleFonts.inter`)
- **Pesi usati**:
  - `Bold` (w700 - per titolazioni display)
  - `SemiBold` (w600 - per titoli standard)
  - `Regular` (w400 - body copy descrittivo)
- **Dimensioni testo**:
  - **h1** (`displayLarge`): `32`
  - **h2** (`titleLarge`): `22`
  - **body** (`bodyLarge`): `16`
  - **caption / label** (`bodyMedium`): `14`

## GLASSMORPHISM
- **Valore sigma blur** (BackdropFilter):
  - Standard container: `sigmaX: 10.0, sigmaY: 10.0`
  - Neon container: `sigmaX: 12.0, sigmaY: 12.0`
- **Opacità background delle card glass**: 
  - Base: `5%` (`Colors.white.withOpacity(0.05)`)
  - Neon (Accent level): `6%` (`Colors.white.withOpacity(0.06)`)
- **Border width e opacità bordo**:
  - Width: `1.5`
  - Opacità: `10%` per Base (`0.1`), `40%` per Neon (`0.4`)
- **Border radius standard delle card**: `20.0`
- **Box Shadow Blur Radius:** `10.0` (Base) - `20.0` (Neon esterno)

## SPACING & LAYOUT
- **Padding interno standard delle card**: `16.0` (all)
- **Margine laterale pagina**: `[DA DEFINIRE]`
- **Gap verticale tra sezioni**: `[DA DEFINIRE]`
- **Altezza bottom navigation bar**: `[DA DEFINIRE]`

## ANIMAZIONI
- **Durata transizioni di navigazione (ms)**: `[DA DEFINIRE]`
- **Durata animazioni valori (es. counter)**: `[DA DEFINIRE]`
- **Curva di animazione preferita**: `[DA DEFINIRE]`
