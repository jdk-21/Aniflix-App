import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/api/objects/anime/Anime.dart';
import 'package:aniflix_app/api/objects/anime/AnimeSeason.dart';

class EpisodeList extends StatelessWidget {
  AnimeSeason season;
  Anime anime;

  EpisodeList(this.season, this.anime);

  @override
  Widget build(BuildContext ctx) {
    var episodes = season == null ? null : season.episodes;
    List<Widget> episodeList;
    if (episodes == null) {
      episodeList = [];
    } else {
      episodeList = [
        Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ThemeText("Episodes",
                  fontWeight: FontWeight.bold, fontSize: 20),
              Icon(
                Icons.thumbs_up_down,
                color: Theme.of(ctx).primaryIconTheme.color,
                size: 30,
              )
            ],
          ),
        )
      ];
      for (int v = 0; v < episodes.length; v++) {
        var actualEpisode = episodes.elementAt(v);
        bool ger = false;
        bool jap = false;
        for (var stream in actualEpisode.streams) {
          if (stream.lang == "SUB") {
            jap = true;
          } else if (stream.lang == "DUB") {
            ger = true;
          }
          if (jap && ger) break;
        }
        Widget image = SizedBox();
        if (ger && jap) {
          image = Image.asset('assets/images/gerjap.png', scale: 10);
        } else if (ger) {
          image = Image.asset('assets/images/ger.png', scale: 50);
        } else if (jap) {
          image = Image.asset('assets/images/jap.png', scale: 50);
        }
        Widget seen = Container();
        if (actualEpisode.seen == 1) {
          seen = Container(
            padding: EdgeInsets.all(5),
            color: Colors.blue,
            child: Text(
              "Gesehen",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        episodeList.add(Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(ctx).hintColor,
                      style: BorderStyle.solid))),
          child: FlatButton(
            padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Row(
                  children: <Widget>[
                    image,
                    SizedBox(
                      width: 5,
                    ),
                    ThemeText(
                        actualEpisode == null
                            ? "---"
                            : actualEpisode.number.toString() + ". ",
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    Expanded( child:
                        ThemeText(
                          actualEpisode == null ? "---" : actualEpisode.name,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ),
                    seen
                  ],
                )),
                SizedBox(width: 5,),
                ThemeText(
                    actualEpisode.avgVotes == null
                        ? ""
                        : (double.parse(actualEpisode.avgVotes) * 100)
                                .round()
                                .toString() +
                            "%")
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(ctx, "episode",arguments: EpisodeScreenArguments(anime.url,season.number, actualEpisode.number));
            },
          ),
        ));
      }
    }
    return Column(children: episodeList);
  }
}
