import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../payment/payment_model.dart';
import '../promotion/promotion_model.dart';
import '../store/store_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class IndividualOrder with _$IndividualOrder {
  const factory IndividualOrder({
    required Map<String, dynamic> productsAndQuantities,
    required DateTime deliveryDate,
    double? tip,
    required String orderNumber,
    required String courier,
    Promotion? promo,
    required double serviceFee,
    required double tax,
    double? caDriverBenefits,
    required double deliveryFee,
    double? membershipBenefit,
    required double totalFee,
    required List<Payment> payments,
    required Store store,
    required String status,
  }) = _IndividualOrder;

  factory IndividualOrder.fromJson(Map<String, Object?> json) =>
      _$IndividualOrderFromJson(json);
}

@freezed
class GroupOrder with _$GroupOrder {
  const factory GroupOrder({
    required String name,
    required String createdBy,
    required String location,
    required List<Store> stores,
    required List<OrderSchedule> orderSchedules,
    required List<String> persons,
    String? repeat,
  }) = _GroupOrder;

  factory GroupOrder.fromJson(Map<String, Object?> json) =>
      _$GroupOrderFromJson(json);
}

@freezed
class OrderSchedule with _$OrderSchedule {
  const factory OrderSchedule({
    required DateTime deliveryDate,
    required Store store,
    required String orderNumber,
    required List<OrderItem> orderItems,
    double? tip,
    required String courier,
    required String status,
    Promotion? promo,
    required double serviceFee,
    required double tax,
    double? caDriverBenefits,
    required double deliveryFee,
    double? membershipBenefit,
    required List<Payment> payments,
    required double totalFee,
  }) = _OrderSchedule;

  factory OrderSchedule.fromJson(Map<String, Object?> json) =>
      _$OrderScheduleFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String person,
    required Map<String, dynamic> productsAndQuantities,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, Object?> json) =>
      _$OrderItemFromJson(json);
}
