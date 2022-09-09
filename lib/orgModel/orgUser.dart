import 'package:json_annotation/json_annotation.dart';
import "productsJoined.dart";
part 'orgUser.g.dart';

@JsonSerializable()
class OrgUser {
  OrgUser();

  late String id;
  late String orgId;
  late String userId;
  late String status;
  late num role;
  late bool isEnabled;
  late String disconnectedAt;
  late ProductsJoined productsJoined;
  late String createdAt;
  late String updatedAt;
  
  factory OrgUser.fromJson(Map<String,dynamic> json) => _$OrgUserFromJson(json);
  Map<String, dynamic> toJson() => _$OrgUserToJson(this);
}
