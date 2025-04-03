// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_card_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GiftCardCategory _$GiftCardCategoryFromJson(Map<String, dynamic> json) {
  return _GiftCardCategory.fromJson(json);
}

/// @nodoc
mixin _$GiftCardCategory {
  String get name => throw _privateConstructorUsedError;
  List<Object> get giftCardImages => throw _privateConstructorUsedError;

  /// Serializes this GiftCardCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GiftCardCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GiftCardCategoryCopyWith<GiftCardCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftCardCategoryCopyWith<$Res> {
  factory $GiftCardCategoryCopyWith(
          GiftCardCategory value, $Res Function(GiftCardCategory) then) =
      _$GiftCardCategoryCopyWithImpl<$Res, GiftCardCategory>;
  @useResult
  $Res call({String name, List<Object> giftCardImages});
}

/// @nodoc
class _$GiftCardCategoryCopyWithImpl<$Res, $Val extends GiftCardCategory>
    implements $GiftCardCategoryCopyWith<$Res> {
  _$GiftCardCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GiftCardCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? giftCardImages = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      giftCardImages: null == giftCardImages
          ? _value.giftCardImages
          : giftCardImages // ignore: cast_nullable_to_non_nullable
              as List<Object>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GiftCardCategoryImplCopyWith<$Res>
    implements $GiftCardCategoryCopyWith<$Res> {
  factory _$$GiftCardCategoryImplCopyWith(_$GiftCardCategoryImpl value,
          $Res Function(_$GiftCardCategoryImpl) then) =
      __$$GiftCardCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<Object> giftCardImages});
}

/// @nodoc
class __$$GiftCardCategoryImplCopyWithImpl<$Res>
    extends _$GiftCardCategoryCopyWithImpl<$Res, _$GiftCardCategoryImpl>
    implements _$$GiftCardCategoryImplCopyWith<$Res> {
  __$$GiftCardCategoryImplCopyWithImpl(_$GiftCardCategoryImpl _value,
      $Res Function(_$GiftCardCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of GiftCardCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? giftCardImages = null,
  }) {
    return _then(_$GiftCardCategoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      giftCardImages: null == giftCardImages
          ? _value._giftCardImages
          : giftCardImages // ignore: cast_nullable_to_non_nullable
              as List<Object>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GiftCardCategoryImpl implements _GiftCardCategory {
  const _$GiftCardCategoryImpl(
      {required this.name, final List<Object> giftCardImages = const []})
      : _giftCardImages = giftCardImages;

  factory _$GiftCardCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GiftCardCategoryImplFromJson(json);

  @override
  final String name;
  final List<Object> _giftCardImages;
  @override
  @JsonKey()
  List<Object> get giftCardImages {
    if (_giftCardImages is EqualUnmodifiableListView) return _giftCardImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_giftCardImages);
  }

  @override
  String toString() {
    return 'GiftCardCategory(name: $name, giftCardImages: $giftCardImages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GiftCardCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._giftCardImages, _giftCardImages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_giftCardImages));

  /// Create a copy of GiftCardCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GiftCardCategoryImplCopyWith<_$GiftCardCategoryImpl> get copyWith =>
      __$$GiftCardCategoryImplCopyWithImpl<_$GiftCardCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GiftCardCategoryImplToJson(
      this,
    );
  }
}

abstract class _GiftCardCategory implements GiftCardCategory {
  const factory _GiftCardCategory(
      {required final String name,
      final List<Object> giftCardImages}) = _$GiftCardCategoryImpl;

  factory _GiftCardCategory.fromJson(Map<String, dynamic> json) =
      _$GiftCardCategoryImpl.fromJson;

  @override
  String get name;
  @override
  List<Object> get giftCardImages;

  /// Create a copy of GiftCardCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GiftCardCategoryImplCopyWith<_$GiftCardCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GiftCardImage _$GiftCardImageFromJson(Map<String, dynamic> json) {
  return _GiftCardImage.fromJson(json);
}

/// @nodoc
mixin _$GiftCardImage {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this GiftCardImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GiftCardImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GiftCardImageCopyWith<GiftCardImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftCardImageCopyWith<$Res> {
  factory $GiftCardImageCopyWith(
          GiftCardImage value, $Res Function(GiftCardImage) then) =
      _$GiftCardImageCopyWithImpl<$Res, GiftCardImage>;
  @useResult
  $Res call({String id, String imageUrl});
}

/// @nodoc
class _$GiftCardImageCopyWithImpl<$Res, $Val extends GiftCardImage>
    implements $GiftCardImageCopyWith<$Res> {
  _$GiftCardImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GiftCardImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GiftCardImageImplCopyWith<$Res>
    implements $GiftCardImageCopyWith<$Res> {
  factory _$$GiftCardImageImplCopyWith(
          _$GiftCardImageImpl value, $Res Function(_$GiftCardImageImpl) then) =
      __$$GiftCardImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String imageUrl});
}

/// @nodoc
class __$$GiftCardImageImplCopyWithImpl<$Res>
    extends _$GiftCardImageCopyWithImpl<$Res, _$GiftCardImageImpl>
    implements _$$GiftCardImageImplCopyWith<$Res> {
  __$$GiftCardImageImplCopyWithImpl(
      _$GiftCardImageImpl _value, $Res Function(_$GiftCardImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of GiftCardImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
  }) {
    return _then(_$GiftCardImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GiftCardImageImpl implements _GiftCardImage {
  const _$GiftCardImageImpl({required this.id, required this.imageUrl});

  factory _$GiftCardImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$GiftCardImageImplFromJson(json);

  @override
  final String id;
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'GiftCardImage(id: $id, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GiftCardImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageUrl);

  /// Create a copy of GiftCardImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GiftCardImageImplCopyWith<_$GiftCardImageImpl> get copyWith =>
      __$$GiftCardImageImplCopyWithImpl<_$GiftCardImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GiftCardImageImplToJson(
      this,
    );
  }
}

abstract class _GiftCardImage implements GiftCardImage {
  const factory _GiftCardImage(
      {required final String id,
      required final String imageUrl}) = _$GiftCardImageImpl;

  factory _GiftCardImage.fromJson(Map<String, dynamic> json) =
      _$GiftCardImageImpl.fromJson;

  @override
  String get id;
  @override
  String get imageUrl;

  /// Create a copy of GiftCardImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GiftCardImageImplCopyWith<_$GiftCardImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
