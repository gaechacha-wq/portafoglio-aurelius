// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return _Asset.fromJson(json);
}

/// @nodoc
mixin _$Asset {
  String get id => throw _privateConstructorUsedError;
  String get ticker => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  AssetCategory get category => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get entryPrice => throw _privateConstructorUsedError;
  double get currentPrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get bank => throw _privateConstructorUsedError;
  double get mortgageResidual => throw _privateConstructorUsedError;
  double get monthlyRent => throw _privateConstructorUsedError;
  String get cryptoLocation => throw _privateConstructorUsedError;
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res, Asset>;
  @useResult
  $Res call(
      {String id,
      String ticker,
      String name,
      AssetCategory category,
      double quantity,
      double entryPrice,
      double currentPrice,
      String currency,
      String bank,
      double mortgageResidual,
      double monthlyRent,
      String cryptoLocation,
      DateTime? expirationDate,
      String? notes});
}

/// @nodoc
class _$AssetCopyWithImpl<$Res, $Val extends Asset>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticker = null,
    Object? name = null,
    Object? category = null,
    Object? quantity = null,
    Object? entryPrice = null,
    Object? currentPrice = null,
    Object? currency = null,
    Object? bank = null,
    Object? mortgageResidual = null,
    Object? monthlyRent = null,
    Object? cryptoLocation = null,
    Object? expirationDate = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticker: null == ticker
          ? _value.ticker
          : ticker // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AssetCategory,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      bank: null == bank
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as String,
      mortgageResidual: null == mortgageResidual
          ? _value.mortgageResidual
          : mortgageResidual // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyRent: null == monthlyRent
          ? _value.monthlyRent
          : monthlyRent // ignore: cast_nullable_to_non_nullable
              as double,
      cryptoLocation: null == cryptoLocation
          ? _value.cryptoLocation
          : cryptoLocation // ignore: cast_nullable_to_non_nullable
              as String,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetImplCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$$AssetImplCopyWith(
          _$AssetImpl value, $Res Function(_$AssetImpl) then) =
      __$$AssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ticker,
      String name,
      AssetCategory category,
      double quantity,
      double entryPrice,
      double currentPrice,
      String currency,
      String bank,
      double mortgageResidual,
      double monthlyRent,
      String cryptoLocation,
      DateTime? expirationDate,
      String? notes});
}

/// @nodoc
class __$$AssetImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$AssetImpl>
    implements _$$AssetImplCopyWith<$Res> {
  __$$AssetImplCopyWithImpl(
      _$AssetImpl _value, $Res Function(_$AssetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticker = null,
    Object? name = null,
    Object? category = null,
    Object? quantity = null,
    Object? entryPrice = null,
    Object? currentPrice = null,
    Object? currency = null,
    Object? bank = null,
    Object? mortgageResidual = null,
    Object? monthlyRent = null,
    Object? cryptoLocation = null,
    Object? expirationDate = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$AssetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticker: null == ticker
          ? _value.ticker
          : ticker // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AssetCategory,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      bank: null == bank
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as String,
      mortgageResidual: null == mortgageResidual
          ? _value.mortgageResidual
          : mortgageResidual // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyRent: null == monthlyRent
          ? _value.monthlyRent
          : monthlyRent // ignore: cast_nullable_to_non_nullable
              as double,
      cryptoLocation: null == cryptoLocation
          ? _value.cryptoLocation
          : cryptoLocation // ignore: cast_nullable_to_non_nullable
              as String,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetImpl extends _Asset {
  const _$AssetImpl(
      {required this.id,
      required this.ticker,
      required this.name,
      required this.category,
      required this.quantity,
      required this.entryPrice,
      required this.currentPrice,
      this.currency = 'EUR',
      required this.bank,
      this.mortgageResidual = 0.0,
      this.monthlyRent = 0.0,
      this.cryptoLocation = '',
      this.expirationDate,
      this.notes})
      : super._();

  factory _$AssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetImplFromJson(json);

  @override
  final String id;
  @override
  final String ticker;
  @override
  final String name;
  @override
  final AssetCategory category;
  @override
  final double quantity;
  @override
  final double entryPrice;
  @override
  final double currentPrice;
  @override
  @JsonKey()
  final String currency;
  @override
  final String bank;
  @override
  @JsonKey()
  final double mortgageResidual;
  @override
  @JsonKey()
  final double monthlyRent;
  @override
  @JsonKey()
  final String cryptoLocation;
  @override
  final DateTime? expirationDate;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Asset(id: $id, ticker: $ticker, name: $name, category: $category, quantity: $quantity, entryPrice: $entryPrice, currentPrice: $currentPrice, currency: $currency, bank: $bank, mortgageResidual: $mortgageResidual, monthlyRent: $monthlyRent, cryptoLocation: $cryptoLocation, expirationDate: $expirationDate, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticker, ticker) || other.ticker == ticker) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.bank, bank) || other.bank == bank) &&
            (identical(other.mortgageResidual, mortgageResidual) ||
                other.mortgageResidual == mortgageResidual) &&
            (identical(other.monthlyRent, monthlyRent) ||
                other.monthlyRent == monthlyRent) &&
            (identical(other.cryptoLocation, cryptoLocation) ||
                other.cryptoLocation == cryptoLocation) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ticker,
      name,
      category,
      quantity,
      entryPrice,
      currentPrice,
      currency,
      bank,
      mortgageResidual,
      monthlyRent,
      cryptoLocation,
      expirationDate,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      __$$AssetImplCopyWithImpl<_$AssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetImplToJson(
      this,
    );
  }
}

abstract class _Asset extends Asset {
  const factory _Asset(
      {required final String id,
      required final String ticker,
      required final String name,
      required final AssetCategory category,
      required final double quantity,
      required final double entryPrice,
      required final double currentPrice,
      final String currency,
      required final String bank,
      final double mortgageResidual,
      final double monthlyRent,
      final String cryptoLocation,
      final DateTime? expirationDate,
      final String? notes}) = _$AssetImpl;
  const _Asset._() : super._();

  factory _Asset.fromJson(Map<String, dynamic> json) = _$AssetImpl.fromJson;

  @override
  String get id;
  @override
  String get ticker;
  @override
  String get name;
  @override
  AssetCategory get category;
  @override
  double get quantity;
  @override
  double get entryPrice;
  @override
  double get currentPrice;
  @override
  String get currency;
  @override
  String get bank;
  @override
  double get mortgageResidual;
  @override
  double get monthlyRent;
  @override
  String get cryptoLocation;
  @override
  DateTime? get expirationDate;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
