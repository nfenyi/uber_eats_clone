import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'group_order_model.freezed.dart';
part 'group_order_model.g.dart';

@freezed
class GroupOrder with _$GroupOrder {
  factory GroupOrder({
    required String id,
    required DateTime? createdAt,
    required String name,
    DateTime? firstOrderSchedule,
    String? frequency,
    DateTime? endDate,
    required Object storeRef,
    required String ownerId,
    required String placeDescription,
    DateTime? orderByDeadline,
    String? orderPlacementSetting,
    required String? whoPays,
    double? spendingLimit,
    @Default([]) List<GroupOrderPerson> persons,
    @Default([]) List<Object> orderScheduleRefs,
  }) = _GroupOrder;
  factory GroupOrder.fromJson(Map<String, Object?> json) =>
      _$GroupOrderFromJson(json);
}

@freezed
class GroupOrderPerson with _$GroupOrderPerson {
  factory GroupOrderPerson({
    required String id,
    required String name,
  }) = _GroupOrderPerson;
  factory GroupOrderPerson.fromJson(Map<String, Object?> json) =>
      _$GroupOrderPersonFromJson(json);
}
