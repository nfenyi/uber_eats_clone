// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndividualOrderImpl _$$IndividualOrderImplFromJson(
        Map<String, dynamic> json) =>
    _$IndividualOrderImpl(
      products: (json['products'] as List<dynamic>)
          .map((e) => CartProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPriority: json['isPriority'] as bool,
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      tip: (json['tip'] as num?)?.toDouble() ?? 0,
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
      storeId: json['storeId'] as String,
      status: json['status'] as String? ?? 'Ongoing',
      userUid: json['userUid'] as String,
    );

Map<String, dynamic> _$$IndividualOrderImplToJson(
        _$IndividualOrderImpl instance) =>
    <String, dynamic>{
      'products': instance.products.map((e) => e.toJson()).toList(),
      'isPriority': instance.isPriority,
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
      'storeId': instance.storeId,
      'status': instance.status,
      'userUid': instance.userUid,
    };

_$OrderScheduleImpl _$$OrderScheduleImplFromJson(Map<String, dynamic> json) =>
    _$OrderScheduleImpl(
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      orderDate: DateTime.parse(json['orderDate'] as String),
      orderNumber: json['orderNumber'] as String,
      orderItems: (json['orderItems'] as List<dynamic>?)
              ?.map((e) => GroupOrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skippedBy: (json['skippedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalFee: json['totalFee'] ?? 0,
      storeRef: json['storeRef'] as Object,
    );

Map<String, dynamic> _$$OrderScheduleImplToJson(_$OrderScheduleImpl instance) =>
    <String, dynamic>{
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'orderDate': instance.orderDate.toIso8601String(),
      'orderNumber': instance.orderNumber,
      'orderItems': instance.orderItems.map((e) => e.toJson()).toList(),
      'skippedBy': instance.skippedBy,
      'totalFee': instance.totalFee,
      'storeRef': instance.storeRef,
    };

_$GroupOrderItemImpl _$$GroupOrderItemImplFromJson(Map<String, dynamic> json) =>
    _$GroupOrderItemImpl(
      person: json['person'] as String,
      productsAndQuantities:
          json['productsAndQuantities'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$GroupOrderItemImplToJson(
        _$GroupOrderItemImpl instance) =>
    <String, dynamic>{
      'person': instance.person,
      'productsAndQuantities': instance.productsAndQuantities,
    };

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      storeId: json['storeId'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => CartProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      placeDescription: json['placeDescription'] as String,
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      initialPricesTotal: (json['initialPricesTotal'] as num).toDouble(),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'placeDescription': instance.placeDescription,
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'subtotal': instance.subtotal,
      'initialPricesTotal': instance.initialPricesTotal,
    };

_$CartProductImpl _$$CartProductImplFromJson(Map<String, dynamic> json) =>
    _$CartProductImpl(
      optionalOptions: (json['optionalOptions'] as List<dynamic>)
          .map((e) => CartProductOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      requiredOptions: (json['requiredOptions'] as List<dynamic>)
          .map((e) => CartProductOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      note: json['note'] as String,
      productReplacementId: json['productReplacementId'] as String,
      backupInstruction: json['backupInstruction'] as String,
    );

Map<String, dynamic> _$$CartProductImplToJson(_$CartProductImpl instance) =>
    <String, dynamic>{
      'optionalOptions':
          instance.optionalOptions.map((e) => e.toJson()).toList(),
      'requiredOptions':
          instance.requiredOptions.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'quantity': instance.quantity,
      'note': instance.note,
      'productReplacementId': instance.productReplacementId,
      'backupInstruction': instance.backupInstruction,
    };

_$CartProductOptionImpl _$$CartProductOptionImplFromJson(
        Map<String, dynamic> json) =>
    _$CartProductOptionImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      options: (json['options'] as List<dynamic>)
          .map((e) => CartProductOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      categoryName: json['categoryName'] as String,
    );

Map<String, dynamic> _$$CartProductOptionImplToJson(
        _$CartProductOptionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'categoryName': instance.categoryName,
    };
