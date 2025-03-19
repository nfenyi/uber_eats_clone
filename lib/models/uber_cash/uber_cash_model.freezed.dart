// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uber_cash_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UberCash _$UberCashFromJson(Map<String, dynamic> json) {
  return _UberCash.fromJson(json);
}

/// @nodoc
mixin _$UberCash {
  bool get isActive => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this UberCash to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UberCash
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UberCashCopyWith<UberCash> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UberCashCopyWith<$Res> {
  factory $UberCashCopyWith(UberCash value, $Res Function(UberCash) then) =
      _$UberCashCopyWithImpl<$Res, UberCash>;
  @useResult
  $Res call({bool isActive, double balance});
}

/// @nodoc
class _$UberCashCopyWithImpl<$Res, $Val extends UberCash>
    implements $UberCashCopyWith<$Res> {
  _$UberCashCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UberCash
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActive = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UberCashImplCopyWith<$Res>
    implements $UberCashCopyWith<$Res> {
  factory _$$UberCashImplCopyWith(
          _$UberCashImpl value, $Res Function(_$UberCashImpl) then) =
      __$$UberCashImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isActive, double balance});
}

/// @nodoc
class __$$UberCashImplCopyWithImpl<$Res>
    extends _$UberCashCopyWithImpl<$Res, _$UberCashImpl>
    implements _$$UberCashImplCopyWith<$Res> {
  __$$UberCashImplCopyWithImpl(
      _$UberCashImpl _value, $Res Function(_$UberCashImpl) _then)
      : super(_value, _then);

  /// Create a copy of UberCash
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActive = null,
    Object? balance = null,
  }) {
    return _then(_$UberCashImpl(
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UberCashImpl implements _UberCash {
  const _$UberCashImpl({this.isActive = false, this.balance = 0.00});

  factory _$UberCashImpl.fromJson(Map<String, dynamic> json) =>
      _$$UberCashImplFromJson(json);

  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final double balance;

  @override
  String toString() {
    return 'UberCash(isActive: $isActive, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UberCashImpl &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isActive, balance);

  /// Create a copy of UberCash
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UberCashImplCopyWith<_$UberCashImpl> get copyWith =>
      __$$UberCashImplCopyWithImpl<_$UberCashImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UberCashImplToJson(
      this,
    );
  }
}

abstract class _UberCash implements UberCash {
  const factory _UberCash({final bool isActive, final double balance}) =
      _$UberCashImpl;

  factory _UberCash.fromJson(Map<String, dynamic> json) =
      _$UberCashImpl.fromJson;

  @override
  bool get isActive;
  @override
  double get balance;

  /// Create a copy of UberCash
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UberCashImplCopyWith<_$UberCashImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
