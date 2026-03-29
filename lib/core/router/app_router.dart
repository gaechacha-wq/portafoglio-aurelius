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
import '../../screens/login_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/tax_screen.dart';
import '../../screens/help_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/scenario_screen.dart';

import '../../services/subscription_service.dart';
import '../../services/auth_service.dart';

/// Provider per il router dell'app.
final routerProvider = Provider<GoRouter>((ref) {
  
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
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
        path: '/tax',
        name: 'tax',
        builder: (context, state) => const TaxScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/scenario',
        name: 'scenario',
        builder: (context, state) => const ScenarioScreen(),
      ),
    ],
    redirect: (context, state) {
      final currentPath = state.uri.path;
      final authState = ref.watch(authStateProvider);
      
      final isAuth = authState.valueOrNull != null;
      final isLoggingIn = currentPath == '/login';

      if (!isAuth && currentPath == '/dashboard') {
        return '/login';
      }
      
      if (isAuth && isLoggingIn) {
        return '/dashboard';
      }
      
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
