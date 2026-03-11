import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';
import '../services/scanner_service.dart';
import '../services/firebase_service.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  bool _isScanning = false;
  bool _isSaving = false;
  List<ScannedAsset>? _scannedResults;
  String _selectedBank = 'Fineco';

  final List<String> _availableBanks = ['Fineco', 'Intesa', 'Revolut'];

  Future<void> _handleScan() async {
    setState(() {
      _isScanning = true;
      _scannedResults = null;
    });

    try {
      final scannerService = ref.read(scannerProvider);
      final results = await scannerService.processScreenshot('dummy_path');
      
      if (mounted) {
        setState(() {
          _scannedResults = results;
          _isScanning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore Intelligenza Gemini: $e')));
      }
    }
  }

  Future<void> _handleSave() async {
    if (_scannedResults == null) return;
    
    setState(() => _isSaving = true);
    final firebaseService = ref.read(firebaseServiceProvider);

    for (var asset in _scannedResults!) {
      await firebaseService.saveScannedAsset(asset, _selectedBank);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Asset importati con successo nel portafoglio!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scansione Screenshot'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_scannedResults == null && !_isScanning) ...[
                const Spacer(),
                const Icon(Icons.document_scanner_outlined, size: 80, color: AureliusTheme.secondaryText),
                const SizedBox(height: 20),
                Text(
                  'Carica uno scatto del tuo portafoglio.\nLa potenza di Gemini identificherà titoli, qtà e prezzi di carico medi in pochi istanti.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _handleScan,
                  child: GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome, color: AureliusTheme.accentGold),
                        const SizedBox(width: 12),
                        Text('Avvia Scansione AI', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ] else if (_isScanning) ...[
                const Spacer(),
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: AureliusTheme.accentGold),
                      SizedBox(height: 24),
                      Text('Gemini sta estraendo i dati...', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const Spacer(),
              ] else if (_scannedResults != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dati Identificati:', style: Theme.of(context).textTheme.titleLarge),
                    DropdownButton<String>(
                      value: _selectedBank,
                      dropdownColor: AureliusTheme.cardDark,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.account_balance, color: AureliusTheme.accentGold, size: 20),
                      items: _availableBanks.map((b) => DropdownMenuItem(value: b, child: Text('  $b'))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedBank = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _scannedResults!.length,
                    itemBuilder: (context, index) {
                      final asset = _scannedResults![index];
                      final formatter = NumberFormat.currency(locale: 'it_IT', symbol: '€');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GlassContainer(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(asset.ticker, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AureliusTheme.accentGold)),
                                  Text(asset.name, style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Carico: ${formatter.format(asset.averageLoadPrice)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Qtà: ${asset.quantity.toInt()}', style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GlassContainer(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AureliusTheme.accentGold.withOpacity(0.2),
                      foregroundColor: AureliusTheme.accentGold,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isSaving ? null : _handleSave,
                    child: _isSaving 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AureliusTheme.accentGold))
                        : const Text('Importa in Portafoglio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
