import 'package:aniflix_app/components/navigationbars/mainbar.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';

class AniflixAppbar extends AppBar {
  AniflixAppbar(MainWidgetState state, BuildContext ctx)
      : super(
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
            state.changePage(10);
            ScreenManager.getInstance(state).setCurrentTab(10);
          },
          color: Theme.of(ctx).primaryIconTheme.color,
        ),
        IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              state.changePage(3);
              ScreenManager.getInstance(state).setCurrentTab(3);
            },
            color: Theme.of(ctx).primaryIconTheme.color
        ),
      ]);
}
