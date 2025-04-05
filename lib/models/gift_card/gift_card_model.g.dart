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
      deliverySchedule: json['deliverySchedule'] == null
          ? null
          : DateTime.parse(json['deliverySchedule'] as String),
      recipientAddress: json['recipientAddress'] as String?,
      sent: json['sent'] as bool?,
      dynamicLink: json['dynamicLink'] as String?,
      used: json['used'] as bool? ?? false,
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
      'deliverySchedule': instance.deliverySchedule?.toIso8601String(),
      'recipientAddress': instance.recipientAddress,
      'sent': instance.sent,
      'dynamicLink': instance.dynamicLink,
      'used': instance.used,
    };
