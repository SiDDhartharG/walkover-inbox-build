// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activeOrg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveOrg _$ActiveOrgFromJson(Map<String, dynamic> json) => ActiveOrg()
  ..avatar = json['avatar'] == null ? "" : json['avatar'] as String
  ..email = json['email'] == null ? "" : json['email'] as String
  ..id = json['id'] == null ? "" : json['id'] as String
  ..username = json['username'] == null ? "" : json['username'] as String
  ..firstName = json['firstName'] == null ? "" : json['firstName'] as String
  ..lastName = json['lastName'] == null ? "" : json['lastName'] as String
  ..displayName =
      json['displayName'] == null ? "" : json['displayName'] as String
  ..avatarKey = json['avatarKey'] == null ? "" : json['avatarKey'] as String
  ..createdAt = json['createdAt'] == null ? "" : json['createdAt'] as String
  ..updatedAt = json['updatedAt'] == null ? "" : json['updatedAt'] as String
  ..orgs = (json['orgs'] as List<dynamic>)
      .map((e) => Orgs.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ActiveOrgToJson(ActiveOrg instance) => <String, dynamic>{
      'avatar': instance.avatar,
      'email': instance.email,
      'id': instance.id,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'displayName': instance.displayName,
      'avatarKey': instance.avatarKey,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'orgs': instance.orgs,
    };
