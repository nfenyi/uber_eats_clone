// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressDetailsImpl _$$AddressDetailsImplFromJson(Map<String, dynamic> json) =>
    _$AddressDetailsImpl(
      instruction: json['instruction'] as String,
      apartment: json['apartment'] as String,
      latlng: json['latlng'],
      addressLabel: json['addressLabel'] as String,
      placeDescription: json['placeDescription'] as String,
      building: json['building'] as String,
      dropoffOption: json['dropoffOption'] as String,
    );

Map<String, dynamic> _$$AddressDetailsImplToJson(
        _$AddressDetailsImpl instance) =>
    <String, dynamic>{
      'instruction': instance.instruction,
      'apartment': instance.apartment,
      'latlng': instance.latlng,
      'addressLabel': instance.addressLabel,
      'placeDescription': instance.placeDescription,
      'building': instance.building,
      'dropoffOption': instance.dropoffOption,
    };
