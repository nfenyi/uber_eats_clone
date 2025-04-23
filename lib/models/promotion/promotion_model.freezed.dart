// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Promotion _$PromotionFromJson(Map<String, dynamic> json) {
  return _Promotion.fromJson(json);
}

/// @nodoc
mixin _$Promotion {
  String get id => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get expirationDate => throw _privateConstructorUsedError;
  String get applicableLocation => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double? get minimumOrder => throw _privateConstructorUsedError;

  /// Serializes this Promotion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Promotion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromotionCopyWith<Promotion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotionCopyWith<$Res> {
  factory $PromotionCopyWith(Promotion value, $Res Function(Promotion) then) =
      _$PromotionCopyWithImpl<$Res, Promotion>;
  @useResult
  $Res call(
      {String id,
      double discount,
      String description,
      DateTime expirationDate,
      String applicableLocation,
      String title,
      double? minimumOrder});
}

/// @nodoc
class _$PromotionCopyWithImpl<$Res, $Val extends Promotion>
    implements $PromotionCopyWith<$Res> {
  _$PromotionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Promotion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? discount = null,
    Object? description = null,
    Object? expirationDate = null,
    Object? applicableLocation = null,
    Object? title = null,
    Object? minimumOrder = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      expirationDate: null == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      applicableLocation: null == applicableLocation
          ? _value.applicableLocation
          : applicableLocation // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      minimumOrder: freezed == minimumOrder
          ? _value.minimumOrder
          : minimumOrder // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromotionImplCopyWith<$Res>
    implements $PromotionCopyWith<$Res> {
  factory _$$PromotionImplCopyWith(
          _$PromotionImpl value, $Res Function(_$PromotionImpl) then) =
      __$$PromotionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double discount,
      String description,
      DateTime expirationDate,
      String applicableLocation,
      String title,
      double? minimumOrder});
}

/// @nodoc
class __$$PromotionImplCopyWithImpl<$Res>
    extends _$PromotionCopyWithImpl<$Res, _$PromotionImpl>
    implements _$$PromotionImplCopyWith<$Res> {
  __$$PromotionImplCopyWithImpl(
      _$PromotionImpl _value, $Res Function(_$PromotionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Promotion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? discount = null,
    Object? description = null,
    Object? expirationDate = null,
    Object? applicableLocation = null,
    Object? title = null,
    Object? minimumOrder = freezed,
  }) {
    return _then(_$PromotionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      expirationDate: null == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      applicableLocation: null == applicableLocation
          ? _value.applicableLocation
          : applicableLocation // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      minimumOrder: freezed == minimumOrder
          ? _value.minimumOrder
          : minimumOrder // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromotionImpl with DiagnosticableTreeMixin implements _Promotion {
  const _$PromotionImpl(
      {required this.id,
      required this.discount,
      required this.description,
      required this.expirationDate,
      required this.applicableLocation,
      required this.title,
      this.minimumOrder});

  factory _$PromotionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromotionImplFromJson(json);

  @override
  final String id;
  @override
  final double discount;
  @override
  final String description;
  @override
  final DateTime expirationDate;
  @override
  final String applicableLocation;
  @override
  final String title;
  @override
  final double? minimumOrder;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Promotion(id: $id, discount: $discount, description: $description, expirationDate: $expirationDate, applicableLocation: $applicableLocation, title: $title, minimumOrder: $minimumOrder)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Promotion'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('discount', discount))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('expirationDate', expirationDate))
      ..add(DiagnosticsProperty('applicableLocation', applicableLocation))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('minimumOrder', minimumOrder));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromotionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.applicableLocation, applicableLocation) ||
                other.applicableLocation == applicableLocation) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.minimumOrder, minimumOrder) ||
                other.minimumOrder == minimumOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, discount, description,
      expirationDate, applicableLocation, title, minimumOrder);

  /// Create a copy of Promotion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotionImplCopyWith<_$PromotionImpl> get copyWith =>
      __$$PromotionImplCopyWithImpl<_$PromotionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromotionImplToJson(
      this,
    );
  }
}

abstract class _Promotion implements Promotion {
  const factory _Promotion(
      {required final String id,
      required final double discount,
      required final String description,
      required final DateTime expirationDate,
      required final String applicableLocation,
      required final String title,
      final double? minimumOrder}) = _$PromotionImpl;

  factory _Promotion.fromJson(Map<String, dynamic> json) =
      _$PromotionImpl.fromJson;

  @override
  String get id;
  @override
  double get discount;
  @override
  String get description;
  @override
  DateTime get expirationDate;
  @override
  String get applicableLocation;
  @override
  String get title;
  @override
  double? get minimumOrder;

  /// Create a copy of Promotion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromotionImplCopyWith<_$PromotionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
