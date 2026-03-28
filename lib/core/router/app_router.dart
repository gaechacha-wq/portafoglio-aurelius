import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/dashboard_screen.dart';
import '../../screens/biometric_gate.dart';
import '../../screens/master_dashboard_screen.dart';
import '../../screens/add_asset_screen.dart';
import '../../screens/subscription_screen.dart';
import '../../screens/ai_advisor_screen.dart';
import '../../screens/scanner_screen.dart';
import '../../screens/settings_screen.dart';

import '../../services/subscription_service.dart';

/// Provider per il router dell'app.
final routerProvider = Provider<GoRouter>((ref) {
  
  return GoRouter(
    initialLocation: '/gate',
    routes: [
      GoRoute(
        path: '/gate',
        name: 'biometric_gate',
        builder: (context, state) => const BiometricGate(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/master',
        name: 'master',
        builder: (context, state) => const MasterDashboardScreen(),
      ),
      GoRoute(
        path: '/advisor',
        name: 'advisor',
        builder: (context, state) => const AiAdvisorScreen(),
      ),
      GoRoute(
        path: '/scanner',
        name: 'scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/add-asset',
        name: 'add_asset',
        builder: (context, state) => const AddAssetScreen(),
      ),
      GoRoute(
        path: '/subscription',
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      final currentPath = state.uri.path;
      
      // Subscription gate per la Master Dashboard
      if (currentPath == '/master') {
        final subTier = ref.read(subscriptionProvider);
        if (!subTier.canAccessMasterWealth) {
          // Usa il parametro aggiuntivo querystring
          return '/subscription?from=master';
        }
      }
      return null;
    },
  );
});
