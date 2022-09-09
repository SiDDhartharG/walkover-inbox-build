// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productsJoined.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsJoined _$ProductsJoinedFromJson(Map<String, dynamic> json) =>
    ProductsJoined()
      ..channel = json['channel'] as bool
      ..okr = json['okr'] as bool
      ..inbox = json['inbox'] as bool;

Map<String, dynamic> _$ProductsJoinedToJson(ProductsJoined instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'okr': instance.okr,
      'inbox': instance.inbox,
    };
