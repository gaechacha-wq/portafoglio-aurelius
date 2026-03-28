import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme.dart';
import '../models/asset_model.dart';
import '../services/subscription_service.dart';
import '../services/scanner_service.dart';
import '../services/firebase_service.dart';
import '../widgets/glass_container.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  Uint8List? _selectedImageBytes;
  bool _isProcessing = false;
  List<ScannedAsset> _results = [];
  bool _hasAnalyzed = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      final bytes = await xfile.readAsBytes();
      if (mounted) {
        setState(() {
          _selectedImageBytes = bytes;
          _results = [];
          _hasAnalyzed = false;
        });
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImageBytes == null) return;
    setState(() {
      _isProcessing = true;
      _results = [];
      _hasAnalyzed = false;
    });

    try {
      final assets = await ref.read(scannerServiceProvider).processImage(_selectedImageBytes!);
      if (mounted) {
        setState(() {
          _results = assets;
          _hasAnalyzed = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _importAssets() async {
    final fbServe = ref.read(firebaseServiceProvider);
    for (var sa in _results) {
      final newAsset = Asset(
        id: DateTime.now().millisecondsSinceEpoch.toString() + sa.ticker,
        name: sa.name.isEmpty ? sa.ticker : sa.name,
        ticker: sa.ticker,
        category: AssetCategory.finanza,
        quantity: sa.quantity,
        entryPrice: sa.averageLoadPrice,
        currentPrice: sa.averageLoadPrice,
        currency: 'EUR',
        bank: 'Importato da Scanner',
      );
      // Usiamo saveAsset nativo di F1 bypassando la firma "saveScannedAsset" inesistente
      await fbServe.saveAsset(newAsset);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Importati con successo!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green)
      );
      context.go('/dashboard');
    }
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
        title: Text("Scanner", style: GoogleFonts.inter(color: AureliusTheme.accentGold, fontWeight: FontWeight.bold)),
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
            GlassContainer(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("IMPORTA ESTRATTO CONTO", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E8E93), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text("Fotografa o carica un estratto conto, un documento di broker o una lista di investimenti. L'AI estrarrà automaticamente i tuoi asset.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                  const SizedBox(height: 24),
                  if (_selectedImageBytes == null)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: _pickImage,
                        child: Text("Scegli Immagine", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    )
                  else
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.memory(_selectedImageBytes!, height: 200, width: double.infinity, fit: BoxFit.cover),
                              if (_isProcessing)
                                Container(
                                  height: 200,
                                  color: Colors.black54,
                                  child: const Center(child: CircularProgressIndicator(color: AureliusTheme.accentGold)),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            onPressed: _isProcessing ? null : _analyzeImage,
                            child: Text("Analizza con AI", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: AureliusTheme.accentGold), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            onPressed: _isProcessing ? null : _pickImage,
                            child: Text("Cambia immagine", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: AureliusTheme.accentGold)),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            
            if (_isProcessing || _results.isNotEmpty || _hasAnalyzed) ...[
              const SizedBox(height: 16),
              GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: _isProcessing 
                  ? Center(child: Column(children: [
                      const CircularProgressIndicator(color: AureliusTheme.accentGold),
                      const SizedBox(height: 12),
                      Text("Aurelius sta leggendo il documento...", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 13))
                    ]))
                  : _results.isEmpty 
                    ? Text("Nessun asset trovato nel documento. Prova con un'immagine più nitida.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93)))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Asset trovati: ${_results.length}", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AureliusTheme.accentGold)),
                          const SizedBox(height: 16),
                          ..._results.map((r) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.description_rounded, size: 20, color: Color(0xFF8E8E93)),
                                    const SizedBox(width: 12),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${r.name.isEmpty ? r.ticker : r.name} (${r.ticker})", style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                                        Text("Qta: ${r.quantity} | Prezzo: ${r.averageLoadPrice}", style: GoogleFonts.inter(color: const Color(0xFF8E8E93), fontSize: 12)),
                                      ],
                                    ))
                                  ],
                                ),
                              )),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AureliusTheme.accentGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              onPressed: _importAssets,
                              child: Text("Importa tutti nel portafoglio", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                          ),
                        ],
                      )
              )
            ]
          ],
        ),
      ),
    );
  }
}
