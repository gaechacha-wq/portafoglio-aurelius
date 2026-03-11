import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/biometric_gate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Inizializzare Firebase qui
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: PortfolioAureliusApp(),
    ),
  );
}

class PortfolioAureliusApp extends StatelessWidget {
  const PortfolioAureliusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Aurelius',
      debugShowCheckedModeBanner: false,
      theme: AureliusTheme.darkTheme,

      home: const BiometricGate(),
    );
  }
}
