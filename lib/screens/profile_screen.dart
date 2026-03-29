import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/theme.dart';
import '../services/auth_service.dart';
import '../services/price_service.dart';
import '../services/subscription_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/aurelius_snackbar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final subTier = ref.watch(subscriptionProvider);
    final portfolioAsync = ref.watch(portfolioProvider);
    final netWorth = ref.watch(masterNetWorthProvider);
    final globalPerformance = ref.watch(totalFilteredPerformanceProvider);
    
    final int assetCount = portfolioAsync.valueOrNull?.length ?? 0;
    
    String subName = "Base";
    Color subColor = Colors.grey;
    if (subTier == SubscriptionTier.pro) {
      subName = "Pro";
      subColor = AureliusTheme.accentGold;
    } else if (subTier == SubscriptionTier.wealth) {
      subName = "Wealth";
      subColor = AureliusTheme.accentGold;
    }

    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        title: Text("Il mio Profilo", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AureliusTheme.accentGold),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // SEZIONE AVATAR
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: AureliusTheme.accentGold,
              child: Text(
                (user?.email != null && user!.email!.isNotEmpty)
                    ? user.email!.substring(0, 1).toUpperCase()
                    : "U",
                style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            if (user?.displayName != null && user!.displayName!.isNotEmpty)
              Text(user.displayName!, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(user?.email ?? "Utente Ospite", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            Text("Piano attuale $subName", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
            const SizedBox(height: 32),

            // SEZIONE STATISTICHE
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatMetric("N. Asset", assetCount.toString()),
                  Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                  _buildStatMetric("Net Worth", "€${(netWorth/1000).toStringAsFixed(1)}k"),
                  Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                  _buildStatMetric("Performance", "${globalPerformance > 0 ? '+' : ''}${globalPerformance.toStringAsFixed(1)}%", 
                      color: globalPerformance >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SEZIONE ABBONAMENTO
            GlassContainer(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ABBONAMENTO", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF8E8E93))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: subColor.withOpacity(0.2),
                          border: Border.all(color: subColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(subName, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: subColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Rinnovo: Gestito manualmente", style: GoogleFonts.inter(color: Colors.white)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AureliusTheme.accentGold,
                        side: const BorderSide(color: AureliusTheme.accentGold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => context.go('/subscription'),
                      child: Text("Cambia Piano", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SEZIONE ACCOUNT
            GlassContainer(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ACCOUNT", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF8E8E93))),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Modifica email", style: GoogleFonts.inter(color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF8E8E93)),
                    onTap: () {
                      final ctrl = TextEditingController();
                      showDialog(context: context, builder: (ctx) => AlertDialog(
                        backgroundColor: AureliusTheme.cardDark,
                        title: Text("Nuova Email", style: GoogleFonts.inter(color: Colors.white)),
                        content: TextField(
                          controller: ctrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(hintText: "nome@email.com", hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annulla")),
                          TextButton(onPressed: () async {
                            try {
                              await user?.verifyBeforeUpdateEmail(ctrl.text);
                              Navigator.pop(ctx);
                              if(context.mounted) {
                                AureliusSnackBar.showSuccess(context, "Email aggiornata");
                              }
                            } catch(e) {
                              if(context.mounted) {
                                AureliusSnackBar.showError(context, "Errore: $e");
                              }
                            }
                          }, child: const Text("Salva")),
                        ],
                      ));
                    },
                  ),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Cambia password", style: GoogleFonts.inter(color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF8E8E93)),
                    onTap: () async {
                      if (user?.email != null) {
                        try {
                          await ref.read(authServiceProvider).resetPassword(user!.email!);
                          if(context.mounted) {
                            AureliusSnackBar.showSuccess(context, "Email di reset inviata");
                          }
                        } catch(e) {
                          if(context.mounted) {
                            AureliusSnackBar.showError(context, "Errore: $e");
                          }
                        }
                      }
                    },
                  ),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Elimina account", style: GoogleFonts.inter(color: const Color(0xFFF44336))),
                    onTap: () {
                      showDialog(context: context, builder: (ctx) => AlertDialog(
                        backgroundColor: AureliusTheme.cardDark,
                        title: Text("Elimina Account", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                        content: Text("Questa azione è irreversibile. Tutti i tuoi dati verranno eliminati.", style: GoogleFonts.inter(color: const Color(0xFF8E8E93))),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Annulla", style: GoogleFonts.inter(color: Colors.grey))),
                          TextButton(onPressed: () {
                            Navigator.pop(ctx);
                            // Placeholder
                          }, child: Text("Conferma", style: GoogleFonts.inter(color: const Color(0xFFF44336), fontWeight: FontWeight.bold))),
                        ],
                      ));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF44336),
                  side: const BorderSide(color: Color(0xFFF44336)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await ref.read(authServiceProvider).signOut();
                  if (context.mounted) context.go('/login');
                },
                child: Text("Esci dall'account", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatMetric(String label, String value, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8E8E93))),
      ],
    );
  }
}
