import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/navigationbars/mainbar.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';
import '../screens/calendar.dart';
import '../screens/settings.dart';

class AniflixAppbar extends AppBar {

  String avatar;

  static getAvatar () async {
    User user = await APIManager.getUser();
    return user.avatar;
  }

  AniflixAppbar(MainWidgetState state, BuildContext ctx)
    :super(

      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 32,
        )
      ]),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
          color: Theme.of(ctx).primaryIconTheme.color,
        ),
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
          color: Theme.of(ctx).primaryIconTheme.color,
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            state.changePage(Calendar(state),10);
          },
          color: Theme.of(ctx).primaryIconTheme.color,
        ),
        IconButton(
            icon: /*Icon(Icons.person),*/Image.asset(getAvatar()),
            onPressed: () {
              state.changePage(Settings(state),3);
            },
            color: Theme.of(ctx).primaryIconTheme.color
        ),
      ]);
}
