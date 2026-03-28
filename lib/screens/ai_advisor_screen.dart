import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/subscription_service.dart';
import '../services/ai_aurelius_service.dart';
import '../services/price_service.dart';
import '../widgets/glass_container.dart';

class AiAdvisorScreen extends ConsumerStatefulWidget {
  const AiAdvisorScreen({super.key});

  @override
  ConsumerState<AiAdvisorScreen> createState() => _AiAdvisorScreenState();
}

class _AiAdvisorScreenState extends ConsumerState<AiAdvisorScreen> {
  String _analysisResult = '';
  bool _isLoadingInfo = false;
  bool _isLoadingQuestion = false;
  String _questionResult = '';
  final _questionController = TextEditingController();

  Future<void> _analyzePortfolio() async {
    setState(() { _isLoadingInfo = true; _analysisResult = ''; });
    final assets = ref.read(portfolioProvider).value ?? [];
    final res = await ref.read(aiAureliusServiceProvider).analyzePortfolio(assets);
    if (mounted) {
      setState(() {
        _isLoadingInfo = false;
        _analysisResult = res;
      });
    }
  }

  Future<void> _askQuestion() async {
    final q = _questionController.text.trim();
    if (q.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Inserisci una domanda")));
      return;
    }
    setState(() { _isLoadingQuestion = true; _questionResult = ''; });
    final assets = ref.read(portfolioProvider).value ?? [];
    final res = await ref.read(aiAureliusServiceProvider).getSimpleAdvice(q, assets);
    if (mounted) {
      setState(() {
        _isLoadingQuestion = false;
        _questionResult = res;
        _questionController.clear();
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subTier = ref.watch(subscriptionProvider);
    
    // GATING TIER BASE
    if (subTier == SubscriptionTier.base) {
      return Scaffold(
        backgroundColor: AureliusTheme.backgroundBlack,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, size: 80, color: AureliusTheme.accentGold),
                const SizedBox(height: 24),
                Text("Funzione Pro & Wealth Exclusive", style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text("Questa vista è disponibile\nper i piani superiori.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AureliusTheme.accentGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => context.push('/subscription'),
                    child: Text("Scopri i Piani Premium", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        title: Text("AI Advisor", style: GoogleFonts.inter(color: AureliusTheme.accentGold, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CARD 1: Analisi Generale
            GlassContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ANALISI DEL PORTAFOGLIO", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (_analysisResult.isEmpty && !_isLoadingInfo)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: _analyzePortfolio,
                        child: Text("Analizza il mio portafoglio", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    )
                  else if (_isLoadingInfo)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(color: AureliusTheme.accentGold),
                            const SizedBox(height: 16),
                            Text("Aurelius sta analizzando...", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_analysisResult, style: GoogleFonts.inter(fontSize: 14, color: Colors.white, height: 1.5)),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: AureliusTheme.accentGold), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          onPressed: _analyzePortfolio,
                          child: Text("Rianalizza", style: GoogleFonts.inter(color: AureliusTheme.accentGold)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // CARD 2: Domanda Libera
            GlassContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("FAI UNA DOMANDA", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _questionController,
                    maxLines: 3,
                    style: GoogleFonts.inter(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "es. Sono troppo esposto alle crypto?",
                      hintStyle: GoogleFonts.inter(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.black26,
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFF8E8E93).withOpacity(0.3))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AureliusTheme.accentGold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: _isLoadingQuestion ? null : _askQuestion,
                      child: _isLoadingQuestion 
                         ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                         : Text("Chiedi ad Aurelius", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                  if (_questionResult.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                      child: Text(_questionResult, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, height: 1.4)),
                    )
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
