import 'package:json_annotation/json_annotation.dart';
import "orgs.dart";
part 'activeOrg.g.dart';

@JsonSerializable()
class ActiveOrg {
  ActiveOrg();

  late String avatar;
  late String email;
  late String id;
  late String username;
  late String firstName;
  late String lastName;
  late String displayName;
  late String avatarKey;
  late String createdAt;
  late String updatedAt;
  late List<Orgs> orgs;
  
  factory ActiveOrg.fromJson(Map<String,dynamic> json) => _$ActiveOrgFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveOrgToJson(this);
}
