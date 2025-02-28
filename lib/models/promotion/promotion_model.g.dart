// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromotionImpl _$$PromotionImplFromJson(Map<String, dynamic> json) =>
    _$PromotionImpl(
      discount: (json['discount'] as num).toDouble(),
      description: json['description'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      applicableLocation: json['applicableLocation'] as String,
    );

Map<String, dynamic> _$$PromotionImplToJson(_$PromotionImpl instance) =>
    <String, dynamic>{
      'discount': instance.discount,
      'description': instance.description,
      'expirationDate': instance.expirationDate.toIso8601String(),
      'applicableLocation': instance.applicableLocation,
    };
