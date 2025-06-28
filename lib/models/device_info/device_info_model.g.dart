// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceUserInfoModelImpl _$$DeviceUserInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceUserInfoModelImpl(
      email: json['email'] as String?,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profilePic: json['profilePic'] as String?,
    );

Map<String, dynamic> _$$DeviceUserInfoModelImplToJson(
        _$DeviceUserInfoModelImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'profilePic': instance.profilePic,
    };
