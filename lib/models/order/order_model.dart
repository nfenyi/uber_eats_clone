import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../payment/payment_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class IndividualOrder with _$IndividualOrder {
  const factory IndividualOrder({
    required List<CartProduct> products,
    required bool isPriority,
    required DateTime deliveryDate,
    @Default(0) double tip,
    required String orderNumber,
    required String placeDescription,
    @Default('Jonathan') String courier,
    Object? promoApplied,
    required double serviceFee,
    required double tax,
    @Default(0) double caDriverBenefits,
    required double deliveryFee,
    double? membershipBenefit,
    required double totalFee,
    required List<Payment> payments,
    required String storeId,
    @Default('Ongoing') String status,
    required String userUid,
  }) = _IndividualOrder;

  factory IndividualOrder.fromJson(Map<String, Object?> json) =>
      _$IndividualOrderFromJson(json);
}

@freezed
class OrderSchedule with _$OrderSchedule {
  const factory OrderSchedule({
    DateTime? deliveryDate,
    required DateTime orderDate,
    required String orderNumber,
    @Default([]) List<GroupOrderItem> orderItems,
    @Default([]) List<String> skippedBy,
    @Default(0) totalFee,
    required Object storeRef,
  }) = _OrderSchedule;

  factory OrderSchedule.fromJson(Map<String, Object?> json) =>
      _$OrderScheduleFromJson(json);
}

@freezed
class GroupOrderItem with _$GroupOrderItem {
  const factory GroupOrderItem({
    required String person,
    required Map<String, dynamic> productsAndQuantities,
  }) = _GroupOrderItem;

  factory GroupOrderItem.fromJson(Map<String, Object?> json) =>
      _$GroupOrderItemFromJson(json);
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String storeId,
    required List<CartProduct> products,
    required String placeDescription,
    required DateTime deliveryDate,
    required double subtotal,
    required double initialPricesTotal,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, Object?> json) =>
      _$CartItemFromJson(json);
}

@freezed
class CartProduct with _$CartProduct {
  const factory CartProduct({
    required List<CartProductOption> optionalOptions,
    required List<CartProductOption> requiredOptions,
    required String id,
    required int quantity,
    required String note,
    required String productReplacementId,
    required String backupInstruction,
  }) = _CartProduct;

  factory CartProduct.fromJson(Map<String, Object?> json) =>
      _$CartProductFromJson(json);
}

@freezed
class CartProductOption with _$CartProductOption {
  const factory CartProductOption(
      {required String name,
      required int quantity,
      required List<CartProductOption> options,
      required String categoryName}) = _CartProductOption;

  factory CartProductOption.fromJson(Map<String, Object?> json) =>
      _$CartProductOptionFromJson(json);
}
