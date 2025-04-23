// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreditCardDetailsImpl _$$CreditCardDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$CreditCardDetailsImpl(
      cardNumber: json['cardNumber'] as String,
      expDate: json['expDate'] as String,
      cvv: json['cvv'] as String,
      country: json['country'] as String,
      zipCode: json['zipCode'] as String,
      creditCardType: json['creditCardType'] as String?,
      nickName: json['nickName'] as String,
    );

Map<String, dynamic> _$$CreditCardDetailsImplToJson(
        _$CreditCardDetailsImpl instance) =>
    <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'expDate': instance.expDate,
      'cvv': instance.cvv,
      'country': instance.country,
      'zipCode': instance.zipCode,
      'creditCardType': instance.creditCardType,
      'nickName': instance.nickName,
    };
