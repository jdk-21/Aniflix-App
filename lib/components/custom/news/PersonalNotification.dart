import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/news/aniflix_notification.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class PersonalNotification extends AniflixNotification {
  PersonalNotification(int _id, String _message, Function onPress,
      Function(int) onDelete, BuildContext ctx)
      : super(Row(children: [
          Expanded(
            child: FlatButton(
              onPressed: onPress,
              child: ThemeText(
                _message,
                softWrap: true,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              APIManager.deleteNotification(_id);
              onDelete(_id);
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(ctx).primaryIconTheme.color,
            ),
          )
        ]));
}
