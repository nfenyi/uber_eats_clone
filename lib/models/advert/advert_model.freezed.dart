// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advert_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Advert _$AdvertFromJson(Map<String, dynamic> json) {
  return _Advert.fromJson(json);
}

/// @nodoc
mixin _$Advert {
  String get title => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  List<Object> get products => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this Advert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdvertCopyWith<Advert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdvertCopyWith<$Res> {
  factory $AdvertCopyWith(Advert value, $Res Function(Advert) then) =
      _$AdvertCopyWithImpl<$Res, Advert>;
  @useResult
  $Res call({String title, String shopId, List<Object> products, String type});
}

/// @nodoc
class _$AdvertCopyWithImpl<$Res, $Val extends Advert>
    implements $AdvertCopyWith<$Res> {
  _$AdvertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? shopId = null,
    Object? products = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Object>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdvertImplCopyWith<$Res> implements $AdvertCopyWith<$Res> {
  factory _$$AdvertImplCopyWith(
          _$AdvertImpl value, $Res Function(_$AdvertImpl) then) =
      __$$AdvertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String shopId, List<Object> products, String type});
}

/// @nodoc
class __$$AdvertImplCopyWithImpl<$Res>
    extends _$AdvertCopyWithImpl<$Res, _$AdvertImpl>
    implements _$$AdvertImplCopyWith<$Res> {
  __$$AdvertImplCopyWithImpl(
      _$AdvertImpl _value, $Res Function(_$AdvertImpl) _then)
      : super(_value, _then);

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? shopId = null,
    Object? products = null,
    Object? type = null,
  }) {
    return _then(_$AdvertImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Object>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdvertImpl with DiagnosticableTreeMixin implements _Advert {
  const _$AdvertImpl(
      {required this.title,
      required this.shopId,
      required final List<Object> products,
      required this.type})
      : _products = products;

  factory _$AdvertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdvertImplFromJson(json);

  @override
  final String title;
  @override
  final String shopId;
  final List<Object> _products;
  @override
  List<Object> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final String type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Advert(title: $title, shopId: $shopId, products: $products, type: $type)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Advert'))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('shopId', shopId))
      ..add(DiagnosticsProperty('products', products))
      ..add(DiagnosticsProperty('type', type));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdvertImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, shopId,
      const DeepCollectionEquality().hash(_products), type);

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdvertImplCopyWith<_$AdvertImpl> get copyWith =>
      __$$AdvertImplCopyWithImpl<_$AdvertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdvertImplToJson(
      this,
    );
  }
}

abstract class _Advert implements Advert {
  const factory _Advert(
      {required final String title,
      required final String shopId,
      required final List<Object> products,
      required final String type}) = _$AdvertImpl;

  factory _Advert.fromJson(Map<String, dynamic> json) = _$AdvertImpl.fromJson;

  @override
  String get title;
  @override
  String get shopId;
  @override
  List<Object> get products;
  @override
  String get type;

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdvertImplCopyWith<_$AdvertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
