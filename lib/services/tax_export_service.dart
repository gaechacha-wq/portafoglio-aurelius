import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/asset_model.dart';

final taxExportServiceProvider = Provider<TaxExportService>((ref) {
  return TaxExportService();
});

class TaxExportService {
  static const double _aliquotaItaliana = 0.26;

  double calcolaPlusvalenza(Asset asset) {
    return asset.profitLoss;
  }

  double calcolaImposta(Asset asset) {
    final plusvalenza = calcolaPlusvalenza(asset);
    if (plusvalenza <= 0) return 0.0;
    return plusvalenza * _aliquotaItaliana;
  }

  double calcolaImpostaNetta(List<Asset> assets) {
    double totalePlusvAlenze = 0;
    double totaleMinus = 0;

    for (final asset in assets) {
      final pl = asset.profitLoss;
      if (pl > 0) {
        totalePlusvAlenze += pl;
      } else {
        totaleMinus += pl.abs();
      }
    }

    final imponibile = totalePlusvAlenze - totaleMinus;
    if (imponibile <= 0) return 0.0;
    return imponibile * _aliquotaItaliana;
  }

  String generaCSV(List<Asset> assets) {
    final buffer = StringBuffer();
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final oggi = dateFormatter.format(DateTime.now());

    buffer.writeln('Portafoglio Aurelius — Report Fiscale al $oggi');
    buffer.writeln('Ticker,Nome Asset,Categoria,Quantità,Prezzo Carico,Valore Attuale,Valore Totale Carico,Valore Totale Attuale,Plusvalenza/Minusvalenza,Variazione %,Imposta Dovuta (26%)');

    double totPlusvalenze = 0;
    double totMinusvalenze = 0;

    for (final asset in assets) {
      if (asset.category == AssetCategory.cash || asset.category == AssetCategory.previdenza) {
        continue;
      }

      final pl = asset.profitLoss;
      final imposta = calcolaImposta(asset);

      if (pl > 0) {
        totPlusvalenze += pl;
      } else {
        totMinusvalenze += pl.abs();
      }

      buffer.writeln(
        '${asset.ticker},'
        '"${asset.name}",'
        '${asset.category.name},'
        '${asset.quantity},'
        '${asset.entryPrice},'
        '${asset.currentPrice},'
        '${asset.totalEntryValue},'
        '${asset.totalGrossValue},'
        '$pl,'
        '${asset.profitLossPercent.toStringAsFixed(2)}%,'
        '$imposta'
      );
    }

    buffer.writeln('');
    buffer.writeln('RIEPILOGO FISCALE');
    buffer.writeln('Totale Plusvalenze,${totPlusvalenze.toStringAsFixed(2)}');
    buffer.writeln('Totale Minusvalenze,-${totMinusvalenze.toStringAsFixed(2)}');
    final imponibile = totPlusvalenze - totMinusvalenze;
    buffer.writeln('Imponibile Netto,${imponibile.toStringAsFixed(2)}');
    buffer.writeln('Imposta Sostitutiva 26%,${(imponibile > 0 ? imponibile * _aliquotaItaliana : 0).toStringAsFixed(2)}');

    return buffer.toString();
  }
}
