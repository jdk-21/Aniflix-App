import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favoriten extends StatelessWidget {
  MainWidgetState state;
  Future<List<Show>> favouriteData;
  List<Show> favouriteList;

  Favoriten(this.state) {
    favouriteData = APIManager.getFavourite();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("favourites"),
      child: FutureBuilder(
        future: favouriteData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            favouriteList = snapshot.data;
            return Container(
              padding: EdgeInsets.all(5),
              color: Theme.of(ctx).backgroundColor,
              child: ListView(
                children: getFavouritesAsWidgets(ctx, favouriteList),
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

  List<Widget> getFavouritesAsWidgets(
      BuildContext ctx, List<Show> favouriteList) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Favoriten", ctx,
              fontSize: 30, fontWeight: FontWeight.bold))
    ];

    for (var anime in favouriteList) {
      watchlistWidget.add(ImageListElement(
        anime.name,
        anime.cover_portrait,
        ctx,
        onTap: () {
          state.changePage(AnimeScreen(anime.url, state), 6);
        },
      ));
    }
    return watchlistWidget;
  }
}
