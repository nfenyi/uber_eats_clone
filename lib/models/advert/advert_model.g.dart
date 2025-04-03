// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdvertImpl _$$AdvertImplFromJson(Map<String, dynamic> json) => _$AdvertImpl(
      title: json['title'] as String,
      shopId: json['shopId'] as String,
      products:
          (json['products'] as List<dynamic>).map((e) => e as Object).toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$AdvertImplToJson(_$AdvertImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'shopId': instance.shopId,
      'products': instance.products,
      'type': instance.type,
    };
