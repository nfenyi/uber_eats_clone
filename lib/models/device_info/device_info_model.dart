import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'device_info_model.freezed.dart';
part 'device_info_model.g.dart';

@freezed
class DeviceUserInfo with _$DeviceUserInfo {
  const factory DeviceUserInfo({
    required String? email,
    required String? name,
    required String? phoneNumber,
    required String? profilePic,
  }) = _DeviceUserInfoModel;

  factory DeviceUserInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceUserInfoFromJson(json);
}
