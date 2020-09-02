import 'dart:convert';

import 'package:aniflix_app/api/objects/chat/chatMessage.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/api/requests/user/ProfileRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/chat.dart';

class ChatRequests {
  static Future<List<ChatMessage>> _getChatMessages() async {
    List<ChatMessage> messages = [];
    var response = await AniflixRequest("chat/1/0").get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var message = ChatMessage.fromJson(entry);
        messages.add(message);
      }
    }

    return messages;
  }

  static Future<ChatInfo> getChatInfo() async {
    var info = await _getChatMessages();
    var user = CacheManager.userData;

    return ChatInfo(info, user);
  }

  static Future<ChatMessage> addMessage(String text) async {
    var result = await AniflixRequest("chat")
        .post(bodyObject: {"chat_id": "1", "message": text});
    var json = jsonDecode(result.body);
    return ChatMessage.fromJson(json);
  }
}
