import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/biometric_gate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', ''),
        Locale('en', ''),
      ],
      home: const BiometricGate(),
    );
  }
}
