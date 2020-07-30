import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/history/historyEpisode.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Historydata {
  List<HistoryEpisode> episodes;
  Historydata(this.episodes);
}

class Verlauf extends StatefulWidget implements Screen {
  @override
  getScreenName() {
    return "history_screen";
  }

  @override
  State<StatefulWidget> createState() => VerlaufState();
}

class VerlaufState extends State<Verlauf> {
  Future<Historydata> historyData;
  Historydata cache;

  VerlaufState() {
    if (CacheManager.historydata == null) {
      historyData = APIManager.getHistory();
    } else {
      cache = CacheManager.historydata;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null) {
      return Container(
        key: Key("history_screen"),
        color: Colors.transparent,
        child: FutureBuilder(
          future: historyData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CacheManager.historydata = snapshot.data;
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
          key: Key("history_screen"),
          color: Colors.transparent,
          child: getLayout(cache, ctx));
    }
  }

  getLayout(Historydata data, BuildContext ctx) {
    List<HistoryEpisode> history = data.episodes;
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.transparent,
                child: RefreshIndicator(
                  child: ListView(
                    children: getHistoryAsWidgets(ctx, history),
                  ),
                  onRefresh: () async {
                    APIManager.getHistory().then((data) {
                      setState(() {
                        CacheManager.historydata = data;
                        cache = data;
                      });
                    });
                  },
                )))
      ],
    );
  }

  List<Widget> getHistoryAsWidgets(
      BuildContext ctx, List<HistoryEpisode> history) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Verlauf",
              fontSize: 30, fontWeight: FontWeight.bold))
    ];

    for (var anime in history) {
      watchlistWidget.add(ImageListElement(
        anime.name,
        anime.season.show.cover_portrait,
        ctx,
        onTap: () {
          Navigator.pushNamed(ctx, "episode",
              arguments: EpisodeScreenArguments(
                  anime.season.show.url, anime.season.number, anime.number));
        },
        descLine1: anime.season.show.name,
        descLine2: "Episode " +
            anime.number.toString() +
            " Season " +
            anime.season.number.toString(),
        descLine3: "Gesehen am " +
            DateTime.parse(anime.seen).day.toString() +
            "." +
            DateTime.parse(anime.seen).month.toString() +
            "." +
            DateTime.parse(anime.seen).year.toString(),
      ));
    }
    return watchlistWidget;
  }
}
