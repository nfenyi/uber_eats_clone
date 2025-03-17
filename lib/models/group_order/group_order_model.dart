import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../order/order_model.dart';

part 'group_order_model.freezed.dart';
part 'group_order_model.g.dart';

@freezed
class GroupOrder with _$GroupOrder {
  factory GroupOrder({
    String? id,
    DateTime? createdAt,
    String? name,
    DateTime? firstOrderSchedule,
    String? frequency,
    DateTime? endDate,
    required List<String> storeIds,
    String? ownerId,
    String? location,
    DateTime? orderByDeadline,
    String? orderPlacementSetting,
    String? whoPays,
    double? spendingLimit,
    required List<String> persons,
    required List<OrderSchedule> orderSchedules,
  }) = _GroupOrder;
  factory GroupOrder.fromJson(Map<String, Object?> json) =>
      _$GroupOrderFromJson(json);
}
