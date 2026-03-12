import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modifica questi import base nel tuo progetto
import '../../screens/dashboard_screen.dart';
import '../../screens/biometric_gate.dart';

/// Provider per il router dell'app. Permette dependency injection e 
/// reactive redirect in base allo stato dell'autenticazione.
final routerProvider = Provider<GoRouter>((ref) {
  
  // Esempio: ascoltare uno stato di auth per redirect
  // final authState = ref.watch(authProvider);

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
    ],
    // redirect: (context, state) {
    //   // Logica per proteggere le route qui
    // },
  );
});
