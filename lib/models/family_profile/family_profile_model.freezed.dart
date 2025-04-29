// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FamilyProfile _$FamilyProfileFromJson(Map<String, dynamic> json) {
  return _FamilyProfile.fromJson(json);
}

/// @nodoc
mixin _$FamilyProfile {
  String get id => throw _privateConstructorUsedError;
  List<FamilyMember> get members => throw _privateConstructorUsedError;
  String get organizer => throw _privateConstructorUsedError;
  String get receiptEmail => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;

  /// Serializes this FamilyProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyProfileCopyWith<FamilyProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyProfileCopyWith<$Res> {
  factory $FamilyProfileCopyWith(
          FamilyProfile value, $Res Function(FamilyProfile) then) =
      _$FamilyProfileCopyWithImpl<$Res, FamilyProfile>;
  @useResult
  $Res call(
      {String id,
      List<FamilyMember> members,
      String organizer,
      String receiptEmail,
      String paymentMethod});
}

/// @nodoc
class _$FamilyProfileCopyWithImpl<$Res, $Val extends FamilyProfile>
    implements $FamilyProfileCopyWith<$Res> {
  _$FamilyProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? members = null,
    Object? organizer = null,
    Object? receiptEmail = null,
    Object? paymentMethod = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<FamilyMember>,
      organizer: null == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String,
      receiptEmail: null == receiptEmail
          ? _value.receiptEmail
          : receiptEmail // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyProfileImplCopyWith<$Res>
    implements $FamilyProfileCopyWith<$Res> {
  factory _$$FamilyProfileImplCopyWith(
          _$FamilyProfileImpl value, $Res Function(_$FamilyProfileImpl) then) =
      __$$FamilyProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<FamilyMember> members,
      String organizer,
      String receiptEmail,
      String paymentMethod});
}

/// @nodoc
class __$$FamilyProfileImplCopyWithImpl<$Res>
    extends _$FamilyProfileCopyWithImpl<$Res, _$FamilyProfileImpl>
    implements _$$FamilyProfileImplCopyWith<$Res> {
  __$$FamilyProfileImplCopyWithImpl(
      _$FamilyProfileImpl _value, $Res Function(_$FamilyProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? members = null,
    Object? organizer = null,
    Object? receiptEmail = null,
    Object? paymentMethod = null,
  }) {
    return _then(_$FamilyProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<FamilyMember>,
      organizer: null == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String,
      receiptEmail: null == receiptEmail
          ? _value.receiptEmail
          : receiptEmail // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyProfileImpl implements _FamilyProfile {
  const _$FamilyProfileImpl(
      {required this.id,
      required final List<FamilyMember> members,
      required this.organizer,
      required this.receiptEmail,
      required this.paymentMethod})
      : _members = members;

  factory _$FamilyProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyProfileImplFromJson(json);

  @override
  final String id;
  final List<FamilyMember> _members;
  @override
  List<FamilyMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final String organizer;
  @override
  final String receiptEmail;
  @override
  final String paymentMethod;

  @override
  String toString() {
    return 'FamilyProfile(id: $id, members: $members, organizer: $organizer, receiptEmail: $receiptEmail, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            (identical(other.receiptEmail, receiptEmail) ||
                other.receiptEmail == receiptEmail) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_members),
      organizer,
      receiptEmail,
      paymentMethod);

  /// Create a copy of FamilyProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyProfileImplCopyWith<_$FamilyProfileImpl> get copyWith =>
      __$$FamilyProfileImplCopyWithImpl<_$FamilyProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyProfileImplToJson(
      this,
    );
  }
}

abstract class _FamilyProfile implements FamilyProfile {
  const factory _FamilyProfile(
      {required final String id,
      required final List<FamilyMember> members,
      required final String organizer,
      required final String receiptEmail,
      required final String paymentMethod}) = _$FamilyProfileImpl;

  factory _FamilyProfile.fromJson(Map<String, dynamic> json) =
      _$FamilyProfileImpl.fromJson;

  @override
  String get id;
  @override
  List<FamilyMember> get members;
  @override
  String get organizer;
  @override
  String get receiptEmail;
  @override
  String get paymentMethod;

  /// Create a copy of FamilyProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyProfileImplCopyWith<_$FamilyProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyMemberInvite _$FamilyMemberInviteFromJson(Map<String, dynamic> json) {
  return _FamilyMemberInvite.fromJson(json);
}

/// @nodoc
mixin _$FamilyMemberInvite {
  String get id => throw _privateConstructorUsedError;
  String? get familyProfileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get dob => throw _privateConstructorUsedError;

  /// Serializes this FamilyMemberInvite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyMemberInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyMemberInviteCopyWith<FamilyMemberInvite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyMemberInviteCopyWith<$Res> {
  factory $FamilyMemberInviteCopyWith(
          FamilyMemberInvite value, $Res Function(FamilyMemberInvite) then) =
      _$FamilyMemberInviteCopyWithImpl<$Res, FamilyMemberInvite>;
  @useResult
  $Res call({String id, String? familyProfileId, String name, DateTime dob});
}

/// @nodoc
class _$FamilyMemberInviteCopyWithImpl<$Res, $Val extends FamilyMemberInvite>
    implements $FamilyMemberInviteCopyWith<$Res> {
  _$FamilyMemberInviteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyMemberInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyProfileId = freezed,
    Object? name = null,
    Object? dob = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      familyProfileId: freezed == familyProfileId
          ? _value.familyProfileId
          : familyProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyMemberInviteImplCopyWith<$Res>
    implements $FamilyMemberInviteCopyWith<$Res> {
  factory _$$FamilyMemberInviteImplCopyWith(_$FamilyMemberInviteImpl value,
          $Res Function(_$FamilyMemberInviteImpl) then) =
      __$$FamilyMemberInviteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? familyProfileId, String name, DateTime dob});
}

/// @nodoc
class __$$FamilyMemberInviteImplCopyWithImpl<$Res>
    extends _$FamilyMemberInviteCopyWithImpl<$Res, _$FamilyMemberInviteImpl>
    implements _$$FamilyMemberInviteImplCopyWith<$Res> {
  __$$FamilyMemberInviteImplCopyWithImpl(_$FamilyMemberInviteImpl _value,
      $Res Function(_$FamilyMemberInviteImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyMemberInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyProfileId = freezed,
    Object? name = null,
    Object? dob = null,
  }) {
    return _then(_$FamilyMemberInviteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      familyProfileId: freezed == familyProfileId
          ? _value.familyProfileId
          : familyProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyMemberInviteImpl implements _FamilyMemberInvite {
  const _$FamilyMemberInviteImpl(
      {required this.id,
      required this.familyProfileId,
      required this.name,
      required this.dob});

  factory _$FamilyMemberInviteImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyMemberInviteImplFromJson(json);

  @override
  final String id;
  @override
  final String? familyProfileId;
  @override
  final String name;
  @override
  final DateTime dob;

  @override
  String toString() {
    return 'FamilyMemberInvite(id: $id, familyProfileId: $familyProfileId, name: $name, dob: $dob)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyMemberInviteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.familyProfileId, familyProfileId) ||
                other.familyProfileId == familyProfileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dob, dob) || other.dob == dob));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, familyProfileId, name, dob);

  /// Create a copy of FamilyMemberInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyMemberInviteImplCopyWith<_$FamilyMemberInviteImpl> get copyWith =>
      __$$FamilyMemberInviteImplCopyWithImpl<_$FamilyMemberInviteImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyMemberInviteImplToJson(
      this,
    );
  }
}

abstract class _FamilyMemberInvite implements FamilyMemberInvite {
  const factory _FamilyMemberInvite(
      {required final String id,
      required final String? familyProfileId,
      required final String name,
      required final DateTime dob}) = _$FamilyMemberInviteImpl;

  factory _FamilyMemberInvite.fromJson(Map<String, dynamic> json) =
      _$FamilyMemberInviteImpl.fromJson;

  @override
  String get id;
  @override
  String? get familyProfileId;
  @override
  String get name;
  @override
  DateTime get dob;

  /// Create a copy of FamilyMemberInvite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyMemberInviteImplCopyWith<_$FamilyMemberInviteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) {
  return _FamilyMember.fromJson(json);
}

/// @nodoc
mixin _$FamilyMember {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get dob => throw _privateConstructorUsedError;

  /// Serializes this FamilyMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyMemberCopyWith<FamilyMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyMemberCopyWith<$Res> {
  factory $FamilyMemberCopyWith(
          FamilyMember value, $Res Function(FamilyMember) then) =
      _$FamilyMemberCopyWithImpl<$Res, FamilyMember>;
  @useResult
  $Res call({String id, String name, DateTime dob});
}

/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res, $Val extends FamilyMember>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dob = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyMemberImplCopyWith<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  factory _$$FamilyMemberImplCopyWith(
          _$FamilyMemberImpl value, $Res Function(_$FamilyMemberImpl) then) =
      __$$FamilyMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, DateTime dob});
}

/// @nodoc
class __$$FamilyMemberImplCopyWithImpl<$Res>
    extends _$FamilyMemberCopyWithImpl<$Res, _$FamilyMemberImpl>
    implements _$$FamilyMemberImplCopyWith<$Res> {
  __$$FamilyMemberImplCopyWithImpl(
      _$FamilyMemberImpl _value, $Res Function(_$FamilyMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dob = null,
  }) {
    return _then(_$FamilyMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyMemberImpl implements _FamilyMember {
  const _$FamilyMemberImpl(
      {required this.id, required this.name, required this.dob});

  factory _$FamilyMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime dob;

  @override
  String toString() {
    return 'FamilyMember(id: $id, name: $name, dob: $dob)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dob, dob) || other.dob == dob));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, dob);

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      __$$FamilyMemberImplCopyWithImpl<_$FamilyMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyMemberImplToJson(
      this,
    );
  }
}

abstract class _FamilyMember implements FamilyMember {
  const factory _FamilyMember(
      {required final String id,
      required final String name,
      required final DateTime dob}) = _$FamilyMemberImpl;

  factory _FamilyMember.fromJson(Map<String, dynamic> json) =
      _$FamilyMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get dob;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
