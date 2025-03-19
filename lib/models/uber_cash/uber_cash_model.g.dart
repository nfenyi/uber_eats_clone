// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uber_cash_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UberCashImpl _$$UberCashImplFromJson(Map<String, dynamic> json) =>
    _$UberCashImpl(
      isActive: json['isActive'] as bool? ?? false,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.00,
    );

Map<String, dynamic> _$$UberCashImplToJson(_$UberCashImpl instance) =>
    <String, dynamic>{
      'isActive': instance.isActive,
      'balance': instance.balance,
    };
