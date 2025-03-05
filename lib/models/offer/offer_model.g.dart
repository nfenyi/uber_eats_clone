// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      title: json['title'] as String,
    );

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'product': instance.product.toJson(),
      'store': instance.store.toJson(),
      'title': instance.title,
    };
