import 'package:aniflix_app/api/objects/chat/chatMessage.dart';
import 'package:aniflix_app/components/custom/text/dateText.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatComponent extends StatelessWidget {
  ChatMessage message;

  ChatComponent(this.message);

  @override
  Widget build(BuildContext ctx) {
    return Container(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
        child: Row(
          children: <Widget>[
            (message.user.avatar == null)
                ? IconButton(
                    onPressed: () {Navigator.pushNamed(ctx, "profil",arguments: message.user.id);},
                    icon: Icon(
                      Icons.person,
                      color: Theme.of(ctx).primaryIconTheme.color,
                    ),
                  )
                : IconButton(
                    onPressed: () {Navigator.pushNamed(ctx, "profil",arguments: message.user.id);},
                    icon: new Container(
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                "https://www2.aniflix.tv/storage/" +
                                    message.user.avatar,
                              ),
                            ))),
                  ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ThemeText(
                            message.user.name,
                            ctx,
                            fontWeight: FontWeight.bold,
                            softWrap: true,
                            fontSize: 20,
                          ),
                          Row(
                            children: getUserGroups(ctx),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DateText(message.created_at, showTime: true,)
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ThemeText(
                      message.text,
                      ctx,
                      fontSize: 20,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  List<Container> getUserGroups(BuildContext ctx) {
    List<Container> usergroups = [];
    for (var group in message.user.groups) {
      usergroups.add(Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(left: 5),
        color: Theme.of(ctx).textTheme.caption.color,
        child: Text(
          group.name,
          style: TextStyle(color: Theme.of(ctx).backgroundColor),
        ),
      ));
    }
    return usergroups;
  }
}
