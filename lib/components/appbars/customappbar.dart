import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/requests/user/ProfileRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/images/ProfileImage.dart';
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
                    width: 70,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        ctx, 'home', (Route<dynamic> route) => false);
                    AppState.setIndex(0);
                  }),
            ]),
            leadingWidth: 30,
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
                      future: ProfileRequests.getUser(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          CacheManager.userData = snapshot.data;
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => AppState.updateState());
                        }
                        return ProfileImage(
                            (snapshot.data == null)
                                ? null
                                : snapshot.data.avatar, () {
                          Navigator.pushNamed(ctx, "settings");
                        });
                      },
                    )
                  : ProfileImage(CacheManager.userData.avatar, () {
                      Navigator.pushNamed(ctx, "settings");
                    })
            ]);
}
