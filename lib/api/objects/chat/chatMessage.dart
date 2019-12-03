import 'package:aniflix_app/api/objects/User.dart';

class ChatMessage{
  int id;
  int user_id;
  int chat_id;
  String text;
  String created_at;
  String updated_at;
  String deleted_at;
  User user;

  ChatMessage(this.id, this.user_id, this.chat_id, this.text, this.created_at, this.updated_at, this.deleted_at,
      this.user);

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        json["id"],
        json["user_id"],
        json["chat_id"],
        json["text"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        User.fromJson(json["user"]));
  }

  static List<ChatMessage> getMessages(List<dynamic> json) {
    List<ChatMessage> messages = [];
    for (var entry in json) {
      messages.add(ChatMessage.fromJson(entry));
    }
    return messages;
  }
}