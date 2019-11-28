import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/history/historyEpisode.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';

class Verlauf extends StatelessWidget {
  MainWidgetState state;
  Future<List<HistoryEpisode>> historyData;

  Verlauf(this.state) {
    historyData = APIManager.getHistory();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("history"),
      child: FutureBuilder(
        future: historyData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HistoryEpisode> history = snapshot.data;
            return Container(
              padding: EdgeInsets.all(5),
              color: Theme.of(ctx).backgroundColor,
              child: ListView(
                children: getHistoryAsWidgets(ctx, history),
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

  List<Widget> getHistoryAsWidgets(
      BuildContext ctx, List<HistoryEpisode> history) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Verlauf", ctx,
              fontSize: 30, fontWeight: FontWeight.bold))
    ];

    for (var anime in history) {
      watchlistWidget.add(ImageListElement(
        anime.name,
        anime.season.show.cover_portrait,
        ctx,
        onTap: () {
          state.changePage(
              EpisodeScreen(state, anime.season.show.url, anime.season.number,
                  anime.number),
              6);
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
