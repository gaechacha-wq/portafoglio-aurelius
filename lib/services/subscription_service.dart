import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SubscriptionTier { base, pro, wealth }

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionTier>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionTier> {
  // Parti col piano base per simulare il blocco iniziale.
  SubscriptionNotifier() : super(SubscriptionTier.base);

  void upgradeTo(SubscriptionTier newTier) {
    state = newTier;
  }
}

// Estensione helper per check controllati
extension SubscriptionAccess on SubscriptionTier {
  bool get canAccessMasterWealth => this == SubscriptionTier.wealth;
  bool get canAccessCrypto => this == SubscriptionTier.pro || this == SubscriptionTier.wealth;
  bool get canAccessScanner => this == SubscriptionTier.pro || this == SubscriptionTier.wealth;
  bool get canExportPdf => this == SubscriptionTier.wealth;
}
