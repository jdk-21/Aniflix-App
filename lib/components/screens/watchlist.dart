import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/api/objects/profile/UserWatchlistData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Watchlistdata {
  List<Show> shows;

  Watchlistdata(this.shows);
}

class Watchlist extends StatefulWidget implements Screen {
  UserWatchlistData watchlistdata;

  Watchlist({this.watchlistdata});

  @override
  getScreenName() {
    return "watchlist_screen";
  }

  @override
  State<StatefulWidget> createState() =>
      WatchlistState(userwatchlistdata: this.watchlistdata);
}

class WatchlistState extends State<Watchlist> {
  Future<Watchlistdata> watchlistdata;
  Watchlistdata cache;
  UserWatchlistData userwatchlistdata;
  bool external;

  WatchlistState({this.userwatchlistdata}) {
    if (userwatchlistdata == null) {
      external = false;
      if (CacheManager.watchlistdata == null) {
        watchlistdata = APIManager.getWatchlist();
      } else {
        cache = CacheManager.watchlistdata;
      }
    } else {
      external = true;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null && !external) {
      return Container(
        key: Key("watchlist_screen"),
        color: Theme.of(ctx).backgroundColor,
        child: FutureBuilder(
          future: watchlistdata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return getLayout(snapshot.data, ctx);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Container(
          key: Key("watchlist_screen"),
          color: Theme.of(ctx).backgroundColor,
          child: getLayout(cache, ctx));
    }
  }

  getLayout(Watchlistdata data, BuildContext ctx) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.all(5),
                color: Theme.of(ctx).backgroundColor,
                child: RefreshIndicator(
                    child: ListView(
                      children: getWatchlistAsWidgets(ctx, (external)?userwatchlistdata.shows:data.shows),
                    ),
                    onRefresh: () async {
                      if (!external) {
                        APIManager.getWatchlist().then((data) {
                          setState(() {
                            CacheManager.watchlistdata = data;
                            cache = data;
                          });
                        });
                      }
                    })))
      ],
    );
  }

  List<Widget> getWatchlistAsWidgets(BuildContext ctx, List<Show> watchlist) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Watchlist",
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
