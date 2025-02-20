// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressDetailsImpl _$$AddressDetailsImplFromJson(Map<String, dynamic> json) =>
    _$AddressDetailsImpl(
      instruction: json['instruction'] as String,
      apartment: json['apartment'] as String,
      latLng: json['latLng'] as String,
      addressLabel: json['addressLabel'] as String,
      building: json['building'] as String,
      dropoffOption: json['dropoffOption'] as String,
    );

Map<String, dynamic> _$$AddressDetailsImplToJson(
        _$AddressDetailsImpl instance) =>
    <String, dynamic>{
      'instruction': instance.instruction,
      'apartment': instance.apartment,
      'latLng': instance.latLng,
      'addressLabel': instance.addressLabel,
      'building': instance.building,
      'dropoffOption': instance.dropoffOption,
    };
