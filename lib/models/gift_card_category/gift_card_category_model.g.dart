// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GiftCardCategoryImpl _$$GiftCardCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$GiftCardCategoryImpl(
      name: json['name'] as String,
      giftCardImages: (json['giftCardImages'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GiftCardCategoryImplToJson(
        _$GiftCardCategoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'giftCardImages': instance.giftCardImages,
    };

_$GiftCardImageImpl _$$GiftCardImageImplFromJson(Map<String, dynamic> json) =>
    _$GiftCardImageImpl(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$$GiftCardImageImplToJson(_$GiftCardImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
    };
