import 'package:json_annotation/json_annotation.dart';

part 'orgDetails.g.dart';

@JsonSerializable()
class OrgDetails {
  OrgDetails();

  
  factory OrgDetails.fromJson(Map<String,dynamic> json) => _$OrgDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$OrgDetailsToJson(this);
}
