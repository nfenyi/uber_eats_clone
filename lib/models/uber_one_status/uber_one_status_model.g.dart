// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uber_one_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UberOneStatusImpl _$$UberOneStatusImplFromJson(Map<String, dynamic> json) =>
    _$UberOneStatusImpl(
      hasUberOne: json['hasUberOne'] as bool? ?? false,
      moneySaved: (json['moneySaved'] as num?)?.toDouble() ?? 0,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      plan: json['plan'] as String?,
    );

Map<String, dynamic> _$$UberOneStatusImplToJson(_$UberOneStatusImpl instance) =>
    <String, dynamic>{
      'hasUberOne': instance.hasUberOne,
      'moneySaved': instance.moneySaved,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'plan': instance.plan,
    };
