import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/chat/chatMessage.dart';
import 'package:aniflix_app/components/custom/chat/chatComponent.dart';
import 'package:aniflix_app/components/custom/chat/chatInput.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget implements Screen {
  ChatScreen();

  @override
  getScreenName() {
    return "chat_screen";
  }

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<ChatScreen> {
  Future<ChatInfo> chatdata;
  List<ChatMessage> _messages;

  ChatState() {
    chatdata = APIManager.getChatInfo();
  }

  addMessage(text) async {
    var message = await APIManager.addMessage(text);
    var analytics = AppState.analytics;
    analytics.logEvent(
        name: "send_chat_mesage", parameters: {"message_id": message.id});
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("chat_screen"),
      color: Theme.of(ctx).backgroundColor,
      child: FutureBuilder<ChatInfo>(
        future: chatdata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_messages == null) {
              _messages = snapshot.data.chatMessage;
            }
            List<Widget> widgets = [
              ChatInput(snapshot.data.chatMessage, (component) {
                addMessage(component);
              })
            ];
            _messages.forEach((message) {
              widgets.add(ChatComponent(message));
            });
            return Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                        color: Theme.of(ctx).backgroundColor,
                        child: ListView(
                            reverse: true,
                            padding: EdgeInsets.only(top: 10),
                            children: widgets)))
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ChatInfo {
  User user;
  List<ChatMessage> chatMessage;

  ChatInfo(this.chatMessage, this.user);
}
