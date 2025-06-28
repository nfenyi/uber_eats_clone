import 'package:freezed_annotation/freezed_annotation.dart';

part 'gift_card_category_model.freezed.dart';
part 'gift_card_category_model.g.dart';

@freezed
class GiftCardCategory with _$GiftCardCategory {
  const factory GiftCardCategory(
      {required String name,
      @Default([]) List<Object> giftCardImages}) = _GiftCardCategory;
  factory GiftCardCategory.fromJson(Map<String, Object?> json) =>
      _$GiftCardCategoryFromJson(json);
}

@freezed
class GiftCardImage with _$GiftCardImage {
  const factory GiftCardImage({required String id, required String imageUrl}) =
      _GiftCardImage;
  factory GiftCardImage.fromJson(Map<String, Object?> json) =>
      _$GiftCardImageFromJson(json);
}
