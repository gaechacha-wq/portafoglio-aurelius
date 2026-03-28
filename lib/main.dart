import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Inizializzare Firebase qui
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: PortfolioAureliusApp(),
    ),
  );
}

class PortfolioAureliusApp extends ConsumerWidget {
  const PortfolioAureliusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Osserva il routerProvider creato
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
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
      routerConfig: router,
    );
  }
}
