import 'package:json_annotation/json_annotation.dart';

part 'hasJoinedChat.g.dart';

@JsonSerializable()
class HasJoinedChat {
  HasJoinedChat();

  late bool chat;
  
  factory HasJoinedChat.fromJson(Map<String,dynamic> json) => _$HasJoinedChatFromJson(json);
  Map<String, dynamic> toJson() => _$HasJoinedChatToJson(this);
}
