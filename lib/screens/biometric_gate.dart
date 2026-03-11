import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/theme.dart';
import 'dashboard_screen.dart';

class BiometricGate extends StatefulWidget {
  const BiometricGate({super.key});

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate> {
  bool _isAuthenticating = false;

  void _authenticate() async {
    setState(() => _isAuthenticating = true);
    
    // Auth simulata (ritardo di rete/rilevamento hardware)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      setState(() => _isAuthenticating = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Autenticazione automatica disabilitata per mostrare il bottone
    // WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.lock_shield, size: 80, color: AureliusTheme.accentGold),
            const SizedBox(height: 24),
            const Text('Aurelius Vault', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            const Text('Accesso Protetto', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 60),
            if (_isAuthenticating)
              const CircularProgressIndicator(color: AureliusTheme.accentGold)
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AureliusTheme.accentGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(CupertinoIcons.viewfinder),
                label: const Text('Usa FaceID / TouchID', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: _authenticate,
              )
          ],
        ),
      ),
    );
  }
}
