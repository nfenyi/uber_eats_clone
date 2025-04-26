// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uber_one_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UberOneStatus _$UberOneStatusFromJson(Map<String, dynamic> json) {
  return _UberOneStatus.fromJson(json);
}

/// @nodoc
mixin _$UberOneStatus {
  bool get hasUberOne => throw _privateConstructorUsedError;
  double get moneySaved => throw _privateConstructorUsedError;
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  String? get plan => throw _privateConstructorUsedError;

  /// Serializes this UberOneStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UberOneStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UberOneStatusCopyWith<UberOneStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UberOneStatusCopyWith<$Res> {
  factory $UberOneStatusCopyWith(
          UberOneStatus value, $Res Function(UberOneStatus) then) =
      _$UberOneStatusCopyWithImpl<$Res, UberOneStatus>;
  @useResult
  $Res call(
      {bool hasUberOne,
      double moneySaved,
      DateTime? expirationDate,
      String? plan});
}

/// @nodoc
class _$UberOneStatusCopyWithImpl<$Res, $Val extends UberOneStatus>
    implements $UberOneStatusCopyWith<$Res> {
  _$UberOneStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UberOneStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasUberOne = null,
    Object? moneySaved = null,
    Object? expirationDate = freezed,
    Object? plan = freezed,
  }) {
    return _then(_value.copyWith(
      hasUberOne: null == hasUberOne
          ? _value.hasUberOne
          : hasUberOne // ignore: cast_nullable_to_non_nullable
              as bool,
      moneySaved: null == moneySaved
          ? _value.moneySaved
          : moneySaved // ignore: cast_nullable_to_non_nullable
              as double,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UberOneStatusImplCopyWith<$Res>
    implements $UberOneStatusCopyWith<$Res> {
  factory _$$UberOneStatusImplCopyWith(
          _$UberOneStatusImpl value, $Res Function(_$UberOneStatusImpl) then) =
      __$$UberOneStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasUberOne,
      double moneySaved,
      DateTime? expirationDate,
      String? plan});
}

/// @nodoc
class __$$UberOneStatusImplCopyWithImpl<$Res>
    extends _$UberOneStatusCopyWithImpl<$Res, _$UberOneStatusImpl>
    implements _$$UberOneStatusImplCopyWith<$Res> {
  __$$UberOneStatusImplCopyWithImpl(
      _$UberOneStatusImpl _value, $Res Function(_$UberOneStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of UberOneStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasUberOne = null,
    Object? moneySaved = null,
    Object? expirationDate = freezed,
    Object? plan = freezed,
  }) {
    return _then(_$UberOneStatusImpl(
      hasUberOne: null == hasUberOne
          ? _value.hasUberOne
          : hasUberOne // ignore: cast_nullable_to_non_nullable
              as bool,
      moneySaved: null == moneySaved
          ? _value.moneySaved
          : moneySaved // ignore: cast_nullable_to_non_nullable
              as double,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UberOneStatusImpl
    with DiagnosticableTreeMixin
    implements _UberOneStatus {
  _$UberOneStatusImpl(
      {this.hasUberOne = false,
      this.moneySaved = 0,
      this.expirationDate,
      this.plan});

  factory _$UberOneStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$UberOneStatusImplFromJson(json);

  @override
  @JsonKey()
  final bool hasUberOne;
  @override
  @JsonKey()
  final double moneySaved;
  @override
  final DateTime? expirationDate;
  @override
  final String? plan;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UberOneStatus(hasUberOne: $hasUberOne, moneySaved: $moneySaved, expirationDate: $expirationDate, plan: $plan)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UberOneStatus'))
      ..add(DiagnosticsProperty('hasUberOne', hasUberOne))
      ..add(DiagnosticsProperty('moneySaved', moneySaved))
      ..add(DiagnosticsProperty('expirationDate', expirationDate))
      ..add(DiagnosticsProperty('plan', plan));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UberOneStatusImpl &&
            (identical(other.hasUberOne, hasUberOne) ||
                other.hasUberOne == hasUberOne) &&
            (identical(other.moneySaved, moneySaved) ||
                other.moneySaved == moneySaved) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.plan, plan) || other.plan == plan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hasUberOne, moneySaved, expirationDate, plan);

  /// Create a copy of UberOneStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UberOneStatusImplCopyWith<_$UberOneStatusImpl> get copyWith =>
      __$$UberOneStatusImplCopyWithImpl<_$UberOneStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UberOneStatusImplToJson(
      this,
    );
  }
}

abstract class _UberOneStatus implements UberOneStatus {
  factory _UberOneStatus(
      {final bool hasUberOne,
      final double moneySaved,
      final DateTime? expirationDate,
      final String? plan}) = _$UberOneStatusImpl;

  factory _UberOneStatus.fromJson(Map<String, dynamic> json) =
      _$UberOneStatusImpl.fromJson;

  @override
  bool get hasUberOne;
  @override
  double get moneySaved;
  @override
  DateTime? get expirationDate;
  @override
  String? get plan;

  /// Create a copy of UberOneStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UberOneStatusImplCopyWith<_$UberOneStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
