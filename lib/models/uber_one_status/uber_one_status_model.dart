import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'uber_one_status_model.freezed.dart';
part 'uber_one_status_model.g.dart';

@freezed
class UberOneStatus with _$UberOneStatus {
  factory UberOneStatus({
    @Default(false) bool hasUberOne,
    @Default(0) double moneySaved,
    DateTime? expirationDate,
    String? plan,
  }) = _UberOneStatus;
  factory UberOneStatus.fromJson(Map<String, Object?> json) =>
      _$UberOneStatusFromJson(json);
}
