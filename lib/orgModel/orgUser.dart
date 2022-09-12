import 'package:json_annotation/json_annotation.dart';
import "productsJoined.dart";
part 'orgUser.g.dart';

@JsonSerializable()
class OrgUser {
  OrgUser();

  String id;
  String orgId;
  String userId;
  String status;
  num role;
  bool isEnabled;
  String disconnectedAt;
  ProductsJoined productsJoined;
  String createdAt;
  String updatedAt;

  factory OrgUser.fromJson(Map<String, dynamic> json) =>
      _$OrgUserFromJson(json);
  Map<String, dynamic> toJson() => _$OrgUserToJson(this);
}
