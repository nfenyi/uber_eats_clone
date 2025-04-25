import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'voucher_model.freezed.dart';
part 'voucher_model.g.dart';

@freezed
class Voucher with _$Voucher {
  const factory Voucher({
    required String id,
    required double amount,
    required String description,
    required String title,
    @Default(false) bool claimed,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, Object?> json) =>
      _$VoucherFromJson(json);
}
