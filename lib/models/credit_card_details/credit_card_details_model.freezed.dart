// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_card_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreditCardDetails _$CreditCardDetailsFromJson(Map<String, dynamic> json) {
  return _CreditCardDetails.fromJson(json);
}

/// @nodoc
mixin _$CreditCardDetails {
  String get cardNumber => throw _privateConstructorUsedError;
  String get expDate => throw _privateConstructorUsedError;
  String get cvv => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;
  String? get creditCardType => throw _privateConstructorUsedError;
  String get nickName => throw _privateConstructorUsedError;

  /// Serializes this CreditCardDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreditCardDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreditCardDetailsCopyWith<CreditCardDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditCardDetailsCopyWith<$Res> {
  factory $CreditCardDetailsCopyWith(
          CreditCardDetails value, $Res Function(CreditCardDetails) then) =
      _$CreditCardDetailsCopyWithImpl<$Res, CreditCardDetails>;
  @useResult
  $Res call(
      {String cardNumber,
      String expDate,
      String cvv,
      String country,
      String zipCode,
      String? creditCardType,
      String nickName});
}

/// @nodoc
class _$CreditCardDetailsCopyWithImpl<$Res, $Val extends CreditCardDetails>
    implements $CreditCardDetailsCopyWith<$Res> {
  _$CreditCardDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreditCardDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardNumber = null,
    Object? expDate = null,
    Object? cvv = null,
    Object? country = null,
    Object? zipCode = null,
    Object? creditCardType = freezed,
    Object? nickName = null,
  }) {
    return _then(_value.copyWith(
      cardNumber: null == cardNumber
          ? _value.cardNumber
          : cardNumber // ignore: cast_nullable_to_non_nullable
              as String,
      expDate: null == expDate
          ? _value.expDate
          : expDate // ignore: cast_nullable_to_non_nullable
              as String,
      cvv: null == cvv
          ? _value.cvv
          : cvv // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      creditCardType: freezed == creditCardType
          ? _value.creditCardType
          : creditCardType // ignore: cast_nullable_to_non_nullable
              as String?,
      nickName: null == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreditCardDetailsImplCopyWith<$Res>
    implements $CreditCardDetailsCopyWith<$Res> {
  factory _$$CreditCardDetailsImplCopyWith(_$CreditCardDetailsImpl value,
          $Res Function(_$CreditCardDetailsImpl) then) =
      __$$CreditCardDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cardNumber,
      String expDate,
      String cvv,
      String country,
      String zipCode,
      String? creditCardType,
      String nickName});
}

/// @nodoc
class __$$CreditCardDetailsImplCopyWithImpl<$Res>
    extends _$CreditCardDetailsCopyWithImpl<$Res, _$CreditCardDetailsImpl>
    implements _$$CreditCardDetailsImplCopyWith<$Res> {
  __$$CreditCardDetailsImplCopyWithImpl(_$CreditCardDetailsImpl _value,
      $Res Function(_$CreditCardDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreditCardDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardNumber = null,
    Object? expDate = null,
    Object? cvv = null,
    Object? country = null,
    Object? zipCode = null,
    Object? creditCardType = freezed,
    Object? nickName = null,
  }) {
    return _then(_$CreditCardDetailsImpl(
      cardNumber: null == cardNumber
          ? _value.cardNumber
          : cardNumber // ignore: cast_nullable_to_non_nullable
              as String,
      expDate: null == expDate
          ? _value.expDate
          : expDate // ignore: cast_nullable_to_non_nullable
              as String,
      cvv: null == cvv
          ? _value.cvv
          : cvv // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      creditCardType: freezed == creditCardType
          ? _value.creditCardType
          : creditCardType // ignore: cast_nullable_to_non_nullable
              as String?,
      nickName: null == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreditCardDetailsImpl
    with DiagnosticableTreeMixin
    implements _CreditCardDetails {
  const _$CreditCardDetailsImpl(
      {required this.cardNumber,
      required this.expDate,
      required this.cvv,
      required this.country,
      required this.zipCode,
      required this.creditCardType,
      required this.nickName});

  factory _$CreditCardDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreditCardDetailsImplFromJson(json);

  @override
  final String cardNumber;
  @override
  final String expDate;
  @override
  final String cvv;
  @override
  final String country;
  @override
  final String zipCode;
  @override
  final String? creditCardType;
  @override
  final String nickName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CreditCardDetails(cardNumber: $cardNumber, expDate: $expDate, cvv: $cvv, country: $country, zipCode: $zipCode, creditCardType: $creditCardType, nickName: $nickName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CreditCardDetails'))
      ..add(DiagnosticsProperty('cardNumber', cardNumber))
      ..add(DiagnosticsProperty('expDate', expDate))
      ..add(DiagnosticsProperty('cvv', cvv))
      ..add(DiagnosticsProperty('country', country))
      ..add(DiagnosticsProperty('zipCode', zipCode))
      ..add(DiagnosticsProperty('creditCardType', creditCardType))
      ..add(DiagnosticsProperty('nickName', nickName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditCardDetailsImpl &&
            (identical(other.cardNumber, cardNumber) ||
                other.cardNumber == cardNumber) &&
            (identical(other.expDate, expDate) || other.expDate == expDate) &&
            (identical(other.cvv, cvv) || other.cvv == cvv) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.creditCardType, creditCardType) ||
                other.creditCardType == creditCardType) &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cardNumber, expDate, cvv,
      country, zipCode, creditCardType, nickName);

  /// Create a copy of CreditCardDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditCardDetailsImplCopyWith<_$CreditCardDetailsImpl> get copyWith =>
      __$$CreditCardDetailsImplCopyWithImpl<_$CreditCardDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreditCardDetailsImplToJson(
      this,
    );
  }
}

abstract class _CreditCardDetails implements CreditCardDetails {
  const factory _CreditCardDetails(
      {required final String cardNumber,
      required final String expDate,
      required final String cvv,
      required final String country,
      required final String zipCode,
      required final String? creditCardType,
      required final String nickName}) = _$CreditCardDetailsImpl;

  factory _CreditCardDetails.fromJson(Map<String, dynamic> json) =
      _$CreditCardDetailsImpl.fromJson;

  @override
  String get cardNumber;
  @override
  String get expDate;
  @override
  String get cvv;
  @override
  String get country;
  @override
  String get zipCode;
  @override
  String? get creditCardType;
  @override
  String get nickName;

  /// Create a copy of CreditCardDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreditCardDetailsImplCopyWith<_$CreditCardDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
