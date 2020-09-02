
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/requests/favourite/FavouriteRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Favouritedata {
  List<Show> list;

  Favouritedata(this.list);
}

class Favoriten extends StatefulWidget implements Screen {
  Favouritedata favouritedata;

  Favoriten({this.favouritedata});

  @override
  getScreenName() {
    return "favourites_screen";
  }

  @override
  State<StatefulWidget> createState() => FavoritenState(cache: favouritedata);
}

class FavoritenState extends State<Favoriten> {
  Future<Favouritedata> favouriteData;
  Favouritedata cache;
  bool external;

  FavoritenState({this.cache}) {
    if (cache == null) {
      external = false;
      if (CacheManager.favouritedata == null) {
        if (CacheManager.session != null) favouriteData = FavouriteRequests.getFavourite();
      } else {
        cache = CacheManager.favouritedata;
      }
    } else {
      external = true;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (CacheManager.session == null) {
      return Center(child: ThemeText("Du musst dafür eingeloggt sein!"));
    }
    if (cache == null) {
      return Container(
        key: Key("favourites_screen"),
        color: Colors.transparent,
        child: FutureBuilder(
          future: favouriteData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CacheManager.favouritedata = snapshot.data;
              return getLayout(snapshot.data, ctx);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return getLayout(cache, ctx);
    }
}

  getLayout(Favouritedata data, BuildContext ctx) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.transparent,
          child: RefreshIndicator(
            child: ListView(
              children: getFavouritesAsWidgets(ctx, data.list),
            ),
            onRefresh: () async {
              if (!external) {
                FavouriteRequests.getFavourite().then((data) {
                  setState(() {
                    CacheManager.favouritedata = data;
                    cache = data;
                  });
                });
              }
            },
          ),
        ))
      ],
    );
  }

  List<Widget> getFavouritesAsWidgets(
      BuildContext ctx, List<Show> favouriteList) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Favoriten",
              fontSize: 30, fontWeight: FontWeight.bold))
    ];

    for (var anime in favouriteList) {
      watchlistWidget.add(ImageListElement(
        anime.name,
        anime.cover_portrait,
        ctx,
        onTap: () {
          Navigator.pushNamed(ctx, "anime", arguments: anime.url);
        },
      ));
    }
    return watchlistWidget;
  }
}
