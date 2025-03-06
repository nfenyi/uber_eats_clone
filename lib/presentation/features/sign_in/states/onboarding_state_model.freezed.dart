// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddressDetails _$AddressDetailsFromJson(Map<String, dynamic> json) {
  return _AddressDetails.fromJson(json);
}

/// @nodoc
mixin _$AddressDetails {
  String get instruction => throw _privateConstructorUsedError;
  String get apartment => throw _privateConstructorUsedError;
  @GeoPointConverter()
  GeoPoint get latlng => throw _privateConstructorUsedError;
  String get addressLabel => throw _privateConstructorUsedError;
  String get placeDescription => throw _privateConstructorUsedError;
  String get building => throw _privateConstructorUsedError;
  String get dropoffOption => throw _privateConstructorUsedError;

  /// Serializes this AddressDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressDetailsCopyWith<AddressDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressDetailsCopyWith<$Res> {
  factory $AddressDetailsCopyWith(
          AddressDetails value, $Res Function(AddressDetails) then) =
      _$AddressDetailsCopyWithImpl<$Res, AddressDetails>;
  @useResult
  $Res call(
      {String instruction,
      String apartment,
      @GeoPointConverter() GeoPoint latlng,
      String addressLabel,
      String placeDescription,
      String building,
      String dropoffOption});
}

/// @nodoc
class _$AddressDetailsCopyWithImpl<$Res, $Val extends AddressDetails>
    implements $AddressDetailsCopyWith<$Res> {
  _$AddressDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instruction = null,
    Object? apartment = null,
    Object? latlng = null,
    Object? addressLabel = null,
    Object? placeDescription = null,
    Object? building = null,
    Object? dropoffOption = null,
  }) {
    return _then(_value.copyWith(
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      apartment: null == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String,
      latlng: null == latlng
          ? _value.latlng
          : latlng // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      addressLabel: null == addressLabel
          ? _value.addressLabel
          : addressLabel // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      building: null == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String,
      dropoffOption: null == dropoffOption
          ? _value.dropoffOption
          : dropoffOption // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressDetailsImplCopyWith<$Res>
    implements $AddressDetailsCopyWith<$Res> {
  factory _$$AddressDetailsImplCopyWith(_$AddressDetailsImpl value,
          $Res Function(_$AddressDetailsImpl) then) =
      __$$AddressDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String instruction,
      String apartment,
      @GeoPointConverter() GeoPoint latlng,
      String addressLabel,
      String placeDescription,
      String building,
      String dropoffOption});
}

/// @nodoc
class __$$AddressDetailsImplCopyWithImpl<$Res>
    extends _$AddressDetailsCopyWithImpl<$Res, _$AddressDetailsImpl>
    implements _$$AddressDetailsImplCopyWith<$Res> {
  __$$AddressDetailsImplCopyWithImpl(
      _$AddressDetailsImpl _value, $Res Function(_$AddressDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instruction = null,
    Object? apartment = null,
    Object? latlng = null,
    Object? addressLabel = null,
    Object? placeDescription = null,
    Object? building = null,
    Object? dropoffOption = null,
  }) {
    return _then(_$AddressDetailsImpl(
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      apartment: null == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String,
      latlng: null == latlng
          ? _value.latlng
          : latlng // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      addressLabel: null == addressLabel
          ? _value.addressLabel
          : addressLabel // ignore: cast_nullable_to_non_nullable
              as String,
      placeDescription: null == placeDescription
          ? _value.placeDescription
          : placeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      building: null == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String,
      dropoffOption: null == dropoffOption
          ? _value.dropoffOption
          : dropoffOption // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressDetailsImpl
    with DiagnosticableTreeMixin
    implements _AddressDetails {
  const _$AddressDetailsImpl(
      {required this.instruction,
      required this.apartment,
      @GeoPointConverter() required this.latlng,
      required this.addressLabel,
      required this.placeDescription,
      required this.building,
      required this.dropoffOption});

  factory _$AddressDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressDetailsImplFromJson(json);

  @override
  final String instruction;
  @override
  final String apartment;
  @override
  @GeoPointConverter()
  final GeoPoint latlng;
  @override
  final String addressLabel;
  @override
  final String placeDescription;
  @override
  final String building;
  @override
  final String dropoffOption;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AddressDetails(instruction: $instruction, apartment: $apartment, latlng: $latlng, addressLabel: $addressLabel, placeDescription: $placeDescription, building: $building, dropoffOption: $dropoffOption)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AddressDetails'))
      ..add(DiagnosticsProperty('instruction', instruction))
      ..add(DiagnosticsProperty('apartment', apartment))
      ..add(DiagnosticsProperty('latlng', latlng))
      ..add(DiagnosticsProperty('addressLabel', addressLabel))
      ..add(DiagnosticsProperty('placeDescription', placeDescription))
      ..add(DiagnosticsProperty('building', building))
      ..add(DiagnosticsProperty('dropoffOption', dropoffOption));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressDetailsImpl &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            (identical(other.apartment, apartment) ||
                other.apartment == apartment) &&
            (identical(other.latlng, latlng) || other.latlng == latlng) &&
            (identical(other.addressLabel, addressLabel) ||
                other.addressLabel == addressLabel) &&
            (identical(other.placeDescription, placeDescription) ||
                other.placeDescription == placeDescription) &&
            (identical(other.building, building) ||
                other.building == building) &&
            (identical(other.dropoffOption, dropoffOption) ||
                other.dropoffOption == dropoffOption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, instruction, apartment, latlng,
      addressLabel, placeDescription, building, dropoffOption);

  /// Create a copy of AddressDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressDetailsImplCopyWith<_$AddressDetailsImpl> get copyWith =>
      __$$AddressDetailsImplCopyWithImpl<_$AddressDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressDetailsImplToJson(
      this,
    );
  }
}

abstract class _AddressDetails implements AddressDetails {
  const factory _AddressDetails(
      {required final String instruction,
      required final String apartment,
      @GeoPointConverter() required final GeoPoint latlng,
      required final String addressLabel,
      required final String placeDescription,
      required final String building,
      required final String dropoffOption}) = _$AddressDetailsImpl;

  factory _AddressDetails.fromJson(Map<String, dynamic> json) =
      _$AddressDetailsImpl.fromJson;

  @override
  String get instruction;
  @override
  String get apartment;
  @override
  @GeoPointConverter()
  GeoPoint get latlng;
  @override
  String get addressLabel;
  @override
  String get placeDescription;
  @override
  String get building;
  @override
  String get dropoffOption;

  /// Create a copy of AddressDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressDetailsImplCopyWith<_$AddressDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
