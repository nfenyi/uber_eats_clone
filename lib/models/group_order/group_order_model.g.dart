// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupOrderImpl _$$GroupOrderImplFromJson(Map<String, dynamic> json) =>
    _$GroupOrderImpl(
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String?,
      firstOrderSchedule: json['firstOrderSchedule'] == null
          ? null
          : DateTime.parse(json['firstOrderSchedule'] as String),
      frequency: json['frequency'] as String?,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      storeIds:
          (json['storeIds'] as List<dynamic>).map((e) => e as String).toList(),
      ownerId: json['ownerId'] as String?,
      location: json['location'] as String?,
      orderByDeadline: json['orderByDeadline'] == null
          ? null
          : DateTime.parse(json['orderByDeadline'] as String),
      orderPlacementSetting: json['orderPlacementSetting'] as String?,
      whoPays: json['whoPays'] as String?,
      spendingLimit: (json['spendingLimit'] as num?)?.toDouble(),
      persons:
          (json['persons'] as List<dynamic>).map((e) => e as String).toList(),
      orderSchedules: (json['orderSchedules'] as List<dynamic>)
          .map((e) => OrderSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GroupOrderImplToJson(_$GroupOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'name': instance.name,
      'firstOrderSchedule': instance.firstOrderSchedule?.toIso8601String(),
      'frequency': instance.frequency,
      'endDate': instance.endDate?.toIso8601String(),
      'storeIds': instance.storeIds,
      'ownerId': instance.ownerId,
      'location': instance.location,
      'orderByDeadline': instance.orderByDeadline?.toIso8601String(),
      'orderPlacementSetting': instance.orderPlacementSetting,
      'whoPays': instance.whoPays,
      'spendingLimit': instance.spendingLimit,
      'persons': instance.persons,
      'orderSchedules': instance.orderSchedules.map((e) => e.toJson()).toList(),
    };
