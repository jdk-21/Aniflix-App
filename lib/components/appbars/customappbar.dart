import 'package:flutter/material.dart';

class AniflixAppbar extends AppBar {
  AniflixAppbar(BuildContext ctx)
      : super(title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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



            },
            color: Theme.of(ctx).primaryIconTheme.color,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
            color: Theme.of(ctx).primaryIconTheme.color,
          ),

        ]);
}
