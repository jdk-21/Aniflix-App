import 'package:aniflix_app/api/objects/AnimeSeason.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/objects/Anime.dart';
import '../../api/APIManager.dart';
import 'package:expandable/expandable.dart';
import 'package:aniflix_app/api/objects/Episode.dart';


class AnimeScreen extends StatelessWidget {
  Future<Anime> anime;

  AnimeScreen(String name) {
    this.anime = APIManager.getAnime(name);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
        key: Key("anime_screen"),
        child: FutureBuilder<Anime>(
          future: anime,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var anime = snapshot.data;
              var episodeCount = 0;
              if (anime.seasons != null) {
                for (var season in anime.seasons) {
                  episodeCount += season.length;
                }
              }
              int actualSeason = 0;
              return Container(
                  color: Theme.of(ctx).backgroundColor,
                  child: ListView(
                      padding: EdgeInsets.only(top: 10, left: 5),
                      children: [
                        Row(
                          children: [
                            Image.network(
                              "https://www2.aniflix.tv/storage/" +
                                  anime.cover_portrait,
                              width: 100,
                              height: 150,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    anime.name,
                                    style: TextStyle(
                                      color:
                                      Theme.of(ctx).textTheme.title.color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Score: " + anime.rating,
                                    style: TextStyle(
                                      color:
                                      Theme.of(ctx).textTheme.title.color,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Status: " +
                                        ((anime.airing != null)
                                            ? "Airing"
                                            : "Not Airing"),
                                    style: TextStyle(
                                      color:
                                      Theme.of(ctx).textTheme.title.color,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Episoden: " + episodeCount.toString(),
                                    style: TextStyle(
                                      color:
                                      Theme.of(ctx).textTheme.title.color,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: ExpandablePanel(
                            header: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Beschreibung",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                )),
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            collapsed: Text(
                              anime.description,
                              maxLines: 5,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.title.color,
                                  fontSize: 15),
                            ),
                            expanded: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  anime.description,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                      fontSize: 15),
                                  softWrap: true,
                                )),
                            tapHeaderToExpand: true,
                            hasIcon: true,
                            iconColor: Theme.of(ctx).primaryIconTheme.color,
                            tapBodyToCollapse: true,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                OutlineButton(
                                  onPressed: () {},
                                  child: Text(anime.subscribed.contains("true")
                                      ? "Deabonnieren"
                                      : "Abonnieren"),
                                  textColor: anime.subscribed.contains("true")
                                      ? Theme.of(ctx).primaryIconTheme.color
                                      : Theme.of(ctx).accentIconTheme.color,
                                  borderSide: BorderSide(
                                      color: anime.subscribed.contains("true")
                                          ? Theme.of(ctx).primaryIconTheme.color
                                          : Theme.of(ctx)
                                              .accentIconTheme
                                              .color),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(anime.watchlist.contains("true")
                                        ? Icons.playlist_add_check
                                        : Icons.playlist_add),
                                    color: anime.favorite.contains("false")
                                        ? Theme.of(ctx).primaryIconTheme.color
                                        : Theme.of(ctx).accentIconTheme.color),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                        anime.favorite.contains("true")
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: anime.favorite.contains("false")
                                            ? Theme.of(ctx)
                                                .primaryIconTheme
                                                .color
                                            : Theme.of(ctx)
                                                .accentIconTheme
                                                .color)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.assessment,
                                      color:
                                          Theme.of(ctx).primaryIconTheme.color,
                                    )),
                                Theme(
                                    data: Theme.of(ctx).copyWith(
                                        canvasColor:
                                            Theme.of(ctx).backgroundColor),
                                    child: DropdownButton<int>(
                                      style: TextStyle(
                                          color: Theme.of(ctx)
                                              .textTheme
                                              .title
                                              .color,
                                          fontSize: 15),
                                      items: GetSeasonsAsDropdownList(
                                              anime.seasonCount, anime.seasons)
                                          .getItems(),
                                      onChanged: (newValue) {
                                        actualSeason = newValue;
                                      },
                                      value: (actualSeason == null)
                                          ? null
                                          : actualSeason,
                                      hint: Text(
                                        "Seasons",
                                        style: TextStyle(
                                            color: Theme.of(ctx)
                                                .textTheme
                                                .title
                                                .color),
                                      ),
                                    ))
                              ],
                            )),
                        Column(
                            children: EpisodeList().getEpisodesAsList(ctx,
                                actualSeason == null ? null : anime.seasons.elementAt(actualSeason).episodes))
                      ]));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ));
  }
}

class AnimeInfo extends Container {
  Anime anime;

  AnimeInfo(this.anime);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }
}

class AnimeDescription extends Container {
  String description;

  AnimeDescription(this.description);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }
}

class GetSeasonsAsDropdownList {
  int seasonCount;
  List<AnimeSeason> seasons;

  GetSeasonsAsDropdownList(this.seasonCount, this.seasons);

  List<DropdownMenuItem<int>> getItems() {
    List<DropdownMenuItem<int>> namelist = [];
    for (int l = 0; l < seasonCount; l++) {
      namelist.add(DropdownMenuItem(
          value: l,
          child:
              Text("Season " + (seasons.elementAt(l).number).toString())));
    }
    return namelist;
  }
}

class EpisodeList extends Container {
  EpisodeList() : super();

  List<Widget> getEpisodesAsList(BuildContext ctx, List<Episode> episodes) {
    if(episodes == null){
      return [];
    }
    List<Widget> episodeList = [
      Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Episodes",
                style: TextStyle(
                    color: Theme.of(ctx).textTheme.title.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Icon(
              Icons.thumbs_up_down,
              color: Theme.of(ctx).primaryIconTheme.color,size: 30,
            )
          ],
        ),
      )
    ];
    for (int v = 0; v < episodes.length; v++) {
      var actualEpisode = episodes.elementAt(v);
      episodeList.add(Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(ctx).hintColor,
                      style: BorderStyle.solid))),
          child: FlatButton(padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    actualEpisode.number.toString() + ". " + actualEpisode.name,
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 15,fontWeight: FontWeight.normal)),
                Text(
                    (double.parse(actualEpisode.avgVotes) * 100)
                        .round()
                        .toString() +
                        "%",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 20, fontWeight: FontWeight.normal))
              ],
            ),
            onPressed: () {},)
      ));
    }
    return episodeList;
  }
}