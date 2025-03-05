import 'package:freezed_annotation/freezed_annotation.dart';

import '../store/store_model.dart';

part 'offer_model.freezed.dart';
part 'offer_model.g.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required Product product,
    required Store store,
    required String title,
  }) = _Offer;

  factory Offer.fromJson(Map<String, Object?> json) => _$OfferFromJson(json);
}
