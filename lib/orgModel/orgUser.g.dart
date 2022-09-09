// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orgUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrgUser _$OrgUserFromJson(Map<String, dynamic> json) => OrgUser()
  ..id = json['id'] as String
  ..orgId = json['orgId'] as String
  ..userId = json['userId'] as String
  ..status = json['status'] as String
  ..role = json['role'] as num
  ..isEnabled = json['isEnabled'] as bool
  ..disconnectedAt = json['disconnectedAt'] as String
  ..productsJoined =
      ProductsJoined.fromJson(json['productsJoined'] as Map<String, dynamic>)
  ..createdAt = json['createdAt'] as String
  ..updatedAt = json['updatedAt'] as String;

Map<String, dynamic> _$OrgUserToJson(OrgUser instance) => <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'userId': instance.userId,
      'status': instance.status,
      'role': instance.role,
      'isEnabled': instance.isEnabled,
      'disconnectedAt': instance.disconnectedAt,
      'productsJoined': instance.productsJoined,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
