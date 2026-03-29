import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/asset_model.dart';
import '../services/firebase_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/aurelius_snackbar.dart';

class AddAssetScreen extends ConsumerStatefulWidget {
  const AddAssetScreen({super.key});

  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  int _currentStep = 0;
  AssetCategory? _selectedCategory;
  
  final _nameController = TextEditingController();
  final _tickerController = TextEditingController();
  final _bankController = TextEditingController();
  final _quantityController = TextEditingController();
  final _entryPriceController = TextEditingController();
  final _currentPriceController = TextEditingController();
  final _mortgageController = TextEditingController();
  final _rentController = TextEditingController();
  final _cryptoLocationController = TextEditingController();
  
  DateTime? _expirationDate;
  String _selectedCurrency = 'EUR';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(() => setState(() {}));
    _entryPriceController.addListener(() => setState(() {}));
    _currentPriceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tickerController.dispose();
    _bankController.dispose();
    _quantityController.dispose();
    _entryPriceController.dispose();
    _currentPriceController.dispose();
    _mortgageController.dispose();
    _rentController.dispose();
    _cryptoLocationController.dispose();
    super.dispose();
  }

  double _parseDouble(String value) {
    if (value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedCategory == null) return;
    if (_currentStep == 1) {
      if (_nameController.text.trim().isEmpty || _bankController.text.trim().isEmpty) return; 
    }
    if (_currentStep == 2) {
      if (_quantityController.text.trim().isEmpty || 
          _entryPriceController.text.trim().isEmpty || 
          _currentPriceController.text.trim().isEmpty) return;
    }
    
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/dashboard');
      }
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return "Che tipo di asset?";
      case 1: return "Informazioni Base";
      case 2: return "Valori Economici";
      case 3: return "Dettagli";
      case 4: return "Conferma";
      default: return "";
    }
  }

  Future<void> _saveAsset() async {
    setState(() { _isSaving = true; });

    final newAsset = Asset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      ticker: _tickerController.text.trim(),
      category: _selectedCategory!,
      quantity: _parseDouble(_quantityController.text),
      entryPrice: _parseDouble(_entryPriceController.text),
      currentPrice: _parseDouble(_currentPriceController.text),
      currency: _selectedCurrency,
      bank: _bankController.text.trim(),
      mortgageResidual: _selectedCategory == AssetCategory.realEstate ? _parseDouble(_mortgageController.text) : 0.0,
      monthlyRent: _selectedCategory == AssetCategory.realEstate ? _parseDouble(_rentController.text) : 0.0,
      cryptoLocation: _selectedCategory == AssetCategory.crypto ? _cryptoLocationController.text.trim() : '',
      expirationDate: _selectedCategory == AssetCategory.previdenza ? _expirationDate : null,
      notes: null, // Placeholder annotazioni
    );

    try {
      await ref.read(firebaseServiceProvider).saveAsset(newAsset);
      if (mounted) {
        final assetName = newAsset.name.isEmpty ? newAsset.ticker : newAsset.name;
        AureliusSnackBar.showSuccess(context, "✅ $assetName aggiunto al portafoglio!");
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        AureliusSnackBar.showError(context, "Errore nel salvataggio. Riprova tra qualche secondo.");
      }
    } finally {
      if (mounted) {
        setState(() { _isSaving = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AureliusTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFFD4AF37),
          ),
          onPressed: _prevStep,
        ),
        title: Text(
          _getStepTitle(),
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: AureliusTheme.accentGold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 5,
            backgroundColor: AureliusTheme.cardDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AureliusTheme.accentGold),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildStep0();
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      case 4: return _buildStep4();
      default: return const SizedBox.shrink();
    }
  }

  // ==== STEP CARDS ==== //

  Widget _buildStep0() {
    final categories = [
      {'cat': AssetCategory.finanza, 'title': 'Azioni/ETF', 'icon': Icons.trending_up, 'color': const Color(0xFFD4AF37)},
      {'cat': AssetCategory.crypto, 'title': 'Crypto', 'icon': Icons.currency_bitcoin, 'color': const Color(0xFF00E5FF)},
      {'cat': AssetCategory.realEstate, 'title': 'Immobile', 'icon': Icons.home, 'color': const Color(0xFF4CAF50)},
      {'cat': AssetCategory.metalli, 'title': 'Oro & Metalli', 'icon': Icons.savings, 'color': const Color(0xFFFF9800)},
      {'cat': AssetCategory.lusso, 'title': 'Lusso', 'icon': Icons.diamond, 'color': const Color(0xFF9C27B0)},
      {'cat': AssetCategory.cash, 'title': 'Liquidità', 'icon': Icons.account_balance_wallet, 'color': const Color(0xFF607D8B)},
      {'cat': AssetCategory.previdenza, 'title': 'Previdenza', 'icon': Icons.shield, 'color': const Color(0xFF03A9F4)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Text("Cosa vuoi aggiungere?", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text("Seleziona la categoria del tuo asset", style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF8E8E93)), textAlign: TextAlign.center),
        const SizedBox(height: 32),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 16, 
              mainAxisSpacing: 16, 
              childAspectRatio: 1.1
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];
              final cat = item['cat'] as AssetCategory;
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat);
                  Future.delayed(const Duration(milliseconds: 300), _nextStep);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AureliusTheme.accentGold.withOpacity(0.15) : Colors.transparent,
                    border: Border.all(color: isSelected ? AureliusTheme.accentGold : Colors.white.withOpacity(0.1), width: 1.5),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: GlassContainer(
                    margin: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'] as IconData, size: 40, color: item['color'] as Color),
                        const SizedBox(height: 12),
                        Text(item['title'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, bool required = false, TextInputType? keyboardType, String? prefix, TextCapitalization textCapitalization = TextCapitalization.none}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(required ? "$label *" : label, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.white24),
            prefixText: prefix != null ? "$prefix " : null,
            prefixStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
            filled: true,
            fillColor: AureliusTheme.cardDark,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFF8E8E93).withOpacity(0.3))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AureliusTheme.accentGold)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContinueButton(VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AureliusTheme.accentGold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text("Continua", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildTextField("Nome asset", _nameController, hint: "es. Appartamento Milano, Bitcoin...", required: true),
          _buildTextField("Ticker o Codice", _tickerController, hint: "es. NVDA, BTC, VWCE.DE (opzionale)", textCapitalization: TextCapitalization.characters),
          _buildTextField("Banca / Custodia / Posizione", _bankController, hint: "es. Fineco, Ledger, Cassetta Sicurezza", required: true),
          _buildContinueButton(_nextStep),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    double q = _parseDouble(_quantityController.text);
    double ep = _parseDouble(_entryPriceController.text);
    double cp = _parseDouble(_currentPriceController.text);

    double totalEntry = ep * q;
    double totalCurrent = cp * q;
    double profitLoss = totalCurrent - totalEntry;
    double profitLossPct = totalEntry == 0 ? 0.0 : (profitLoss / totalEntry) * 100;

    final curSymbol = _selectedCurrency == 'EUR' ? '€' : (_selectedCurrency == 'USD' ? '\$' : '£');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTextField("Quantità", _quantityController, hint: "es. 10, 0.5, 1", keyboardType: const TextInputType.numberWithOptions(decimal: true), required: true),
          _buildTextField("Prezzo di carico", _entryPriceController, hint: "Prezzo medio di acquisto", keyboardType: const TextInputType.numberWithOptions(decimal: true), prefix: curSymbol, required: true),
          _buildTextField("Valore attuale", _currentPriceController, hint: "Stima del valore corrente", keyboardType: const TextInputType.numberWithOptions(decimal: true), prefix: curSymbol, required: true),
          
          Text("Valuta", style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCurrency,
            dropdownColor: AureliusTheme.cardDark,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AureliusTheme.cardDark,
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFF8E8E93).withOpacity(0.3))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AureliusTheme.accentGold)),
            ),
            items: ['EUR', 'USD', 'GBP'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCurrency = val);
            },
          ),
          const SizedBox(height: 24),
          
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Valore totale:", style: GoogleFonts.inter(fontSize: 14, color: AureliusTheme.secondaryText)),
                    Text("${totalCurrent.toStringAsFixed(2)} $curSymbol", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Gain/Loss:", style: GoogleFonts.inter(fontSize: 14, color: AureliusTheme.secondaryText)),
                    Text(
                      "${profitLoss >= 0 ? '+' : ''}${profitLoss.toStringAsFixed(2)} $curSymbol (${profitLossPct >= 0 ? '+' : ''}${profitLossPct.toStringAsFixed(2)}%)", 
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: profitLoss >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          _buildContinueButton(_nextStep),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          if (_selectedCategory == AssetCategory.realEstate) ...[
            _buildTextField("Debito residuo mutuo", _mortgageController, hint: "es. 180000", prefix: "€", keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            _buildTextField("Affitto mensile percepito", _rentController, hint: "es. 2200 (se affittato, altrimenti 0)", prefix: "€", keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          ] else if (_selectedCategory == AssetCategory.crypto) ...[
            _buildTextField("Wallet o Exchange", _cryptoLocationController, hint: "es. Ledger, Binance, MetaMask"),
          ] else if (_selectedCategory == AssetCategory.previdenza) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Data scadenza polizza", style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2099),
                      builder: (context, child) => Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(primary: AureliusTheme.accentGold, onPrimary: Colors.black, surface: AureliusTheme.cardDark, onSurface: Colors.white),
                        ),
                        child: child!,
                      ),
                    );
                    if (date != null) setState(() => _expirationDate = date);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AureliusTheme.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF8E8E93).withOpacity(0.3)),
                    ),
                    child: Text(
                      _expirationDate != null ? DateFormat('dd/MM/yyyy').format(_expirationDate!) : "Seleziona una data",
                      style: GoogleFonts.inter(fontSize: 16, color: _expirationDate != null ? Colors.white : Colors.white24),
                    ),
                  ),
                ),
              ]
            )
          ] else ...[
            const SizedBox(height: 60),
            GlassContainer(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AureliusTheme.accentGold, size: 48),
                  const SizedBox(height: 16),
                  Text("Nessun dettaglio aggiuntivo\nrichiesto per questa categoria.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          _buildContinueButton(_nextStep),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    double q = _parseDouble(_quantityController.text);
    double ep = _parseDouble(_entryPriceController.text);
    double cp = _parseDouble(_currentPriceController.text);
    double profitLoss = (cp * q) - (ep * q);

    Widget _buildRow(String label, String value, {Color? valueColor}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(color: AureliusTheme.secondaryText, fontSize: 13)),
            Flexible(child: Text(value, style: GoogleFonts.inter(color: valueColor ?? Colors.white, fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.right)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text("Riepilogo", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text("Controlla i dati prima di salvare", style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF8E8E93))),
          const SizedBox(height: 32),
          
          GlassContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildRow("Categoria:", _selectedCategory?.name.toUpperCase() ?? ""),
                const Divider(color: Colors.white10),
                _buildRow("Nome:", _nameController.text),
                _buildRow("Ticker:", _tickerController.text.isEmpty ? "—" : _tickerController.text),
                _buildRow("Custodia:", _bankController.text),
                const Divider(color: Colors.white10),
                _buildRow("Quantità:", _quantityController.text),
                _buildRow("Prezzo carico:", "${_entryPriceController.text} $_selectedCurrency"),
                _buildRow("Valore attuale:", "${_currentPriceController.text} $_selectedCurrency"),
                _buildRow("Gain/Loss:", "${profitLoss >= 0 ? '+' : ''}${profitLoss.toStringAsFixed(2)} $_selectedCurrency", valueColor: profitLoss >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336)),
                
                if (_selectedCategory == AssetCategory.realEstate) ...[
                  const Divider(color: Colors.white10),
                  _buildRow("Mutuo residuo:", "${_mortgageController.text} €"),
                  _buildRow("Affitto mensile:", "${_rentController.text} €"),
                ],
                if (_selectedCategory == AssetCategory.crypto) ...[
                  const Divider(color: Colors.white10),
                  _buildRow("Wallet:", _cryptoLocationController.text.isEmpty ? "—" : _cryptoLocationController.text),
                ],
                if (_selectedCategory == AssetCategory.previdenza && _expirationDate != null) ...[
                  const Divider(color: Colors.white10),
                  _buildRow("Scadenza:", DateFormat('dd/MM/yyyy').format(_expirationDate!)),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          _isSaving 
            ? const CircularProgressIndicator(color: AureliusTheme.accentGold)
            : SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AureliusTheme.accentGold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _saveAsset,
                  child: Text("Aggiungi al Portafoglio", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
          
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _currentStep = 0),
            child: Text("Modifica", style: GoogleFonts.inter(color: AureliusTheme.secondaryText, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
