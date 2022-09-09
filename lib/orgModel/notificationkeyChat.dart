import 'package:json_annotation/json_annotation.dart';

part 'notificationkeyChat.g.dart';

@JsonSerializable()
class NotificationkeyChat {
  NotificationkeyChat();

  late String chat;
  
  factory NotificationkeyChat.fromJson(Map<String,dynamic> json) => _$NotificationkeyChatFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationkeyChatToJson(this);
}
