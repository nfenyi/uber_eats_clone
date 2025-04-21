// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      paymentMethodName: json['paymentMethodName'] as String,
      amountPaid: (json['amountPaid'] as num).toDouble(),
      cardNumber: json['cardNumber'] as String?,
      datePaid: DateTime.parse(json['datePaid'] as String),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'paymentMethodName': instance.paymentMethodName,
      'amountPaid': instance.amountPaid,
      'cardNumber': instance.cardNumber,
      'datePaid': instance.datePaid.toIso8601String(),
    };
