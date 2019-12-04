import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/chat/chatMessage.dart';
import 'package:aniflix_app/components/custom/chat/chatComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatInput extends StatelessWidget {
  Function(String) onSend;
  List<ChatMessage> chat;

  ChatInput(this.chat, this.onSend);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    var textField = TextField(
      style: TextStyle(color: Theme.of(context).textTheme.title.color),
      keyboardType: TextInputType.multiline,
      controller: controller,
      maxLines: null,
      //maxLength: 1000,
      decoration: InputDecoration(
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: 'Nachricht'),
    );

    return Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          children: <Widget>[
            Expanded(child: textField),
            IconButton(
                icon: Icon(Icons.send),
                color: Theme.of(context).primaryIconTheme.color,
                onPressed: () {
                  onSend(controller.text);
                  controller.text = "";
                  FocusScope.of(context).requestFocus(new FocusNode());
                }),
          ],
        ));
  }
}
