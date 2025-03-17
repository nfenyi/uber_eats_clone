import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

@freezed
class Promotion with _$Promotion {
  const factory Promotion({
    required String id,
    required double discount,
    required String description,
    required DateTime expirationDate,
    required String applicableLocation,
  }) = _Promotion;

  factory Promotion.fromJson(Map<String, Object?> json) =>
      _$PromotionFromJson(json);
}
