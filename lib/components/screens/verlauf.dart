import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/objects/history/historyEpisode.dart';
import 'package:aniflix_app/components/screens/episode.dart';
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
                children: getWatchlistAsWidgets(ctx, history),
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

  List<Widget> getWatchlistAsWidgets(
      BuildContext ctx, List<HistoryEpisode> history) {
    List<Widget> watchlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: Text("Verlauf",
              style: TextStyle(
                  color: Theme.of(ctx).textTheme.title.color,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)))
    ];

    for (var anime in history) {
      watchlistWidget.add(Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
        child: FlatButton(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
          onPressed: () {
            state.changePage(
                EpisodeScreen(state, anime.season.show.url, anime.season.number,
                    anime.number),
                6);
          },
          child: Row(
            children: <Widget>[
              Image.network(
                "https://www2.aniflix.tv/storage/" +
                    anime.season.show.cover_portrait,
                width: 70,
                height: 100,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        anime.name,
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.title.color,
                            fontSize: 20),
                        softWrap: true,
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        anime.season.show.name,
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.title.color,
                            fontSize: 15),
                        softWrap: true,
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Episode " +
                            anime.number.toString() +
                            " Season " +
                            anime.season.number.toString(),
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.title.color,
                            fontSize: 15),
                        softWrap: true,
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gesehen am " +
                            DateTime.parse(anime.seen).day.toString() +
                            "." +
                            DateTime.parse(anime.seen).month.toString() +
                            "." +
                            DateTime.parse(anime.seen).year.toString(),
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.title.color,
                            fontSize: 15),
                        softWrap: true,
                      )),
                ],
              ))
            ],
          ),
        ),
      ));
    }
    return watchlistWidget;
  }
}
