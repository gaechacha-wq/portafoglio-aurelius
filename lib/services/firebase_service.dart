import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'scanner_service.dart';
import 'price_service.dart';
import '../models/asset_model.dart';
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Usa l'ID utente reale una volta implementata l'autenticazione. 
  // Attualmente simula un utente SaaS isolato.
  String get _currentUserId {
    // return FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_saas_user';
    return 'premium_user_001';
  }

  /// Configura la persistenza offline in modo che l'utente veda l'ultimo portfolio anche
  /// in aereo e possa apportare modifiche in queue per la riconnessione.
  Future<void> enableOfflinePersistence() async {
    try {
       // La cache su iOS e Android è abilitata di default, ma può essere forzata a una certa size.
       _db.settings = const Settings(
         persistenceEnabled: true,
         cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
       );
    } catch (e) {
      // Ignora l'errore se Firebase non è configurato localmente
    }
  }

  /// Ottiene il riferimento alla collezione del portafoglio dell'utente corrente (SaaS Ready)
  CollectionReference get _userPortfolioRef {
    return _db.collection('users').doc(_currentUserId).collection('portfolio');
  }

  /// Ottiene il riferimento allo storico chiusure
  CollectionReference get _userHistoricalSalesRef {
     return _db.collection('users').doc(_currentUserId).collection('historical_sales');
  }


  /// Salvataggio Universale Multi-Asset
  Future<void> saveAsset(Asset asset) async {
    try {
      await _userPortfolioRef.doc(asset.id.isNotEmpty ? asset.id : null).set(
        asset.toMap()..addAll({'timestamp': FieldValue.serverTimestamp()}),
        SetOptions(merge: true),
      );
    } catch (e) {
      // Catch in offline fallback, Firestore accoderà localmente
    }
  }

  /// Registra la "Chiusura" di una posizione. (Elimina dal portafoglio e salva nello storico per il modulo Post-Vendita)
  Future<void> chiudiPosizione(Asset asset, double sellPrice) async {
    try {
      final batch = _db.batch();
      
      // 1. Salva nello Storico Vendite
      final newHistoryDoc = _userHistoricalSalesRef.doc();
      batch.set(newHistoryDoc, {
        'ticker': asset.ticker,
        'name': asset.name,
        'quantity': asset.quantity,
        'entryPriceAtSale': asset.entryPrice,
        'exitPrice': sellPrice,
        'bank': asset.bank,
        'category': asset.category.name,
        'sellDate': FieldValue.serverTimestamp(),
      });

      // 2. Elimina dal portafoglio attivo
      if (asset.id.isNotEmpty) {
        batch.delete(_userPortfolioRef.doc(asset.id));
      }

      await batch.commit();

    } catch (e) {
      // Fallback
    }
  }

  /// Wrapper per il mock dello Scanner (Salva azioni/crypto importati)
  Future<void> saveScannedAsset(ScannedAsset asset, String assignedBank) async {
    try {
      // Identifica il tipo basato sul ticker
      AssetCategory cat = AssetCategory.finanza;
      if (['BTC', 'ETH', 'SOL', 'ADA', 'XRP'].contains(asset.ticker.toUpperCase())) {
         cat = AssetCategory.crypto;
      }

      final newAsset = Asset(
        id: _userPortfolioRef.doc().id, // Pre-genera l'id Firestore
        ticker: asset.ticker,
        name: asset.name,
        quantity: asset.quantity,
        entryPrice: asset.averageLoadPrice,
        currentPrice: asset.averageLoadPrice, 
        bank: assignedBank,
        category: cat,
      );

      await saveAsset(newAsset);
    } catch (e) {
      // Ignora l'errore per continuità UX offline
    }
  }
}
