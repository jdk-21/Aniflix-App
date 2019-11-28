import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Watchlist extends StatelessWidget {
  MainWidgetState state;
  Future<List<Show>> watchlistdata;
  List<Show> watchlist;

  Watchlist(this.state) {
    watchlistdata = APIManager.getWatchlist();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("watchlist"),
      child: FutureBuilder(
        future: watchlistdata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            watchlist = snapshot.data;
            return Container(
              padding: EdgeInsets.all(5),
              color: Theme.of(ctx).backgroundColor,
              child: ListView(
                children: getWatchlistAsWidgets(ctx, watchlist),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  List<Widget> getWatchlistAsWidgets(BuildContext ctx, List<Show> watchlist) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Watchlist", ctx,
              fontSize: 30, fontWeight: FontWeight.bold))
    ];
    for (var anime in watchlist) {
      watchlistWidget.add(ImageListElement(anime.name,anime.cover_portrait,ctx,onTap: (){
        state.changePage(AnimeScreen(anime.url, state), 6);
      }));
    }
    return watchlistWidget;
  }
}
