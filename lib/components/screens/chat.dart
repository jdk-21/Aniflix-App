import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/chat/chatMessage.dart';
import 'package:aniflix_app/components/custom/chat/chatComponent.dart';
import 'package:aniflix_app/components/custom/chat/chatInput.dart';
import 'package:aniflix_app/components/custom/slider/slider_with_headline.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  MainWidgetState state;

  ChatScreen(this.state);

  @override
  ChatState createState() => ChatState(state);
}

class ChatState extends State<ChatScreen> {
  Future<ChatInfo> chatdata;
  List<ChatMessage> _messages;

  ChatState(MainWidgetState state) {
    chatdata = APIManager.getChatInfo();
  }

  addMessage(text) async {
    var message = await APIManager.addMessage(text);
    setState(() {
      _messages.insert(
          0, message);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("chat_screen"),
      child: FutureBuilder<ChatInfo>(
        future: chatdata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_messages == null) {
              _messages = snapshot.data.chatMessage;
            }
            List<Widget> widgets = [ChatInput(snapshot.data.chatMessage, (component) {
              addMessage(component);
            })];
            _messages.forEach((message){print("1"); widgets.add(ChatComponent(message));});
            return Container(
                color: Theme.of(ctx).backgroundColor,
                child: ListView(
                    reverse: true,
                    padding: EdgeInsets.only(top: 10),
                    children: widgets));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
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
