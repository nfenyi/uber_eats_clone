import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_profile_model.freezed.dart';
part 'family_profile_model.g.dart';

@freezed
class FamilyProfile with _$FamilyProfile {
  const factory FamilyProfile({
    required String id,
    required List<FamilyMember> members,
    required String organizer,
    required String receiptEmail,
    required String paymentMethod,
  }) = _FamilyProfile;

  factory FamilyProfile.fromJson(Map<String, Object?> json) =>
      _$FamilyProfileFromJson(json);
}

@freezed
class FamilyMemberInvite with _$FamilyMemberInvite {
  const factory FamilyMemberInvite({
    required String id,
    required String familyProfileId,
    required String name,
    required DateTime dob,
  }) = _FamilyMemberInvite;

  factory FamilyMemberInvite.fromJson(Map<String, Object?> json) =>
      _$FamilyMemberInviteFromJson(json);
}

@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String id,
    required String name,
    required DateTime dob,
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, Object?> json) =>
      _$FamilyMemberFromJson(json);
}
