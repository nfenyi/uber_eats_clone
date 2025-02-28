// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndividualOrderImpl _$$IndividualOrderImplFromJson(
        Map<String, dynamic> json) =>
    _$IndividualOrderImpl(
      productsAndQuantities:
          json['productsAndQuantities'] as Map<String, dynamic>,
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      tip: (json['tip'] as num?)?.toDouble(),
      orderNumber: json['orderNumber'] as String,
      courier: json['courier'] as String,
      promo: json['promo'] == null
          ? null
          : Promotion.fromJson(json['promo'] as Map<String, dynamic>),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      caDriverBenefits: (json['caDriverBenefits'] as num?)?.toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      membershipBenefit: (json['membershipBenefit'] as num?)?.toDouble(),
      totalFee: (json['totalFee'] as num).toDouble(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$IndividualOrderImplToJson(
        _$IndividualOrderImpl instance) =>
    <String, dynamic>{
      'productsAndQuantities': instance.productsAndQuantities,
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'tip': instance.tip,
      'orderNumber': instance.orderNumber,
      'courier': instance.courier,
      'promo': instance.promo?.toJson(),
      'serviceFee': instance.serviceFee,
      'tax': instance.tax,
      'caDriverBenefits': instance.caDriverBenefits,
      'deliveryFee': instance.deliveryFee,
      'membershipBenefit': instance.membershipBenefit,
      'totalFee': instance.totalFee,
      'payments': instance.payments.map((e) => e.toJson()).toList(),
      'store': instance.store.toJson(),
      'status': instance.status,
    };

_$GroupOrderImpl _$$GroupOrderImplFromJson(Map<String, dynamic> json) =>
    _$GroupOrderImpl(
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      location: json['location'] as String,
      stores: (json['stores'] as List<dynamic>)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderSchedules: (json['orderSchedules'] as List<dynamic>)
          .map((e) => OrderSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      persons:
          (json['persons'] as List<dynamic>).map((e) => e as String).toList(),
      repeat: json['repeat'] as String?,
    );

Map<String, dynamic> _$$GroupOrderImplToJson(_$GroupOrderImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'createdBy': instance.createdBy,
      'location': instance.location,
      'stores': instance.stores.map((e) => e.toJson()).toList(),
      'orderSchedules': instance.orderSchedules.map((e) => e.toJson()).toList(),
      'persons': instance.persons,
      'repeat': instance.repeat,
    };

_$OrderScheduleImpl _$$OrderScheduleImplFromJson(Map<String, dynamic> json) =>
    _$OrderScheduleImpl(
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      orderNumber: json['orderNumber'] as String,
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      tip: (json['tip'] as num?)?.toDouble(),
      courier: json['courier'] as String,
      status: json['status'] as String,
      promo: json['promo'] == null
          ? null
          : Promotion.fromJson(json['promo'] as Map<String, dynamic>),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      caDriverBenefits: (json['caDriverBenefits'] as num?)?.toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      membershipBenefit: (json['membershipBenefit'] as num?)?.toDouble(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalFee: (json['totalFee'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderScheduleImplToJson(_$OrderScheduleImpl instance) =>
    <String, dynamic>{
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'store': instance.store.toJson(),
      'orderNumber': instance.orderNumber,
      'orderItems': instance.orderItems.map((e) => e.toJson()).toList(),
      'tip': instance.tip,
      'courier': instance.courier,
      'status': instance.status,
      'promo': instance.promo?.toJson(),
      'serviceFee': instance.serviceFee,
      'tax': instance.tax,
      'caDriverBenefits': instance.caDriverBenefits,
      'deliveryFee': instance.deliveryFee,
      'membershipBenefit': instance.membershipBenefit,
      'payments': instance.payments.map((e) => e.toJson()).toList(),
      'totalFee': instance.totalFee,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      person: json['person'] as String,
      productsAndQuantities:
          json['productsAndQuantities'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'person': instance.person,
      'productsAndQuantities': instance.productsAndQuantities,
    };
