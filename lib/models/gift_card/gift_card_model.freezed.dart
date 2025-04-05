// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GiftCard _$GiftCardFromJson(Map<String, dynamic> json) {
  return _GiftCard.fromJson(json);
}

/// @nodoc
mixin _$GiftCard {
  String get id => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get receiverName => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get giftAmount => throw _privateConstructorUsedError;
  String get senderUid => throw _privateConstructorUsedError;
  String? get optionalVideoUrl => throw _privateConstructorUsedError;
  String? get optionalMessage => throw _privateConstructorUsedError;
  DateTime? get deliverySchedule => throw _privateConstructorUsedError;
  String? get recipientAddress => throw _privateConstructorUsedError;
  bool? get sent => throw _privateConstructorUsedError;
  String? get dynamicLink => throw _privateConstructorUsedError;
  bool get used => throw _privateConstructorUsedError;

  /// Serializes this GiftCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GiftCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GiftCardCopyWith<GiftCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftCardCopyWith<$Res> {
  factory $GiftCardCopyWith(GiftCard value, $Res Function(GiftCard) then) =
      _$GiftCardCopyWithImpl<$Res, GiftCard>;
  @useResult
  $Res call(
      {String id,
      String senderName,
      String receiverName,
      String imageUrl,
      int giftAmount,
      String senderUid,
      String? optionalVideoUrl,
      String? optionalMessage,
      DateTime? deliverySchedule,
      String? recipientAddress,
      bool? sent,
      String? dynamicLink,
      bool used});
}

/// @nodoc
class _$GiftCardCopyWithImpl<$Res, $Val extends GiftCard>
    implements $GiftCardCopyWith<$Res> {
  _$GiftCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GiftCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? receiverName = null,
    Object? imageUrl = null,
    Object? giftAmount = null,
    Object? senderUid = null,
    Object? optionalVideoUrl = freezed,
    Object? optionalMessage = freezed,
    Object? deliverySchedule = freezed,
    Object? recipientAddress = freezed,
    Object? sent = freezed,
    Object? dynamicLink = freezed,
    Object? used = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      receiverName: null == receiverName
          ? _value.receiverName
          : receiverName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      giftAmount: null == giftAmount
          ? _value.giftAmount
          : giftAmount // ignore: cast_nullable_to_non_nullable
              as int,
      senderUid: null == senderUid
          ? _value.senderUid
          : senderUid // ignore: cast_nullable_to_non_nullable
              as String,
      optionalVideoUrl: freezed == optionalVideoUrl
          ? _value.optionalVideoUrl
          : optionalVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      optionalMessage: freezed == optionalMessage
          ? _value.optionalMessage
          : optionalMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      deliverySchedule: freezed == deliverySchedule
          ? _value.deliverySchedule
          : deliverySchedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recipientAddress: freezed == recipientAddress
          ? _value.recipientAddress
          : recipientAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      sent: freezed == sent
          ? _value.sent
          : sent // ignore: cast_nullable_to_non_nullable
              as bool?,
      dynamicLink: freezed == dynamicLink
          ? _value.dynamicLink
          : dynamicLink // ignore: cast_nullable_to_non_nullable
              as String?,
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GiftCardImplCopyWith<$Res>
    implements $GiftCardCopyWith<$Res> {
  factory _$$GiftCardImplCopyWith(
          _$GiftCardImpl value, $Res Function(_$GiftCardImpl) then) =
      __$$GiftCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderName,
      String receiverName,
      String imageUrl,
      int giftAmount,
      String senderUid,
      String? optionalVideoUrl,
      String? optionalMessage,
      DateTime? deliverySchedule,
      String? recipientAddress,
      bool? sent,
      String? dynamicLink,
      bool used});
}

/// @nodoc
class __$$GiftCardImplCopyWithImpl<$Res>
    extends _$GiftCardCopyWithImpl<$Res, _$GiftCardImpl>
    implements _$$GiftCardImplCopyWith<$Res> {
  __$$GiftCardImplCopyWithImpl(
      _$GiftCardImpl _value, $Res Function(_$GiftCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of GiftCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? receiverName = null,
    Object? imageUrl = null,
    Object? giftAmount = null,
    Object? senderUid = null,
    Object? optionalVideoUrl = freezed,
    Object? optionalMessage = freezed,
    Object? deliverySchedule = freezed,
    Object? recipientAddress = freezed,
    Object? sent = freezed,
    Object? dynamicLink = freezed,
    Object? used = null,
  }) {
    return _then(_$GiftCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      receiverName: null == receiverName
          ? _value.receiverName
          : receiverName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      giftAmount: null == giftAmount
          ? _value.giftAmount
          : giftAmount // ignore: cast_nullable_to_non_nullable
              as int,
      senderUid: null == senderUid
          ? _value.senderUid
          : senderUid // ignore: cast_nullable_to_non_nullable
              as String,
      optionalVideoUrl: freezed == optionalVideoUrl
          ? _value.optionalVideoUrl
          : optionalVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      optionalMessage: freezed == optionalMessage
          ? _value.optionalMessage
          : optionalMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      deliverySchedule: freezed == deliverySchedule
          ? _value.deliverySchedule
          : deliverySchedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recipientAddress: freezed == recipientAddress
          ? _value.recipientAddress
          : recipientAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      sent: freezed == sent
          ? _value.sent
          : sent // ignore: cast_nullable_to_non_nullable
              as bool?,
      dynamicLink: freezed == dynamicLink
          ? _value.dynamicLink
          : dynamicLink // ignore: cast_nullable_to_non_nullable
              as String?,
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GiftCardImpl with DiagnosticableTreeMixin implements _GiftCard {
  _$GiftCardImpl(
      {required this.id,
      required this.senderName,
      required this.receiverName,
      required this.imageUrl,
      required this.giftAmount,
      required this.senderUid,
      this.optionalVideoUrl,
      this.optionalMessage,
      this.deliverySchedule,
      this.recipientAddress,
      this.sent,
      this.dynamicLink,
      this.used = false});

  factory _$GiftCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$GiftCardImplFromJson(json);

  @override
  final String id;
  @override
  final String senderName;
  @override
  final String receiverName;
  @override
  final String imageUrl;
  @override
  final int giftAmount;
  @override
  final String senderUid;
  @override
  final String? optionalVideoUrl;
  @override
  final String? optionalMessage;
  @override
  final DateTime? deliverySchedule;
  @override
  final String? recipientAddress;
  @override
  final bool? sent;
  @override
  final String? dynamicLink;
  @override
  @JsonKey()
  final bool used;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GiftCard(id: $id, senderName: $senderName, receiverName: $receiverName, imageUrl: $imageUrl, giftAmount: $giftAmount, senderUid: $senderUid, optionalVideoUrl: $optionalVideoUrl, optionalMessage: $optionalMessage, deliverySchedule: $deliverySchedule, recipientAddress: $recipientAddress, sent: $sent, dynamicLink: $dynamicLink, used: $used)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GiftCard'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('senderName', senderName))
      ..add(DiagnosticsProperty('receiverName', receiverName))
      ..add(DiagnosticsProperty('imageUrl', imageUrl))
      ..add(DiagnosticsProperty('giftAmount', giftAmount))
      ..add(DiagnosticsProperty('senderUid', senderUid))
      ..add(DiagnosticsProperty('optionalVideoUrl', optionalVideoUrl))
      ..add(DiagnosticsProperty('optionalMessage', optionalMessage))
      ..add(DiagnosticsProperty('deliverySchedule', deliverySchedule))
      ..add(DiagnosticsProperty('recipientAddress', recipientAddress))
      ..add(DiagnosticsProperty('sent', sent))
      ..add(DiagnosticsProperty('dynamicLink', dynamicLink))
      ..add(DiagnosticsProperty('used', used));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GiftCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.receiverName, receiverName) ||
                other.receiverName == receiverName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.giftAmount, giftAmount) ||
                other.giftAmount == giftAmount) &&
            (identical(other.senderUid, senderUid) ||
                other.senderUid == senderUid) &&
            (identical(other.optionalVideoUrl, optionalVideoUrl) ||
                other.optionalVideoUrl == optionalVideoUrl) &&
            (identical(other.optionalMessage, optionalMessage) ||
                other.optionalMessage == optionalMessage) &&
            (identical(other.deliverySchedule, deliverySchedule) ||
                other.deliverySchedule == deliverySchedule) &&
            (identical(other.recipientAddress, recipientAddress) ||
                other.recipientAddress == recipientAddress) &&
            (identical(other.sent, sent) || other.sent == sent) &&
            (identical(other.dynamicLink, dynamicLink) ||
                other.dynamicLink == dynamicLink) &&
            (identical(other.used, used) || other.used == used));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderName,
      receiverName,
      imageUrl,
      giftAmount,
      senderUid,
      optionalVideoUrl,
      optionalMessage,
      deliverySchedule,
      recipientAddress,
      sent,
      dynamicLink,
      used);

  /// Create a copy of GiftCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GiftCardImplCopyWith<_$GiftCardImpl> get copyWith =>
      __$$GiftCardImplCopyWithImpl<_$GiftCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GiftCardImplToJson(
      this,
    );
  }
}

abstract class _GiftCard implements GiftCard {
  factory _GiftCard(
      {required final String id,
      required final String senderName,
      required final String receiverName,
      required final String imageUrl,
      required final int giftAmount,
      required final String senderUid,
      final String? optionalVideoUrl,
      final String? optionalMessage,
      final DateTime? deliverySchedule,
      final String? recipientAddress,
      final bool? sent,
      final String? dynamicLink,
      final bool used}) = _$GiftCardImpl;

  factory _GiftCard.fromJson(Map<String, dynamic> json) =
      _$GiftCardImpl.fromJson;

  @override
  String get id;
  @override
  String get senderName;
  @override
  String get receiverName;
  @override
  String get imageUrl;
  @override
  int get giftAmount;
  @override
  String get senderUid;
  @override
  String? get optionalVideoUrl;
  @override
  String? get optionalMessage;
  @override
  DateTime? get deliverySchedule;
  @override
  String? get recipientAddress;
  @override
  bool? get sent;
  @override
  String? get dynamicLink;
  @override
  bool get used;

  /// Create a copy of GiftCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GiftCardImplCopyWith<_$GiftCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
