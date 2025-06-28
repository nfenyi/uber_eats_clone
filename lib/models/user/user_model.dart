import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:uber_eats_clone/presentation/constants/other_constants.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserDetails with _$UserDetails {
  factory UserDetails({
    @Default([]) List<UserAddress> addresses,
    UberCash? uberCash,
    UserAddress? selectedAddresses,
    @Default([]) List<String> businessProfileIds,
    @Default([]) List<String> groupOrders,
    @Default([]) List<String> redeemedPromos,
    @Default([]) List<String> redeemedVouchers,
    @Default([]) List<String> usedPromos,
    @Default([]) List<String> usedVouchers,
    @Default(OtherConstants.na) displayName,
    @Default(false) hasUberOne,
    @Default(false) onboarded,
    String? selectedBusinessProfileId,
    @Default('Personal') String type,
    String? familyProfile,
    UberOneStatus? uberOneStatus,
  }) = _UserDetails;
  factory UserDetails.fromJson(Map<String, Object?> json) =>
      _$UserDetailsFromJson(json);
}

@freezed
class UserAddress with _$UserAddress {
  factory UserAddress({
    @Default(OtherConstants.na) String apartment,
    @Default(OtherConstants.na) String building,
    @Default(OtherConstants.na) String dropoffOption,
    @Default(OtherConstants.na) String instruction,
    @Default(OtherConstants.na) String placeDescription,
    @Default(GeoPoint(0, 0)) Object latlng,
  }) = _UserAddress;
  factory UserAddress.fromJson(Map<String, Object?> json) =>
      _$UserAddressFromJson(json);
}

@freezed
class UberCash with _$UberCash {
  factory UberCash({
    @Default(0) double balance,
    @Default(0) double cashAdded,
    @Default(0) double cashSpent,
    @Default(false) bool isActive,
  }) = _UberCash;
  factory UberCash.fromJson(Map<String, Object?> json) =>
      _$UberCashFromJson(json);
}

@freezed
class UberOneStatus with _$UberOneStatus {
  factory UberOneStatus({
    DateTime? expirationDate,
    String? plan,
    @Default(0) double moneySaved,
    @Default(false) bool hasUberOne,
  }) = _UberOneStatus;
  factory UberOneStatus.fromJson(Map<String, Object?> json) =>
      _$UberOneStatusFromJson(json);
}
