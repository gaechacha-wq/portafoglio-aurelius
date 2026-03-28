// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetImpl _$$AssetImplFromJson(Map<String, dynamic> json) => _$AssetImpl(
      id: json['id'] as String,
      ticker: json['ticker'] as String,
      name: json['name'] as String,
      category: $enumDecode(_$AssetCategoryEnumMap, json['category']),
      quantity: (json['quantity'] as num).toDouble(),
      entryPrice: (json['entryPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      bank: json['bank'] as String,
      mortgageResidual: (json['mortgageResidual'] as num?)?.toDouble() ?? 0.0,
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0.0,
      cryptoLocation: json['cryptoLocation'] as String? ?? '',
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$AssetImplToJson(_$AssetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticker': instance.ticker,
      'name': instance.name,
      'category': _$AssetCategoryEnumMap[instance.category]!,
      'quantity': instance.quantity,
      'entryPrice': instance.entryPrice,
      'currentPrice': instance.currentPrice,
      'currency': instance.currency,
      'bank': instance.bank,
      'mortgageResidual': instance.mortgageResidual,
      'monthlyRent': instance.monthlyRent,
      'cryptoLocation': instance.cryptoLocation,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'notes': instance.notes,
    };

const _$AssetCategoryEnumMap = {
  AssetCategory.finanza: 'finanza',
  AssetCategory.crypto: 'crypto',
  AssetCategory.realEstate: 'realEstate',
  AssetCategory.cash: 'cash',
  AssetCategory.metalli: 'metalli',
  AssetCategory.lusso: 'lusso',
  AssetCategory.previdenza: 'previdenza',
};
