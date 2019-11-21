import 'package:aniflix_app/api/objects/anime/AnimeSeason.dart';
import 'package:aniflix_app/components/custom/text/highlighted_text_box.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/slider/TextboxSliderElement.dart';
import 'package:aniflix_app/components/slider/carousel/TextBoxCarousel.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/objects/anime/Anime.dart';
import '../../api/APIManager.dart';
import 'package:expandable/expandable.dart';
import 'package:aniflix_app/api/objects/Episode.dart';

class AnimeScreen extends StatefulWidget {
  var name;
  MainWidgetState state;

  AnimeScreen(this.name, this.state);

  @override
  AnimeScreenState createState() => AnimeScreenState(name, state);
}

class AnimeScreenState extends State<AnimeScreen> {
  MainWidgetState state;
  Future<Anime> anime;
  List<TextboxSliderElement> test = [];
  List<String> genreNames = [];
  bool _isSubscribed;
  int _actualSeason;
  bool _isInWatchlist;
  bool _isFavorite;
  bool _useData;

  toggleSubButton(bool isSubscribed) {
    setState(() {
      this._isSubscribed = isSubscribed;
    });
  }

  changeSeason(int newSeason) {
    setState(() {
      this._actualSeason = newSeason;
    });
  }

  addToWatchlist(bool newValue) {
    setState(() {
      this._isInWatchlist = newValue;
    });
  }

  addAsFavorite() {
    setState(() {
      this._isFavorite = !this._isFavorite;
    });
  }

  AnimeScreenState(String name, this.state) {
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
              if (_useData == null) {
                _isSubscribed = anime.subscribed == "true";
                _isInWatchlist = anime.watchlist == "true";
                _isFavorite = anime.favorite == "true";
                _useData = true;
              }
              if (snapshot.data.genres != null) {
                for (var genre in snapshot.data.genres) {
                  if(!genreNames.contains(genre.name)){
                    genreNames.add(genre.name);
                    test.add(TextboxSliderElement(genre.name));
                  }
                }
              }
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
                        SizedBox(height: 10,),
                        test.length < 1 ? SizedBox(height: 0,) : TextboxCarousel(test),
                        Container(
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                  onPressed: () {
                                    APIManager.setSubscription(anime.id, !_isSubscribed);
                                    toggleSubButton(!_isSubscribed);
                                  },
                                  child: Text(_isSubscribed
                                      ? "Deabonnieren"
                                      : "Abonnieren"),
                                  textColor: _isSubscribed
                                      ? Theme.of(ctx).primaryIconTheme.color
                                      : Theme.of(ctx).accentIconTheme.color,
                                  borderSide: BorderSide(
                                      color: _isSubscribed
                                          ? Theme.of(ctx).primaryIconTheme.color
                                          : Theme.of(ctx)
                                              .accentIconTheme
                                              .color),
                                ),
                                IconButton(
                                    onPressed: () {
                                      APIManager.setWatchlist(anime.id, !_isInWatchlist);
                                      addToWatchlist(!_isInWatchlist);
                                    },
                                    icon: Icon(_isInWatchlist
                                        ? Icons.playlist_add_check
                                        : Icons.playlist_add),
                                    color: _isInWatchlist
                                        ? Theme.of(ctx).accentIconTheme.color
                                        : Theme.of(ctx).primaryIconTheme.color),
                                IconButton(
                                    onPressed: () {
                                      APIManager.setFavourite(anime.id, !_isFavorite);
                                      addAsFavorite();
                                    },
                                    icon: _isFavorite
                                        ? Icon(
                                            Icons.star,
                                            color: Theme.of(ctx)
                                                .accentIconTheme
                                                .color,
                                          )
                                        : Icon(Icons.star_border,
                                            color: Theme.of(ctx)
                                                .primaryIconTheme
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
                                        changeSeason(newValue);
                                      },
                                      value: (_actualSeason == null)
                                          ? null
                                          : _actualSeason,
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
                            children: EpisodeList().getEpisodesAsList(
                                ctx,
                                state,
                                (_actualSeason == null || anime.seasons == null)
                                    ? null
                                    : anime.seasons.elementAt(_actualSeason),
                                anime))
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
          child: Text("Season " + (seasons.elementAt(l).number).toString())));
    }
    return namelist;
  }
}

class EpisodeList extends Container {
  EpisodeList() : super();

  List<Widget> getEpisodesAsList(BuildContext ctx, MainWidgetState state,
      AnimeSeason season, Anime anime) {
    var episodes = season == null ? null : season.episodes;
    if (episodes == null) {
      return [];
    } else {
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
        var image;
        if (ger && jap) {
          image = Image.asset('assets/images/gerjap.png', scale: 10);
        } else if (ger) {
          image = Image.asset('assets/images/ger.png', scale: 50);
        } else if (jap) {
          image = Image.asset('assets/images/jap.png', scale: 50);
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
                    Text(
                      actualEpisode == null
                          ? "---"
                          : actualEpisode.number.toString() + ". ",
                      style: TextStyle(
                          color: Theme.of(ctx).textTheme.title.color,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    Expanded(
                        child: Text(
                      actualEpisode == null ? "---" : actualEpisode.name,
                      style: TextStyle(
                          color: Theme.of(ctx).textTheme.title.color,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                      softWrap: true,
                    ))
                  ],
                )),
                Text(
                    actualEpisode.avgVotes == null
                        ? ""
                        : (double.parse(actualEpisode.avgVotes) * 100)
                                .round()
                                .toString() +
                            "%",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 20,
                        fontWeight: FontWeight.normal))
              ],
            ),
            onPressed: () {
              state.changePage(
                  EpisodeScreen(
                      state, anime.url, season.number, actualEpisode.number),
                  6);
            },
          ),
        ));
      }
      return episodeList;
    }
  }
}
