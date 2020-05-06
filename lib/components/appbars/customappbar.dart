import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';

class AniflixAppbar extends AppBar {
  AniflixAppbar(AppState state, BuildContext ctx)
      : super(
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              FlatButton(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    height: 32,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        ctx, 'home', (Route<dynamic> route) => false);
                    AppState.setIndex(0);
                  }),
            ]),
            actions: <Widget>[
              IconButton(
                key: Key("Search"),
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(ctx, "search");
                },
                color: Theme.of(ctx).primaryIconTheme.color,
              ),
              IconButton(
                key: Key("News"),
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(ctx, "news");
                },
                color: Theme.of(ctx).primaryIconTheme.color,
              ),
              IconButton(
                key: Key("Calendar"),
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  Navigator.pushNamed(ctx, "calendar");
                },
                color: Theme.of(ctx).primaryIconTheme.color,
              ),
              (CacheManager.userData == null)
                  ? FutureBuilder<User>(
                      future: APIManager.getUser(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          CacheManager.userData = snapshot.data;
                          return (snapshot.data.avatar == null)
                              ? IconButton(
                                  key: Key("Settings"),
                                  icon: Icon(
                                    Icons.person,
                                    color: Theme.of(ctx).primaryIconTheme.color,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(ctx, "settings");
                                  },
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
                                  onPressed: () {
                                    Navigator.pushNamed(ctx, "settings");
                                  },
                                );
                        } else if (snapshot.hasError) {
                          return IconButton(
                              key: Key("Settings"),
                              icon: Icon(Icons.person),
                              onPressed: () {
                                Navigator.pushNamed(ctx, "settings");
                              },
                              color: Theme.of(ctx).primaryIconTheme.color);
                        }
                        return IconButton(
                            key: Key("Settings"),
                            icon: Icon(Icons.person),
                            onPressed: () {
                              Navigator.pushNamed(ctx, "settings");
                            },
                            color: Theme.of(ctx).primaryIconTheme.color);
                      },
                    )
                  : (CacheManager.userData.avatar == null)
                      ? IconButton(
                          key: Key("Settings"),
                          icon: Icon(
                            Icons.person,
                            color: Theme.of(ctx).primaryIconTheme.color,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(ctx, "settings");
                          },
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
                                          CacheManager.userData.avatar,
                                    ),
                                  ))),
                          onPressed: () {
                            Navigator.pushNamed(ctx, "settings");
                          },
                        ) //TODO
            ]);
}
