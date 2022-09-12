import 'package:json_annotation/json_annotation.dart';

part 'orgs.g.dart';

@JsonSerializable()
class Orgs {
  Orgs();

  String name;
  String id;
  bool public;

  factory Orgs.fromJson(Map<String, dynamic> json) => _$OrgsFromJson(json);
  Map<String, dynamic> toJson() => _$OrgsToJson(this);
}
