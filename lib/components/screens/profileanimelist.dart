import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/objects/profile/UserAnimeListData.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/profile/UserSubData.dart';

import '../../main.dart';

class ProfileAnimeList extends StatefulWidget implements Screen {
  int userid;

  ProfileAnimeList(this.userid);

  @override
  getScreenName() {
    return "profileanimelist_screen";
  }

  @override
  State<StatefulWidget> createState() => ProfileAnimeListState(userid);
}

class ProfileAnimeListState extends State<ProfileAnimeList> {
  Future<UserAnimeListData> profilelistdata;
  UserAnimeListData data;
  int userid;

  ProfileAnimeListState(this.userid){
    profilelistdata = APIManager.getUserSeen(userid);
  }

  @override
  Widget build(BuildContext ctx) {
      return Container(
        key: Key("profileanimelist_screen"),
        color: Theme.of(ctx).backgroundColor,
        child: FutureBuilder(
          future: profilelistdata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data;
              return getLayout(ctx);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
  }

  getLayout(BuildContext ctx) {
    return Container(
                padding: EdgeInsets.all(5),
                color: Theme.of(ctx).backgroundColor,
                child: RefreshIndicator(
                    child: ListView(
                      children: getShowsAsWidgets(ctx, data.shows),
                    ),
                    onRefresh: () async {
                      APIManager.getUserSeen(userid).then((newdata) {
                        setState(() {
                          data = newdata;
                        });
                      });
                    }));
  }

  List<Widget> getShowsAsWidgets(BuildContext ctx, List<UserSeenShow> watchlist) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Anime Gesehen:",
              fontSize: 30, fontWeight: FontWeight.bold))
    ];
    for (var anime in watchlist) {
      watchlistWidget.add(
          ImageListElement(anime.name, anime.cover_portrait, ctx, onTap: () {
            Navigator.pushNamed(ctx, "anime", arguments: anime.url);
          }));
    }
    return watchlistWidget;
  }
}
