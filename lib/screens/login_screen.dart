import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/glass_container.dart';
import '../core/theme.dart';
import '../widgets/aurelius_snackbar.dart';
import '../services/price_service.dart';
import '../services/firebase_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await ref.read(authServiceProvider).signIn(email: email, password: password);
      } else {
        await ref.read(authServiceProvider).signUp(email: email, password: password);
      }

      final profile = await ref.read(firebaseServiceProvider).getUserProfile();
      if (profile != null) {
        if (profile['targetCurrency'] != null) {
          ref.read(targetCurrencyProvider.notifier).state = profile['targetCurrency'];
        }
        if (profile['savingsGoal'] != null) {
          ref.read(savingsGoalProvider.notifier).state = profile['savingsGoal'].toDouble();
        }
        if (profile['privacyMode'] != null) {
          ref.read(privacyModeProvider.notifier).state = profile['privacyMode'];
        }
      }

      if (mounted) context.go(_isLogin ? '/dashboard' : '/onboarding');
    } catch (e) {
      if (mounted) {
        AureliusSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.account_balance_wallet_rounded, size: 56, color: AureliusTheme.accentGold),
              const SizedBox(height: 16),
              Text("Portafoglio Aurelius", style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text("Il tuo patrimonio. Sempre con te.", style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93)), textAlign: TextAlign.center),
              const SizedBox(height: 48),
              GlassContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF8E8E93)),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF8E8E93))),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AureliusTheme.accentGold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF8E8E93)),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF8E8E93))),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AureliusTheme.accentGold)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF8E8E93)),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                          : Text(_isLogin ? "Accedi" : "Registrati", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin ? "Non hai un account? Registrati" : "Hai già un account? Accedi", style: GoogleFonts.inter(color: AureliusTheme.accentGold)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: Text("Continua senza account →", style: GoogleFonts.inter(color: const Color(0xFF8E8E93))),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
