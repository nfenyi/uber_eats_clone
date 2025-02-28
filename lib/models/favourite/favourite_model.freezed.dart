// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favourite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavouriteStore _$FavouriteStoreFromJson(Map<String, dynamic> json) {
  return _FavouriteStore.fromJson(json);
}

/// @nodoc
mixin _$FavouriteStore {
  String get id => throw _privateConstructorUsedError;
  DateTime get dateFavorited => throw _privateConstructorUsedError;

  /// Serializes this FavouriteStore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavouriteStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavouriteStoreCopyWith<FavouriteStore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavouriteStoreCopyWith<$Res> {
  factory $FavouriteStoreCopyWith(
          FavouriteStore value, $Res Function(FavouriteStore) then) =
      _$FavouriteStoreCopyWithImpl<$Res, FavouriteStore>;
  @useResult
  $Res call({String id, DateTime dateFavorited});
}

/// @nodoc
class _$FavouriteStoreCopyWithImpl<$Res, $Val extends FavouriteStore>
    implements $FavouriteStoreCopyWith<$Res> {
  _$FavouriteStoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavouriteStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateFavorited = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateFavorited: null == dateFavorited
          ? _value.dateFavorited
          : dateFavorited // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavouriteStoreImplCopyWith<$Res>
    implements $FavouriteStoreCopyWith<$Res> {
  factory _$$FavouriteStoreImplCopyWith(_$FavouriteStoreImpl value,
          $Res Function(_$FavouriteStoreImpl) then) =
      __$$FavouriteStoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime dateFavorited});
}

/// @nodoc
class __$$FavouriteStoreImplCopyWithImpl<$Res>
    extends _$FavouriteStoreCopyWithImpl<$Res, _$FavouriteStoreImpl>
    implements _$$FavouriteStoreImplCopyWith<$Res> {
  __$$FavouriteStoreImplCopyWithImpl(
      _$FavouriteStoreImpl _value, $Res Function(_$FavouriteStoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavouriteStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateFavorited = null,
  }) {
    return _then(_$FavouriteStoreImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateFavorited: null == dateFavorited
          ? _value.dateFavorited
          : dateFavorited // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavouriteStoreImpl
    with DiagnosticableTreeMixin
    implements _FavouriteStore {
  const _$FavouriteStoreImpl({required this.id, required this.dateFavorited});

  factory _$FavouriteStoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavouriteStoreImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime dateFavorited;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FavouriteStore(id: $id, dateFavorited: $dateFavorited)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FavouriteStore'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('dateFavorited', dateFavorited));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavouriteStoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dateFavorited, dateFavorited) ||
                other.dateFavorited == dateFavorited));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dateFavorited);

  /// Create a copy of FavouriteStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavouriteStoreImplCopyWith<_$FavouriteStoreImpl> get copyWith =>
      __$$FavouriteStoreImplCopyWithImpl<_$FavouriteStoreImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavouriteStoreImplToJson(
      this,
    );
  }
}

abstract class _FavouriteStore implements FavouriteStore {
  const factory _FavouriteStore(
      {required final String id,
      required final DateTime dateFavorited}) = _$FavouriteStoreImpl;

  factory _FavouriteStore.fromJson(Map<String, dynamic> json) =
      _$FavouriteStoreImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get dateFavorited;

  /// Create a copy of FavouriteStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavouriteStoreImplCopyWith<_$FavouriteStoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
