import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'gift_card_model.freezed.dart';
part 'gift_card_model.g.dart';

@freezed
class GiftCard with _$GiftCard {
  factory GiftCard({
    required String id,
    required String senderName,
    required String receiverName,
    required String imageUrl,
    required int giftAmount,
    required String senderUid,
    required DateTime dateCreated,
    String? optionalVideoUrl,
    String? optionalMessage,
    DateTime? deliverySchedule,
    String? recipientAddress,
    bool? sent,
    String? dynamicLink,
    @Default(false) bool used,
  }) = _GiftCard;

  factory GiftCard.fromJson(Map<String, Object?> json) =>
      _$GiftCardFromJson(json);
}
