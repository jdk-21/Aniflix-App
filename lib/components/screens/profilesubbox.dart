import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/profile/UserSubData.dart';

import '../../main.dart';

class ProfileSubBox extends StatefulWidget implements Screen {
  int userid;

  ProfileSubBox(this.userid);

  @override
  getScreenName() {
    return "profilesubbox_screen";
  }

  @override
  State<StatefulWidget> createState() => ProfileSubBoxState(userid);
}

class ProfileSubBoxState extends State<ProfileSubBox> {
  Future<UserSubData> profilesubboxdata;
  UserSubData data;
  int userid;

  ProfileSubBoxState(this.userid){
    profilesubboxdata = APIManager.getUserSubs(userid);
  }

  @override
  Widget build(BuildContext ctx) {
      return Container(
        key: Key("profilesubbox_screen"),
        color: Theme.of(ctx).backgroundColor,
        child: FutureBuilder(
          future: profilesubboxdata,
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
                      children: getWatchlistAsWidgets(ctx, data.shows),
                    ),
                    onRefresh: () async {
                      APIManager.getUserSubs(userid).then((newdata) {
                        setState(() {
                          data = newdata;
                        });
                      });
                    }));
  }

  List<Widget> getWatchlistAsWidgets(BuildContext ctx, List<Show> watchlist) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Subbox", ctx,
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
