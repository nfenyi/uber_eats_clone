// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      paymentMethod:
          PaymentMethod.fromJson(json['paymentMethod'] as Map<String, dynamic>),
      amountPaid: (json['amountPaid'] as num).toInt(),
      cardNumber: json['cardNumber'] as String,
      datePaid: DateTime.parse(json['datePaid'] as String),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'paymentMethod': instance.paymentMethod.toJson(),
      'amountPaid': instance.amountPaid,
      'cardNumber': instance.cardNumber,
      'datePaid': instance.datePaid.toIso8601String(),
    };
