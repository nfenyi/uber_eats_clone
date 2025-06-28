// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDetailsImpl _$$UserDetailsImplFromJson(Map<String, dynamic> json) =>
    _$UserDetailsImpl(
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      uberCash: json['uberCash'] == null
          ? null
          : UberCash.fromJson(json['uberCash'] as Map<String, dynamic>),
      selectedAddresses: json['selectedAddresses'] == null
          ? null
          : UserAddress.fromJson(
              json['selectedAddresses'] as Map<String, dynamic>),
      businessProfileIds: (json['businessProfileIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      groupOrders: (json['groupOrders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      redeemedPromos: (json['redeemedPromos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      redeemedVouchers: (json['redeemedVouchers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      usedPromos: (json['usedPromos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      usedVouchers: (json['usedVouchers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      displayName: json['displayName'] ?? OtherConstants.na,
      hasUberOne: json['hasUberOne'] ?? false,
      onboarded: json['onboarded'] ?? false,
      selectedBusinessProfileId: json['selectedBusinessProfileId'] as String?,
      type: json['type'] as String? ?? 'Personal',
      familyProfile: json['familyProfile'] as String?,
      uberOneStatus: json['uberOneStatus'] == null
          ? null
          : UberOneStatus.fromJson(
              json['uberOneStatus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserDetailsImplToJson(_$UserDetailsImpl instance) =>
    <String, dynamic>{
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'uberCash': instance.uberCash?.toJson(),
      'selectedAddresses': instance.selectedAddresses?.toJson(),
      'businessProfileIds': instance.businessProfileIds,
      'groupOrders': instance.groupOrders,
      'redeemedPromos': instance.redeemedPromos,
      'redeemedVouchers': instance.redeemedVouchers,
      'usedPromos': instance.usedPromos,
      'usedVouchers': instance.usedVouchers,
      'displayName': instance.displayName,
      'hasUberOne': instance.hasUberOne,
      'onboarded': instance.onboarded,
      'selectedBusinessProfileId': instance.selectedBusinessProfileId,
      'type': instance.type,
      'familyProfile': instance.familyProfile,
      'uberOneStatus': instance.uberOneStatus?.toJson(),
    };

_$UserAddressImpl _$$UserAddressImplFromJson(Map<String, dynamic> json) =>
    _$UserAddressImpl(
      apartment: json['apartment'] as String? ?? OtherConstants.na,
      building: json['building'] as String? ?? OtherConstants.na,
      dropoffOption: json['dropoffOption'] as String? ?? OtherConstants.na,
      instruction: json['instruction'] as String? ?? OtherConstants.na,
      placeDescription:
          json['placeDescription'] as String? ?? OtherConstants.na,
      latlng: json['latlng'] as Object? ?? const GeoPoint(0, 0),
    );

Map<String, dynamic> _$$UserAddressImplToJson(_$UserAddressImpl instance) =>
    <String, dynamic>{
      'apartment': instance.apartment,
      'building': instance.building,
      'dropoffOption': instance.dropoffOption,
      'instruction': instance.instruction,
      'placeDescription': instance.placeDescription,
      'latlng': instance.latlng,
    };

_$UberCashImpl _$$UberCashImplFromJson(Map<String, dynamic> json) =>
    _$UberCashImpl(
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      cashAdded: (json['cashAdded'] as num?)?.toDouble() ?? 0,
      cashSpent: (json['cashSpent'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$UberCashImplToJson(_$UberCashImpl instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'cashAdded': instance.cashAdded,
      'cashSpent': instance.cashSpent,
      'isActive': instance.isActive,
    };

_$UberOneStatusImpl _$$UberOneStatusImplFromJson(Map<String, dynamic> json) =>
    _$UberOneStatusImpl(
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      plan: json['plan'] as String?,
      moneySaved: (json['moneySaved'] as num?)?.toDouble() ?? 0,
      hasUberOne: json['hasUberOne'] as bool? ?? false,
    );

Map<String, dynamic> _$$UberOneStatusImplToJson(_$UberOneStatusImpl instance) =>
    <String, dynamic>{
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'plan': instance.plan,
      'moneySaved': instance.moneySaved,
      'hasUberOne': instance.hasUberOne,
    };
