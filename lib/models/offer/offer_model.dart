import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer_model.freezed.dart';
part 'offer_model.g.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String id,
    required Object product,
    required Object store,
    required String title,
  }) = _Offer;

  factory Offer.fromJson(Map<String, Object?> json) => _$OfferFromJson(json);
}
