// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_video_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExploreVideo _$ExploreVideoFromJson(Map<String, dynamic> json) {
  return _ExploreVideo.fromJson(json);
}

/// @nodoc
mixin _$ExploreVideo {
  String get id => throw _privateConstructorUsedError;
  Object get productRef => throw _privateConstructorUsedError;
  Object get storeRef => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;

  /// Serializes this ExploreVideo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreVideoCopyWith<ExploreVideo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreVideoCopyWith<$Res> {
  factory $ExploreVideoCopyWith(
          ExploreVideo value, $Res Function(ExploreVideo) then) =
      _$ExploreVideoCopyWithImpl<$Res, ExploreVideo>;
  @useResult
  $Res call({String id, Object productRef, Object storeRef, String videoUrl});
}

/// @nodoc
class _$ExploreVideoCopyWithImpl<$Res, $Val extends ExploreVideo>
    implements $ExploreVideoCopyWith<$Res> {
  _$ExploreVideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productRef = null,
    Object? storeRef = null,
    Object? videoUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productRef: null == productRef ? _value.productRef : productRef,
      storeRef: null == storeRef ? _value.storeRef : storeRef,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreVideoImplCopyWith<$Res>
    implements $ExploreVideoCopyWith<$Res> {
  factory _$$ExploreVideoImplCopyWith(
          _$ExploreVideoImpl value, $Res Function(_$ExploreVideoImpl) then) =
      __$$ExploreVideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, Object productRef, Object storeRef, String videoUrl});
}

/// @nodoc
class __$$ExploreVideoImplCopyWithImpl<$Res>
    extends _$ExploreVideoCopyWithImpl<$Res, _$ExploreVideoImpl>
    implements _$$ExploreVideoImplCopyWith<$Res> {
  __$$ExploreVideoImplCopyWithImpl(
      _$ExploreVideoImpl _value, $Res Function(_$ExploreVideoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productRef = null,
    Object? storeRef = null,
    Object? videoUrl = null,
  }) {
    return _then(_$ExploreVideoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productRef: null == productRef ? _value.productRef : productRef,
      storeRef: null == storeRef ? _value.storeRef : storeRef,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreVideoImpl implements _ExploreVideo {
  const _$ExploreVideoImpl(
      {required this.id,
      required this.productRef,
      required this.storeRef,
      required this.videoUrl});

  factory _$ExploreVideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreVideoImplFromJson(json);

  @override
  final String id;
  @override
  final Object productRef;
  @override
  final Object storeRef;
  @override
  final String videoUrl;

  @override
  String toString() {
    return 'ExploreVideo(id: $id, productRef: $productRef, storeRef: $storeRef, videoUrl: $videoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreVideoImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other.productRef, productRef) &&
            const DeepCollectionEquality().equals(other.storeRef, storeRef) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(productRef),
      const DeepCollectionEquality().hash(storeRef),
      videoUrl);

  /// Create a copy of ExploreVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreVideoImplCopyWith<_$ExploreVideoImpl> get copyWith =>
      __$$ExploreVideoImplCopyWithImpl<_$ExploreVideoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreVideoImplToJson(
      this,
    );
  }
}

abstract class _ExploreVideo implements ExploreVideo {
  const factory _ExploreVideo(
      {required final String id,
      required final Object productRef,
      required final Object storeRef,
      required final String videoUrl}) = _$ExploreVideoImpl;

  factory _ExploreVideo.fromJson(Map<String, dynamic> json) =
      _$ExploreVideoImpl.fromJson;

  @override
  String get id;
  @override
  Object get productRef;
  @override
  Object get storeRef;
  @override
  String get videoUrl;

  /// Create a copy of ExploreVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreVideoImplCopyWith<_$ExploreVideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
