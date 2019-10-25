import 'package:flutter/material.dart';

class AniflixAppbar extends AppBar {
  AniflixAppbar()
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
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {},
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
            color: Colors.white,
          ),

        ]);
}
