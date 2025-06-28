// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) {
  return _UserDetails.fromJson(json);
}

/// @nodoc
mixin _$UserDetails {
  List<UserAddress> get addresses => throw _privateConstructorUsedError;
  UberCash? get uberCash => throw _privateConstructorUsedError;
  UserAddress? get selectedAddresses => throw _privateConstructorUsedError;
  List<String> get businessProfileIds => throw _privateConstructorUsedError;
  List<String> get groupOrders => throw _privateConstructorUsedError;
  List<String> get redeemedPromos => throw _privateConstructorUsedError;
  List<String> get redeemedVouchers => throw _privateConstructorUsedError;
  List<String> get usedPromos => throw _privateConstructorUsedError;
  List<String> get usedVouchers => throw _privateConstructorUsedError;
  dynamic get displayName => throw _privateConstructorUsedError;
  dynamic get hasUberOne => throw _privateConstructorUsedError;
  dynamic get onboarded => throw _privateConstructorUsedError;
  String? get selectedBusinessProfileId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get familyProfile => throw _privateConstructorUsedError;
  UberOneStatus? get uberOneStatus => throw _privateConstructorUsedError;

  /// Serializes this UserDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDetailsCopyWith<UserDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDetailsCopyWith<$Res> {
  factory $UserDetailsCopyWith(
          UserDetails value, $Res Function(UserDetails) then) =
      _$UserDetailsCopyWithImpl<$Res, UserDetails>;
  @useResult
  $Res call(
      {List<UserAddress> addresses,
      UberCash? uberCash,
      UserAddress? selectedAddresses,
      List<String> businessProfileIds,
      List<String> groupOrders,
      List<String> redeemedPromos,
      List<String> redeemedVouchers,
      List<String> usedPromos,
      List<String> usedVouchers,
      dynamic displayName,
      dynamic hasUberOne,
      dynamic onboarded,
      String? selectedBusinessProfileId,
      String type,
      String? familyProfile,
      UberOneStatus? uberOneStatus});

  $UberCashCopyWith<$Res>? get uberCash;
  $UserAddressCopyWith<$Res>? get selectedAddresses;
  $UberOneStatusCopyWith<$Res>? get uberOneStatus;
}

/// @nodoc
class _$UserDetailsCopyWithImpl<$Res, $Val extends UserDetails>
    implements $UserDetailsCopyWith<$Res> {
  _$UserDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addresses = null,
    Object? uberCash = freezed,
    Object? selectedAddresses = freezed,
    Object? businessProfileIds = null,
    Object? groupOrders = null,
    Object? redeemedPromos = null,
    Object? redeemedVouchers = null,
    Object? usedPromos = null,
    Object? usedVouchers = null,
    Object? displayName = freezed,
    Object? hasUberOne = freezed,
    Object? onboarded = freezed,
    Object? selectedBusinessProfileId = freezed,
    Object? type = null,
    Object? familyProfile = freezed,
    Object? uberOneStatus = freezed,
  }) {
    return _then(_value.copyWith(
      addresses: null == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<UserAddress>,
      uberCash: freezed == uberCash
          ? _value.uberCash
          : uberCash // ignore: cast_nullable_to_non_nullable
              as UberCash?,
      selectedAddresses: freezed == selectedAddresses
          ? _value.selectedAddresses
          : selectedAddresses // ignore: cast_nullable_to_non_nullable
              as UserAddress?,
      businessProfileIds: null == businessProfileIds
          ? _value.businessProfileIds
          : businessProfileIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      groupOrders: null == groupOrders
          ? _value.groupOrders
          : groupOrders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      redeemedPromos: null == redeemedPromos
          ? _value.redeemedPromos
          : redeemedPromos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      redeemedVouchers: null == redeemedVouchers
          ? _value.redeemedVouchers
          : redeemedVouchers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usedPromos: null == usedPromos
          ? _value.usedPromos
          : usedPromos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usedVouchers: null == usedVouchers
          ? _value.usedVouchers
          : usedVouchers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as dynamic,
      hasUberOne: freezed == hasUberOne
          ? _value.hasUberOne
          : hasUberOne // ignore: cast_nullable_to_non_nullable
              as dynamic,
      onboarded: freezed == onboarded
          ? _value.onboarded
          : onboarded // ignore: cast_nullable_to_non_nullable
              as dynamic,
      selectedBusinessProfileId: freezed == selectedBusinessProfileId
          ? _value.selectedBusinessProfileId
          : selectedBusinessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      familyProfile: freezed == familyProfile
          ? _value.familyProfile
          : familyProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      uberOneStatus: freezed == uberOneStatus
          ? _value.uberOneStatus
          : uberOneStatus // ignore: cast_nullable_to_non_nullable
              as UberOneStatus?,
    ) as $Val);
  }

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UberCashCopyWith<$Res>? get uberCash {
    if (_value.uberCash == null) {
      return null;
    }

    return $UberCashCopyWith<$Res>(_value.uberCash!, (value) {
      return _then(_value.copyWith(uberCash: value) as $Val);
    });
  }

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserAddressCopyWith<$Res>? get selectedAddresses {
    if (_value.selectedAddresses == null) {
      return null;
    }

    return $UserAddressCopyWith<$Res>(_value.selectedAddresses!, (value) {
      return _then(_value.copyWith(selectedAddresses: value) as $Val);
    });
  }

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UberOneStatusCopyWith<$Res>? get uberOneStatus {
    if (_value.uberOneStatus == null) {
      return null;
    }

    return $UberOneStatusCopyWith<$Res>(_value.uberOneStatus!, (value) {
      return _then(_value.copyWith(uberOneStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserDetailsImplCopyWith<$Res>
    implements $UserDetailsCopyWith<$Res> {
  factory _$$UserDetailsImplCopyWith(
          _$UserDetailsImpl value, $Res Function(_$UserDetailsImpl) then) =
      __$$UserDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserAddress> addresses,
      UberCash? uberCash,
      UserAddress? selectedAddresses,
      List<String> businessProfileIds,
      List<String> groupOrders,
      List<String> redeemedPromos,
      List<String> redeemedVouchers,
      List<String> usedPromos,
      List<String> usedVouchers,
      dynamic displayName,
      dynamic hasUberOne,
      dynamic onboarded,
      String? selectedBusinessProfileId,
      String type,
      String? familyProfile,
      UberOneStatus? uberOneStatus});

  @override
  $UberCashCopyWith<$Res>? get uberCash;
  @override
  $UserAddressCopyWith<$Res>? get selectedAddresses;
  @override
  $UberOneStatusCopyWith<$Res>? get uberOneStatus;
}

/// @nodoc
class __$$UserDetailsImplCopyWithImpl<$Res>
    extends _$UserDetailsCopyWithImpl<$Res, _$UserDetailsImpl>
    implements _$$UserDetailsImplCopyWith<$Res> {
  __$$UserDetailsImplCopyWithImpl(
      _$UserDetailsImpl _value, $Res Function(_$UserDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addresses = null,
    Object? uberCash = freezed,
    Object? selectedAddresses = freezed,
    Object? businessProfileIds = null,
    Object? groupOrders = null,
    Object? redeemedPromos = null,
    Object? redeemedVouchers = null,
    Object? usedPromos = null,
    Object? usedVouchers = null,
    Object? displayName = freezed,
    Object? hasUberOne = freezed,
    Object? onboarded = freezed,
    Object? selectedBusinessProfileId = freezed,
    Object? type = null,
    Object? familyProfile = freezed,
    Object? uberOneStatus = freezed,
  }) {
    return _then(_$UserDetailsImpl(
      addresses: null == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<UserAddress>,
      uberCash: freezed == uberCash
          ? _value.uberCash
          : uberCash // ignore: cast_nullable_to_non_nullable
              as UberCash?,
      selectedAddresses: freezed == selectedAddresses
          ? _value.selectedAddresses
          : selectedAddresses // ignore: cast_nullable_to_non_nullable
              as UserAddress?,
      businessProfileIds: null == businessProfileIds
          ? _value._businessProfileIds
          : businessProfileIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      groupOrders: null == groupOrders
          ? _value._groupOrders
          : groupOrders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      redeemedPromos: null == redeemedPromos
          ? _value._redeemedPromos
          : redeemedPromos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      redeemedVouchers: null == redeemedVouchers
          ? _value._redeemedVouchers
          : redeemedVouchers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usedPromos: null == usedPromos
          ? _value._usedPromos
          : usedPromos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usedVouchers: null == usedVouchers
          ? _value._usedVouchers
          : usedVouchers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      displayName: freezed == displayName ? _value.displayName! : displayName,
      hasUberOne: freezed == hasUberOne ? _value.hasUberOne! : hasUberOne,
      onboarded: freezed == onboarded ? _value.onboarded! : onboarded,
      selectedBusinessProfileId: freezed == selectedBusinessProfileId
          ? _value.selectedBusinessProfileId
          : selectedBusinessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      familyProfile: freezed == familyProfile
          ? _value.familyProfile
          : familyProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      uberOneStatus: freezed == uberOneStatus
          ? _value.uberOneStatus
          : uberOneStatus // ignore: cast_nullable_to_non_nullable
              as UberOneStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDetailsImpl with DiagnosticableTreeMixin implements _UserDetails {
  _$UserDetailsImpl(
      {final List<UserAddress> addresses = const [],
      this.uberCash,
      this.selectedAddresses,
      final List<String> businessProfileIds = const [],
      final List<String> groupOrders = const [],
      final List<String> redeemedPromos = const [],
      final List<String> redeemedVouchers = const [],
      final List<String> usedPromos = const [],
      final List<String> usedVouchers = const [],
      this.displayName = OtherConstants.na,
      this.hasUberOne = false,
      this.onboarded = false,
      this.selectedBusinessProfileId,
      this.type = 'Personal',
      this.familyProfile,
      this.uberOneStatus})
      : _addresses = addresses,
        _businessProfileIds = businessProfileIds,
        _groupOrders = groupOrders,
        _redeemedPromos = redeemedPromos,
        _redeemedVouchers = redeemedVouchers,
        _usedPromos = usedPromos,
        _usedVouchers = usedVouchers;

  factory _$UserDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDetailsImplFromJson(json);

  final List<UserAddress> _addresses;
  @override
  @JsonKey()
  List<UserAddress> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  final UberCash? uberCash;
  @override
  final UserAddress? selectedAddresses;
  final List<String> _businessProfileIds;
  @override
  @JsonKey()
  List<String> get businessProfileIds {
    if (_businessProfileIds is EqualUnmodifiableListView)
      return _businessProfileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_businessProfileIds);
  }

  final List<String> _groupOrders;
  @override
  @JsonKey()
  List<String> get groupOrders {
    if (_groupOrders is EqualUnmodifiableListView) return _groupOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupOrders);
  }

  final List<String> _redeemedPromos;
  @override
  @JsonKey()
  List<String> get redeemedPromos {
    if (_redeemedPromos is EqualUnmodifiableListView) return _redeemedPromos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_redeemedPromos);
  }

  final List<String> _redeemedVouchers;
  @override
  @JsonKey()
  List<String> get redeemedVouchers {
    if (_redeemedVouchers is EqualUnmodifiableListView)
      return _redeemedVouchers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_redeemedVouchers);
  }

  final List<String> _usedPromos;
  @override
  @JsonKey()
  List<String> get usedPromos {
    if (_usedPromos is EqualUnmodifiableListView) return _usedPromos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usedPromos);
  }

  final List<String> _usedVouchers;
  @override
  @JsonKey()
  List<String> get usedVouchers {
    if (_usedVouchers is EqualUnmodifiableListView) return _usedVouchers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usedVouchers);
  }

  @override
  @JsonKey()
  final dynamic displayName;
  @override
  @JsonKey()
  final dynamic hasUberOne;
  @override
  @JsonKey()
  final dynamic onboarded;
  @override
  final String? selectedBusinessProfileId;
  @override
  @JsonKey()
  final String type;
  @override
  final String? familyProfile;
  @override
  final UberOneStatus? uberOneStatus;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserDetails(addresses: $addresses, uberCash: $uberCash, selectedAddresses: $selectedAddresses, businessProfileIds: $businessProfileIds, groupOrders: $groupOrders, redeemedPromos: $redeemedPromos, redeemedVouchers: $redeemedVouchers, usedPromos: $usedPromos, usedVouchers: $usedVouchers, displayName: $displayName, hasUberOne: $hasUberOne, onboarded: $onboarded, selectedBusinessProfileId: $selectedBusinessProfileId, type: $type, familyProfile: $familyProfile, uberOneStatus: $uberOneStatus)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserDetails'))
      ..add(DiagnosticsProperty('addresses', addresses))
      ..add(DiagnosticsProperty('uberCash', uberCash))
      ..add(DiagnosticsProperty('selectedAddresses', selectedAddresses))
      ..add(DiagnosticsProperty('businessProfileIds', businessProfileIds))
      ..add(DiagnosticsProperty('groupOrders', groupOrders))
      ..add(DiagnosticsProperty('redeemedPromos', redeemedPromos))
      ..add(DiagnosticsProperty('redeemedVouchers', redeemedVouchers))
      ..add(DiagnosticsProperty('usedPromos', usedPromos))
      ..add(DiagnosticsProperty('usedVouchers', usedVouchers))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('hasUberOne', hasUberOne))
      ..add(DiagnosticsProperty('onboarded', onboarded))
      ..add(DiagnosticsProperty(
          'selectedBusinessProfileId', selectedBusinessProfileId))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('familyProfile', familyProfile))
      ..add(DiagnosticsProperty('uberOneStatus', uberOneStatus));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDetailsImpl &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
            (identical(other.uberCash, uberCash) ||
                other.uberCash == uberCash) &&
            (identical(other.selectedAddresses, selectedAddresses) ||
                other.selectedAddresses == selectedAddresses) &&
            const DeepCollectionEquality()
                .equals(other._businessProfileIds, _businessProfileIds) &&
            const DeepCollectionEquality()
                .equals(other._groupOrders, _groupOrders) &&
            const DeepCollectionEquality()
                .equals(other._redeemedPromos, _redeemedPromos) &&
            const DeepCollectionEquality()
                .equals(other._redeemedVouchers, _redeemedVouchers) &&
            const DeepCollectionEquality()
                .equals(other._usedPromos, _usedPromos) &&
            const DeepCollectionEquality()
                .equals(other._usedVouchers, _usedVouchers) &&
            const DeepCollectionEquality()
                .equals(other.displayName, displayName) &&
            const DeepCollectionEquality()
                .equals(other.hasUberOne, hasUberOne) &&
            const DeepCollectionEquality().equals(other.onboarded, onboarded) &&
            (identical(other.selectedBusinessProfileId,
                    selectedBusinessProfileId) ||
                other.selectedBusinessProfileId == selectedBusinessProfileId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.familyProfile, familyProfile) ||
                other.familyProfile == familyProfile) &&
            (identical(other.uberOneStatus, uberOneStatus) ||
                other.uberOneStatus == uberOneStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_addresses),
      uberCash,
      selectedAddresses,
      const DeepCollectionEquality().hash(_businessProfileIds),
      const DeepCollectionEquality().hash(_groupOrders),
      const DeepCollectionEquality().hash(_redeemedPromos),
      const DeepCollectionEquality().hash(_redeemedVouchers),
      const DeepCollectionEquality().hash(_usedPromos),
      const DeepCollectionEquality().hash(_usedVouchers),
      const DeepCollectionEquality().hash(displayName),
      const DeepCollectionEquality().hash(hasUberOne),
      const DeepCollectionEquality().hash(onboarded),
      selectedBusinessProfileId,
      type,
      familyProfile,
      uberOneStatus);

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDetailsImplCopyWith<_$UserDetailsImpl> get copyWith =>
      __$$UserDetailsImplCopyWithImpl<_$UserDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDetailsImplToJson(
      this,
    );
  }
}

abstract class _UserDetails implements UserDetails {
  factory _UserDetails(
      {final List<UserAddress> addresses,
      final UberCash? uberCash,
      final UserAddress? selectedAddresses,
      final List<String> businessProfileIds,
      final List<String> groupOrders,
      final List<String> redeemedPromos,
      final List<String> redeemedVouchers,
      final List<String> usedPromos,
      final List<String> usedVouchers,
      final dynamic displayName,
      final dynamic hasUberOne,
      final dynamic onboarded,
      final String? selectedBusinessProfileId,
      final String type,
      final String? familyProfile,
      final UberOneStatus? uberOneStatus}) = _$UserDetailsImpl;

  factory _UserDetails.fromJson(Map<String, dynamic> json) =
      _$UserDetailsImpl.fromJson;

  @override
  List<UserAddress> get addresses;
  @override
  UberCash? get uberCash;
  @override
  UserAddress? get selectedAddresses;
  @override
  List<String> get businessProfileIds;
  @override
  List<String> get groupOrders;
  @override
  List<String> get redeemedPromos;
  @override
  List<String> get redeemedVouchers;
  @override
  List<String> get usedPromos;
  @override
  List<String> get usedVouchers;
  @override
  dynamic get displayName;
  @override
  dynamic get hasUberOne;
  @override
  dynamic get onboarded;
  @override
  String? get selectedBusinessProfileId;
  @override
  String get type;
  @override
  String? get familyProfile;
  @override
  UberOneStatus? get uberOneStatus;

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDetailsImplCopyWith<_$UserDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) {
  return _UserAddress.fromJson(json);
}

/// @nodoc
mixin _$UserAddress {
  String get apartment => throw _privateConstructorUsedError;
  String get building => throw _privateConstructorUsedError;
  String get dropoffOption => throw _privateConstructorUsedError;
  String get instruction => throw _privateConstructorUsedError;
  String get placeDescription => throw _privateConstructorUsedError;
  Object get latlng => throw _privateConstructorUsedError;

  /// Serializes this UserAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserAddressCopyWith<UserAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAddressCopyWith<$Res> {
  factory $UserAddressCopyWith(
          UserAddress value, $Res Function(UserAddress) then) =
      _$UserAddressCopyWithImpl<$Res, UserAddress>;
  @useResult
  $Res call(
      {String apartment,
      String building,
      String dropoffOption,
      String instruction,
      String placeDescription,
      Object latlng});
}

/// @nodoc
class _$UserAddressCopyWithImpl<$Res, $Val extends UserAddress>
    implements $UserAddressCopyWith<$Res> {
  _$UserAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apartment = null,
    Object? building = null,
    Object? dropoffOption = null,
    Object? instruction = null,
    Object? placeDescription = null,
    Object? latlng = null,
  }) {
    return _then(_value.copyWith(
      apartment: null == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String,
      building: null == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String,
      dropoffOption: null == dropoffOption
          ? _value.dropoffOption
          : dropoffOption // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      latlng: null == latlng ? _value.latlng : latlng,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAddressImplCopyWith<$Res>
    implements $UserAddressCopyWith<$Res> {
  factory _$$UserAddressImplCopyWith(
          _$UserAddressImpl value, $Res Function(_$UserAddressImpl) then) =
      __$$UserAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String apartment,
      String building,
      String dropoffOption,
      String instruction,
      String placeDescription,
      Object latlng});
}

/// @nodoc
class __$$UserAddressImplCopyWithImpl<$Res>
    extends _$UserAddressCopyWithImpl<$Res, _$UserAddressImpl>
    implements _$$UserAddressImplCopyWith<$Res> {
  __$$UserAddressImplCopyWithImpl(
      _$UserAddressImpl _value, $Res Function(_$UserAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apartment = null,
    Object? building = null,
    Object? dropoffOption = null,
    Object? instruction = null,
    Object? placeDescription = null,
    Object? latlng = null,
  }) {
    return _then(_$UserAddressImpl(
      apartment: null == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String,
      building: null == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String,
      dropoffOption: null == dropoffOption
          ? _value.dropoffOption
          : dropoffOption // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      latlng: null == latlng ? _value.latlng : latlng,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAddressImpl with DiagnosticableTreeMixin implements _UserAddress {
  _$UserAddressImpl(
      {this.apartment = OtherConstants.na,
      this.building = OtherConstants.na,
      this.dropoffOption = OtherConstants.na,
      this.instruction = OtherConstants.na,
      this.placeDescription = OtherConstants.na,
      this.latlng = const GeoPoint(0, 0)});

  factory _$UserAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAddressImplFromJson(json);

  @override
  @JsonKey()
  final String apartment;
  @override
  @JsonKey()
  final String building;
  @override
  @JsonKey()
  final String dropoffOption;
  @override
  @JsonKey()
  final String instruction;
  @override
  @JsonKey()
  final String placeDescription;
  @override
  @JsonKey()
  final Object latlng;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserAddress(apartment: $apartment, building: $building, dropoffOption: $dropoffOption, instruction: $instruction, placeDescription: $placeDescription, latlng: $latlng)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserAddress'))
      ..add(DiagnosticsProperty('apartment', apartment))
      ..add(DiagnosticsProperty('building', building))
      ..add(DiagnosticsProperty('dropoffOption', dropoffOption))
      ..add(DiagnosticsProperty('instruction', instruction))
      ..add(DiagnosticsProperty('placeDescription', placeDescription))
      ..add(DiagnosticsProperty('latlng', latlng));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAddressImpl &&
            (identical(other.apartment, apartment) ||
                other.apartment == apartment) &&
            (identical(other.building, building) ||
                other.building == building) &&
            (identical(other.dropoffOption, dropoffOption) ||
                other.dropoffOption == dropoffOption) &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            (identical(other.placeDescription, placeDescription) ||
                other.placeDescription == placeDescription) &&
            const DeepCollectionEquality().equals(other.latlng, latlng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      apartment,
      building,
      dropoffOption,
      instruction,
      placeDescription,
      const DeepCollectionEquality().hash(latlng));

  /// Create a copy of UserAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAddressImplCopyWith<_$UserAddressImpl> get copyWith =>
      __$$UserAddressImplCopyWithImpl<_$UserAddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAddressImplToJson(
      this,
    );
  }
}

abstract class _UserAddress implements UserAddress {
  factory _UserAddress(
      {final String apartment,
      final String building,
      final String dropoffOption,
      final String instruction,
      final String placeDescription,
      final Object latlng}) = _$UserAddressImpl;

  factory _UserAddress.fromJson(Map<String, dynamic> json) =
      _$UserAddressImpl.fromJson;

  @override
  String get apartment;
  @override
  String get building;
  @override
  String get dropoffOption;
  @override
  String get instruction;
  @override
  String get placeDescription;
  @override
  Object get latlng;

  /// Create a copy of UserAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserAddressImplCopyWith<_$UserAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UberCash _$UberCashFromJson(Map<String, dynamic> json) {
  return _UberCash.fromJson(json);
}

/// @nodoc
mixin _$UberCash {
  double get balance => throw _privateConstructorUsedError;
  double get cashAdded => throw _privateConstructorUsedError;
  double get cashSpent => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

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
  $Res call(
      {double balance, double cashAdded, double cashSpent, bool isActive});
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
    Object? balance = null,
    Object? cashAdded = null,
    Object? cashSpent = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      cashAdded: null == cashAdded
          ? _value.cashAdded
          : cashAdded // ignore: cast_nullable_to_non_nullable
              as double,
      cashSpent: null == cashSpent
          ? _value.cashSpent
          : cashSpent // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
  $Res call(
      {double balance, double cashAdded, double cashSpent, bool isActive});
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
    Object? balance = null,
    Object? cashAdded = null,
    Object? cashSpent = null,
    Object? isActive = null,
  }) {
    return _then(_$UberCashImpl(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      cashAdded: null == cashAdded
          ? _value.cashAdded
          : cashAdded // ignore: cast_nullable_to_non_nullable
              as double,
      cashSpent: null == cashSpent
          ? _value.cashSpent
          : cashSpent // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UberCashImpl with DiagnosticableTreeMixin implements _UberCash {
  _$UberCashImpl(
      {this.balance = 0,
      this.cashAdded = 0,
      this.cashSpent = 0,
      this.isActive = false});

  factory _$UberCashImpl.fromJson(Map<String, dynamic> json) =>
      _$$UberCashImplFromJson(json);

  @override
  @JsonKey()
  final double balance;
  @override
  @JsonKey()
  final double cashAdded;
  @override
  @JsonKey()
  final double cashSpent;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UberCash(balance: $balance, cashAdded: $cashAdded, cashSpent: $cashSpent, isActive: $isActive)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UberCash'))
      ..add(DiagnosticsProperty('balance', balance))
      ..add(DiagnosticsProperty('cashAdded', cashAdded))
      ..add(DiagnosticsProperty('cashSpent', cashSpent))
      ..add(DiagnosticsProperty('isActive', isActive));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UberCashImpl &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.cashAdded, cashAdded) ||
                other.cashAdded == cashAdded) &&
            (identical(other.cashSpent, cashSpent) ||
                other.cashSpent == cashSpent) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, balance, cashAdded, cashSpent, isActive);

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
  factory _UberCash(
      {final double balance,
      final double cashAdded,
      final double cashSpent,
      final bool isActive}) = _$UberCashImpl;

  factory _UberCash.fromJson(Map<String, dynamic> json) =
      _$UberCashImpl.fromJson;

  @override
  double get balance;
  @override
  double get cashAdded;
  @override
  double get cashSpent;
  @override
  bool get isActive;

  /// Create a copy of UberCash
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UberCashImplCopyWith<_$UberCashImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UberOneStatus _$UberOneStatusFromJson(Map<String, dynamic> json) {
  return _UberOneStatus.fromJson(json);
}

/// @nodoc
mixin _$UberOneStatus {
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  String? get plan => throw _privateConstructorUsedError;
  double get moneySaved => throw _privateConstructorUsedError;
  bool get hasUberOne => throw _privateConstructorUsedError;

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
      {DateTime? expirationDate,
      String? plan,
      double moneySaved,
      bool hasUberOne});
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
    Object? expirationDate = freezed,
    Object? plan = freezed,
    Object? moneySaved = null,
    Object? hasUberOne = null,
  }) {
    return _then(_value.copyWith(
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
      moneySaved: null == moneySaved
          ? _value.moneySaved
          : moneySaved // ignore: cast_nullable_to_non_nullable
              as double,
      hasUberOne: null == hasUberOne
          ? _value.hasUberOne
          : hasUberOne // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {DateTime? expirationDate,
      String? plan,
      double moneySaved,
      bool hasUberOne});
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
    Object? expirationDate = freezed,
    Object? plan = freezed,
    Object? moneySaved = null,
    Object? hasUberOne = null,
  }) {
    return _then(_$UberOneStatusImpl(
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
      moneySaved: null == moneySaved
          ? _value.moneySaved
          : moneySaved // ignore: cast_nullable_to_non_nullable
              as double,
      hasUberOne: null == hasUberOne
          ? _value.hasUberOne
          : hasUberOne // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UberOneStatusImpl
    with DiagnosticableTreeMixin
    implements _UberOneStatus {
  _$UberOneStatusImpl(
      {this.expirationDate,
      this.plan,
      this.moneySaved = 0,
      this.hasUberOne = false});

  factory _$UberOneStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$UberOneStatusImplFromJson(json);

  @override
  final DateTime? expirationDate;
  @override
  final String? plan;
  @override
  @JsonKey()
  final double moneySaved;
  @override
  @JsonKey()
  final bool hasUberOne;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UberOneStatus(expirationDate: $expirationDate, plan: $plan, moneySaved: $moneySaved, hasUberOne: $hasUberOne)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UberOneStatus'))
      ..add(DiagnosticsProperty('expirationDate', expirationDate))
      ..add(DiagnosticsProperty('plan', plan))
      ..add(DiagnosticsProperty('moneySaved', moneySaved))
      ..add(DiagnosticsProperty('hasUberOne', hasUberOne));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UberOneStatusImpl &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.moneySaved, moneySaved) ||
                other.moneySaved == moneySaved) &&
            (identical(other.hasUberOne, hasUberOne) ||
                other.hasUberOne == hasUberOne));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, expirationDate, plan, moneySaved, hasUberOne);

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
      {final DateTime? expirationDate,
      final String? plan,
      final double moneySaved,
      final bool hasUberOne}) = _$UberOneStatusImpl;

  factory _UberOneStatus.fromJson(Map<String, dynamic> json) =
      _$UberOneStatusImpl.fromJson;

  @override
  DateTime? get expirationDate;
  @override
  String? get plan;
  @override
  double get moneySaved;
  @override
  bool get hasUberOne;

  /// Create a copy of UberOneStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UberOneStatusImplCopyWith<_$UberOneStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
