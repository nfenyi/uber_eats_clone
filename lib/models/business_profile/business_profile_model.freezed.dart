// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) {
  return _BusinessProfile.fromJson(json);
}

/// @nodoc
mixin _$BusinessProfile {
  String get id => throw _privateConstructorUsedError;
  String? get creditCardNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get expenseProgram => throw _privateConstructorUsedError;

  /// Serializes this BusinessProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessProfileCopyWith<BusinessProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessProfileCopyWith<$Res> {
  factory $BusinessProfileCopyWith(
          BusinessProfile value, $Res Function(BusinessProfile) then) =
      _$BusinessProfileCopyWithImpl<$Res, BusinessProfile>;
  @useResult
  $Res call(
      {String id,
      String? creditCardNumber,
      String? email,
      String? expenseProgram});
}

/// @nodoc
class _$BusinessProfileCopyWithImpl<$Res, $Val extends BusinessProfile>
    implements $BusinessProfileCopyWith<$Res> {
  _$BusinessProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creditCardNumber = freezed,
    Object? email = freezed,
    Object? expenseProgram = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creditCardNumber: freezed == creditCardNumber
          ? _value.creditCardNumber
          : creditCardNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseProgram: freezed == expenseProgram
          ? _value.expenseProgram
          : expenseProgram // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessProfileImplCopyWith<$Res>
    implements $BusinessProfileCopyWith<$Res> {
  factory _$$BusinessProfileImplCopyWith(_$BusinessProfileImpl value,
          $Res Function(_$BusinessProfileImpl) then) =
      __$$BusinessProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? creditCardNumber,
      String? email,
      String? expenseProgram});
}

/// @nodoc
class __$$BusinessProfileImplCopyWithImpl<$Res>
    extends _$BusinessProfileCopyWithImpl<$Res, _$BusinessProfileImpl>
    implements _$$BusinessProfileImplCopyWith<$Res> {
  __$$BusinessProfileImplCopyWithImpl(
      _$BusinessProfileImpl _value, $Res Function(_$BusinessProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creditCardNumber = freezed,
    Object? email = freezed,
    Object? expenseProgram = freezed,
  }) {
    return _then(_$BusinessProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creditCardNumber: freezed == creditCardNumber
          ? _value.creditCardNumber
          : creditCardNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseProgram: freezed == expenseProgram
          ? _value.expenseProgram
          : expenseProgram // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessProfileImpl implements _BusinessProfile {
  const _$BusinessProfileImpl(
      {required this.id,
      this.creditCardNumber,
      required this.email,
      this.expenseProgram});

  factory _$BusinessProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String? creditCardNumber;
  @override
  final String? email;
  @override
  final String? expenseProgram;

  @override
  String toString() {
    return 'BusinessProfile(id: $id, creditCardNumber: $creditCardNumber, email: $email, expenseProgram: $expenseProgram)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creditCardNumber, creditCardNumber) ||
                other.creditCardNumber == creditCardNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.expenseProgram, expenseProgram) ||
                other.expenseProgram == expenseProgram));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, creditCardNumber, email, expenseProgram);

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      __$$BusinessProfileImplCopyWithImpl<_$BusinessProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessProfileImplToJson(
      this,
    );
  }
}

abstract class _BusinessProfile implements BusinessProfile {
  const factory _BusinessProfile(
      {required final String id,
      final String? creditCardNumber,
      required final String? email,
      final String? expenseProgram}) = _$BusinessProfileImpl;

  factory _BusinessProfile.fromJson(Map<String, dynamic> json) =
      _$BusinessProfileImpl.fromJson;

  @override
  String get id;
  @override
  String? get creditCardNumber;
  @override
  String? get email;
  @override
  String? get expenseProgram;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
