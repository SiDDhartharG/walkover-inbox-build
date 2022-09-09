import 'package:json_annotation/json_annotation.dart';

part 'webhooks.g.dart';

@JsonSerializable()
class Webhooks {
  Webhooks();

  
  factory Webhooks.fromJson(Map<String,dynamic> json) => _$WebhooksFromJson(json);
  Map<String, dynamic> toJson() => _$WebhooksToJson(this);
}
