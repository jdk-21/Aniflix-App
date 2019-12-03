import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/chat/chatMessage.dart';
import 'package:aniflix_app/components/custom/chat/chatComponent.dart';
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

class ChatState extends State<ChatScreen>{

  Future<List<ChatMessage>> chatdata;
  List<ChatComponent> messages = [];

  ChatState(MainWidgetState state){
    chatdata = APIManager.getChatMessages();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("home_screen"),
      child: FutureBuilder<List<ChatMessage>>(
        future: chatdata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for(var message in snapshot.data){
              messages.add(ChatComponent(message, ctx));
            }
            //messages.add(chatInput);
            return Container(
                color: Theme.of(ctx).backgroundColor,
                child: ListView(reverse: true, padding: EdgeInsets.only(top: 10), children: messages));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),);
  }
}