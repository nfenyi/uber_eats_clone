import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_profile_model.freezed.dart';
part 'business_profile_model.g.dart';

@freezed
class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String id,
    String? creditCardNumber,
    required String? email,
    String? expenseProgram,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, Object?> json) =>
      _$BusinessProfileFromJson(json);
}
