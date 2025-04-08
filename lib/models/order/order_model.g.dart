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
      placeDescription: json['placeDescription'] as String,
      courier: json['courier'] as String? ?? 'Jonathan',
      promoApplied: json['promoApplied'],
      serviceFee: (json['serviceFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      caDriverBenefits: (json['caDriverBenefits'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      membershipBenefit: (json['membershipBenefit'] as num?)?.toDouble(),
      totalFee: (json['totalFee'] as num).toDouble(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      storeRef: json['storeRef'] as Object,
      status: json['status'] as String? ?? 'Pending',
    );

Map<String, dynamic> _$$IndividualOrderImplToJson(
        _$IndividualOrderImpl instance) =>
    <String, dynamic>{
      'productsAndQuantities': instance.productsAndQuantities,
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'tip': instance.tip,
      'orderNumber': instance.orderNumber,
      'placeDescription': instance.placeDescription,
      'courier': instance.courier,
      'promoApplied': instance.promoApplied,
      'serviceFee': instance.serviceFee,
      'tax': instance.tax,
      'caDriverBenefits': instance.caDriverBenefits,
      'deliveryFee': instance.deliveryFee,
      'membershipBenefit': instance.membershipBenefit,
      'totalFee': instance.totalFee,
      'payments': instance.payments.map((e) => e.toJson()).toList(),
      'storeRef': instance.storeRef,
      'status': instance.status,
    };

_$OrderScheduleImpl _$$OrderScheduleImplFromJson(Map<String, dynamic> json) =>
    _$OrderScheduleImpl(
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      storeRef: json['storeRef'] as Object,
      orderNumber: json['orderNumber'] as String,
      orderItems: (json['orderItems'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tip: (json['tip'] as num?)?.toDouble() ?? 0,
      courier: json['courier'] as String? ?? 'Bernard',
      status: json['status'] as String? ?? 'Processing',
      promo: json['promo'] == null
          ? null
          : Promotion.fromJson(json['promo'] as Map<String, dynamic>),
      serviceFee: (json['serviceFee'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      caDriverBenefits: (json['caDriverBenefits'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      membershipBenefit: (json['membershipBenefit'] as num?)?.toDouble() ?? 0,
      payments: (json['payments'] as List<dynamic>?)
              ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalFee: (json['totalFee'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$OrderScheduleImplToJson(_$OrderScheduleImpl instance) =>
    <String, dynamic>{
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'storeRef': instance.storeRef,
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
