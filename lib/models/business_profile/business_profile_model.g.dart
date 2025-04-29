// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessProfileImpl _$$BusinessProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessProfileImpl(
      id: json['id'] as String,
      creditCardNumber: json['creditCardNumber'] as String?,
      email: json['email'] as String?,
      expenseProgram: json['expenseProgram'] as String?,
    );

Map<String, dynamic> _$$BusinessProfileImplToJson(
        _$BusinessProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creditCardNumber': instance.creditCardNumber,
      'email': instance.email,
      'expenseProgram': instance.expenseProgram,
    };
