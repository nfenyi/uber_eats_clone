// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
      id: json['id'] as String,
      product: json['product'] as Object,
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      title: json['title'] as String,
    );

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'store': instance.store.toJson(),
      'title': instance.title,
    };
