import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset_model.dart';

final monteCarloServiceProvider = Provider<MonteCarloService>((ref) {
  return MonteCarloService();
});

class MonteCarloResult {
  final double percentile5;
  final double percentile25;
  final double percentile50;
  final double percentile75;
  final double percentile95;
  final double expectedValue;
  final double worstCase;
  final double bestCase;
  final List<double> simulationPaths;

  const MonteCarloResult({
    required this.percentile5,
    required this.percentile25,
    required this.percentile50,
    required this.percentile75,
    required this.percentile95,
    required this.expectedValue,
    required this.worstCase,
    required this.bestCase,
    required this.simulationPaths,
  });
}

class MonteCarloService {
  final Random _random = Random();

  // Volatilità annuale per categoria
  static const Map<String, double> _volatility = {
    'finanza': 0.18,
    'crypto': 0.75,
    'realEstate': 0.08,
    'metalli': 0.15,
    'lusso': 0.10,
    'cash': 0.01,
    'previdenza': 0.05,
  };

  // Rendimento atteso annuale per categoria
  static const Map<String, double> _expectedReturn = {
    'finanza': 0.08,
    'crypto': 0.25,
    'realEstate': 0.05,
    'metalli': 0.06,
    'lusso': 0.04,
    'cash': 0.02,
    'previdenza': 0.04,
  };

  MonteCarloResult simulate({
    required List<Asset> assets,
    required int years,
    required int simulations,
    required String targetCurrency,
  }) {
    final totalValue = assets.fold(
      0.0,
      (sum, a) => sum + a.totalNetValueIn(targetCurrency),
    );

    if (totalValue <= 0) {
      return const MonteCarloResult(
        percentile5: 0,
        percentile25: 0,
        percentile50: 0,
        percentile75: 0,
        percentile95: 0,
        expectedValue: 0,
        worstCase: 0,
        bestCase: 0,
        simulationPaths: [],
      );
    }

    // Calcola rendimento e volatilità pesati del portafoglio
    double weightedReturn = 0;
    double weightedVolatility = 0;

    for (final asset in assets) {
      final weight = asset.totalNetValueIn(targetCurrency) / totalValue;
      final cat = asset.category.name;
      weightedReturn += weight * (_expectedReturn[cat] ?? 0.07);
      weightedVolatility += weight * (_volatility[cat] ?? 0.15);
    }

    // Esegui simulazioni
    final finalValues = <double>[];

    for (int i = 0; i < simulations; i++) {
      double value = totalValue;
      for (int y = 0; y < years; y++) {
        final drift = weightedReturn - (weightedVolatility * weightedVolatility / 2);
        final shock = weightedVolatility * _normalRandom();
        value *= exp(drift + shock);
      }
      finalValues.add(value);
    }

    finalValues.sort();

    return MonteCarloResult(
      percentile5: finalValues[(simulations * 0.05).round()],
      percentile25: finalValues[(simulations * 0.25).round()],
      percentile50: finalValues[(simulations * 0.50).round()],
      percentile75: finalValues[(simulations * 0.75).round()],
      percentile95: finalValues[(simulations * 0.95).round()],
      expectedValue: finalValues.fold(0.0, (s, v) => s + v) / simulations,
      worstCase: finalValues.first,
      bestCase: finalValues.last,
      simulationPaths: finalValues,
    );
  }

  // Genera numero casuale con distribuzione normale (Box-Muller)
  double _normalRandom() {
    final u1 = _random.nextDouble();
    final u2 = _random.nextDouble();
    return sqrt(-2 * log(u1)) * cos(2 * pi * u2);
  }
}
