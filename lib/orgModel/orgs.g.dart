// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orgs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Orgs _$OrgsFromJson(Map<String, dynamic> json) => Orgs()
  ..name = json['name'] as String
  ..id = json['id'] as String
  ..public = json['public'] as bool;

Map<String, dynamic> _$OrgsToJson(Orgs instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'public': instance.public,
    };
