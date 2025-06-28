// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeviceUserInfo _$DeviceUserInfoFromJson(Map<String, dynamic> json) {
  return _DeviceUserInfoModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceUserInfo {
  String? get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get profilePic => throw _privateConstructorUsedError;

  /// Serializes this DeviceUserInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceUserInfoCopyWith<DeviceUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceUserInfoCopyWith<$Res> {
  factory $DeviceUserInfoCopyWith(
          DeviceUserInfo value, $Res Function(DeviceUserInfo) then) =
      _$DeviceUserInfoCopyWithImpl<$Res, DeviceUserInfo>;
  @useResult
  $Res call(
      {String? email, String? name, String? phoneNumber, String? profilePic});
}

/// @nodoc
class _$DeviceUserInfoCopyWithImpl<$Res, $Val extends DeviceUserInfo>
    implements $DeviceUserInfoCopyWith<$Res> {
  _$DeviceUserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? profilePic = freezed,
  }) {
    return _then(_value.copyWith(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePic: freezed == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceUserInfoModelImplCopyWith<$Res>
    implements $DeviceUserInfoCopyWith<$Res> {
  factory _$$DeviceUserInfoModelImplCopyWith(_$DeviceUserInfoModelImpl value,
          $Res Function(_$DeviceUserInfoModelImpl) then) =
      __$$DeviceUserInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? email, String? name, String? phoneNumber, String? profilePic});
}

/// @nodoc
class __$$DeviceUserInfoModelImplCopyWithImpl<$Res>
    extends _$DeviceUserInfoCopyWithImpl<$Res, _$DeviceUserInfoModelImpl>
    implements _$$DeviceUserInfoModelImplCopyWith<$Res> {
  __$$DeviceUserInfoModelImplCopyWithImpl(_$DeviceUserInfoModelImpl _value,
      $Res Function(_$DeviceUserInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? profilePic = freezed,
  }) {
    return _then(_$DeviceUserInfoModelImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePic: freezed == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceUserInfoModelImpl
    with DiagnosticableTreeMixin
    implements _DeviceUserInfoModel {
  const _$DeviceUserInfoModelImpl(
      {required this.email,
      required this.name,
      required this.phoneNumber,
      required this.profilePic});

  factory _$DeviceUserInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceUserInfoModelImplFromJson(json);

  @override
  final String? email;
  @override
  final String? name;
  @override
  final String? phoneNumber;
  @override
  final String? profilePic;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DeviceUserInfo(email: $email, name: $name, phoneNumber: $phoneNumber, profilePic: $profilePic)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DeviceUserInfo'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('profilePic', profilePic));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceUserInfoModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, name, phoneNumber, profilePic);

  /// Create a copy of DeviceUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceUserInfoModelImplCopyWith<_$DeviceUserInfoModelImpl> get copyWith =>
      __$$DeviceUserInfoModelImplCopyWithImpl<_$DeviceUserInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceUserInfoModelImplToJson(
      this,
    );
  }
}

abstract class _DeviceUserInfoModel implements DeviceUserInfo {
  const factory _DeviceUserInfoModel(
      {required final String? email,
      required final String? name,
      required final String? phoneNumber,
      required final String? profilePic}) = _$DeviceUserInfoModelImpl;

  factory _DeviceUserInfoModel.fromJson(Map<String, dynamic> json) =
      _$DeviceUserInfoModelImpl.fromJson;

  @override
  String? get email;
  @override
  String? get name;
  @override
  String? get phoneNumber;
  @override
  String? get profilePic;

  /// Create a copy of DeviceUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceUserInfoModelImplCopyWith<_$DeviceUserInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
