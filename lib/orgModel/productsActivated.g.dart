// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productsActivated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsActivated _$ProductsActivatedFromJson(Map<String, dynamic> json) =>
    ProductsActivated()
      ..doc = json['doc'] as bool
      ..okr = json['okr'] as bool
      ..meet = json['meet'] as bool
      ..inbox = json['inbox'] as bool
      ..sprint = json['sprint'] as bool
      ..channel = json['channel'] as bool;

Map<String, dynamic> _$ProductsActivatedToJson(ProductsActivated instance) =>
    <String, dynamic>{
      'doc': instance.doc,
      'okr': instance.okr,
      'meet': instance.meet,
      'inbox': instance.inbox,
      'sprint': instance.sprint,
      'channel': instance.channel,
    };
