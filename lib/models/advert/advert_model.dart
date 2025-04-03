import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'advert_model.freezed.dart';
part 'advert_model.g.dart';

@freezed
class Advert with _$Advert {
  const factory Advert({
    required String title,
    required String shopId,
    required List<Object> products,
    required String type,
  }) = _Advert;

  factory Advert.fromJson(Map<String, dynamic> json) => _$AdvertFromJson(json);
}
