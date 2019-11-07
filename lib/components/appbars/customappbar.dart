import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/navigationbars/mainbar.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';
import '../screens/calendar.dart';
import '../screens/settings.dart';

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
          color: Theme
              .of(ctx)
              .primaryIconTheme
              .color,
        ),
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
          color: Theme
              .of(ctx)
              .primaryIconTheme
              .color,
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            state.changePage(Calendar(state), 10);
          },
          color: Theme
              .of(ctx)
              .primaryIconTheme
              .color,
        ),
        FutureBuilder<User>(
          future: APIManager.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return IconButton(
                  icon: new Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image:  NetworkImage(
                                "https://www2.aniflix.tv/storage/" + snapshot.data.avatar,
                              ),
                          )
                      )),

                  onPressed: () {
                    state.changePage(Settings(state), 3);
                  },
                  color: Theme
                      .of(ctx)
                      .primaryIconTheme
                      .color);
            } else if (snapshot.hasError) {
              return IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    state.changePage(Settings(state), 3);
                  },
                  color: Theme.of(ctx).primaryIconTheme
                      .
                  color
              );
            }

            // By default, show a loading spinner.
            return IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
            state.changePage(Settings(state), 3);
            },
            color: Theme.of(ctx).primaryIconTheme
            .
            color
            );

          },
        ),

      ]);
}
