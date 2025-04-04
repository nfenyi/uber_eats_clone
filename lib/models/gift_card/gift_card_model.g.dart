// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GiftCardImpl _$$GiftCardImplFromJson(Map<String, dynamic> json) =>
    _$GiftCardImpl(
      id: json['id'] as String,
      senderName: json['senderName'] as String,
      receiverName: json['receiverName'] as String,
      imageUrl: json['imageUrl'] as String,
      giftAmount: (json['giftAmount'] as num).toInt(),
      senderUid: json['senderUid'] as String,
      optionalVideoUrl: json['optionalVideoUrl'] as String?,
      optionalMessage: json['optionalMessage'] as String?,
    );

Map<String, dynamic> _$$GiftCardImplToJson(_$GiftCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderName': instance.senderName,
      'receiverName': instance.receiverName,
      'imageUrl': instance.imageUrl,
      'giftAmount': instance.giftAmount,
      'senderUid': instance.senderUid,
      'optionalVideoUrl': instance.optionalVideoUrl,
      'optionalMessage': instance.optionalMessage,
    };
