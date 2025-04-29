// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FamilyProfileImpl _$$FamilyProfileImplFromJson(Map<String, dynamic> json) =>
    _$FamilyProfileImpl(
      id: json['id'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      organizer: json['organizer'] as String,
      receiptEmail: json['receiptEmail'] as String,
      paymentMethod: json['paymentMethod'] as String,
    );

Map<String, dynamic> _$$FamilyProfileImplToJson(_$FamilyProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'members': instance.members.map((e) => e.toJson()).toList(),
      'organizer': instance.organizer,
      'receiptEmail': instance.receiptEmail,
      'paymentMethod': instance.paymentMethod,
    };

_$FamilyMemberInviteImpl _$$FamilyMemberInviteImplFromJson(
        Map<String, dynamic> json) =>
    _$FamilyMemberInviteImpl(
      id: json['id'] as String,
      familyProfileId: json['familyProfileId'] as String,
      name: json['name'] as String,
      dob: DateTime.parse(json['dob'] as String),
    );

Map<String, dynamic> _$$FamilyMemberInviteImplToJson(
        _$FamilyMemberInviteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyProfileId': instance.familyProfileId,
      'name': instance.name,
      'dob': instance.dob.toIso8601String(),
    };

_$FamilyMemberImpl _$$FamilyMemberImplFromJson(Map<String, dynamic> json) =>
    _$FamilyMemberImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      dob: DateTime.parse(json['dob'] as String),
    );

Map<String, dynamic> _$$FamilyMemberImplToJson(_$FamilyMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob.toIso8601String(),
    };
