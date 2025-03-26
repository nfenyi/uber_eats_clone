import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'onboarding_state_model.freezed.dart';

part 'onboarding_state_model.g.dart';

// class OnboardingState {
//   final AddressDetails addressDetails;

//   OnboardingState({required this.addressDetails});
// }

@freezed
class AddressDetails with _$AddressDetails {
  const factory AddressDetails(
      {required String instruction,
      required String apartment,
      // @GeoPointConverter() required GeoPoint latlng,
      required Object latlng,
      required String addressLabel,
      required String placeDescription,
      required String building,
      required String dropoffOption}) = _AddressDetails;

  factory AddressDetails.fromJson(Map<String, Object?> json) =>
      _$AddressDetailsFromJson(json);
}
