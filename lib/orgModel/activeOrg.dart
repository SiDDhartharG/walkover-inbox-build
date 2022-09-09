import 'package:json_annotation/json_annotation.dart';
import "orgs.dart";
part 'activeOrg.g.dart';

@JsonSerializable()
class ActiveOrg {
  ActiveOrg();

  String avatar;
  String email;
  String id;
  String username;
  String firstName;
  String lastName;
  String displayName;
  String avatarKey;
  String createdAt;
  String updatedAt;
  List<Orgs> orgs;

  factory ActiveOrg.fromJson(Map<String, dynamic> json) =>
      _$ActiveOrgFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveOrgToJson(this);
}
