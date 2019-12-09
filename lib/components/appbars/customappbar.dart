import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/screens/search.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';
import '../screens/calendar.dart';
import '../screens/settings.dart';
import '../screens/news.dart';

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
          key: Key("Search"),
          icon: Icon(Icons.search),
          onPressed: () {state.changePage(SearchAnime(state), 9);},
          color: Theme
              .of(ctx)
              .primaryIconTheme
              .color,
        ),
        IconButton(
          key: Key("News"),
          icon: Icon(Icons.notifications),
          onPressed: () {state.changePage(NewsPage(), 6);},
          color: Theme
              .of(ctx)
              .primaryIconTheme
              .color,
        ),
        IconButton(
          key: Key("Calendar"),
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
              return (snapshot.data.avatar == null)
                  ? IconButton(
                key: Key("Settings"),
                icon: Icon(
                  Icons.person,
                  color: Theme.of(ctx).primaryIconTheme.color,
                ),
                onPressed: () {state.changePage(Settings(state), 3);},
              )
                  : IconButton(
                key: Key("Settings"),
                icon: new Container(
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            "https://www2.aniflix.tv/storage/" +
                                snapshot.data.avatar,
                          ),
                        ))),
                onPressed: () {state.changePage(Settings(state), 3);},
              );
            } else if (snapshot.hasError) {
              return IconButton(
                  key: Key("Settings"),
                  icon: Icon(Icons.person),
                  onPressed: () {
                    state.changePage(Settings(state), 3);
                  },
                  color: Theme.of(ctx).primaryIconTheme
                      .
                  color
              );
            }
            return IconButton(
                key: Key("Settings"),
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
