import 'package:aniflix_app/api/objects/anime/AnimeSeason.dart';
import 'package:aniflix_app/components/custom/dialogs/ratingDialog.dart';
import 'package:aniflix_app/components/custom/anime/animeHeader.dart';
import 'package:aniflix_app/components/slider/TextboxSliderElement.dart';
import 'package:aniflix_app/components/slider/carousel/TextBoxCarousel.dart';
import 'package:aniflix_app/components/custom/anime/animeDescription.dart';
import 'package:aniflix_app/components/custom/anime/episodeList.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/objects/anime/Anime.dart';
import '../../api/APIManager.dart';

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
  List<TextboxSliderElement> genres = [];
  List<String> genreNames = [];
  bool _isSubscribed;
  int _actualSeason;
  bool _isInWatchlist;
  bool _isFavorite;
  bool _useData;
  double _rating;

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
                  if (!genreNames.contains(genre.name)) {
                    genreNames.add(genre.name);
                    genres.add(TextboxSliderElement(genre.name));
                  }
                }
              }
              return Container(
                  color: Theme.of(ctx).backgroundColor,
                  child: ListView(
                      padding: EdgeInsets.only(top: 10, left: 5),
                      children: [
                        AnimeHeader(anime, episodeCount, ctx, state),
                        SizedBox(
                          height: 10,
                        ),
                        genres.length < 1
                            ? SizedBox(
                                height: 0,
                              )
                            : TextboxCarousel(genres),
                        AnimeDescription(anime.description, ctx),
                        Container(
                            padding: EdgeInsets.only(top: 10, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                OutlineButton(
                                  onPressed: () {
                                    APIManager.setSubscription(
                                        anime.id, !_isSubscribed);
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
                                      APIManager.setWatchlist(
                                          anime.id, !_isInWatchlist);
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
                                      APIManager.setFavourite(
                                          anime.id, !_isFavorite);
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
                                    onPressed: () {
                                      showDialog(
                                          context: ctx,
                                          builder: (BuildContext ctx) {
                                            return RatingDialog(anime, (x) {
                                              this._rating = x;
                                            }, _rating);
                                          });
                                    },
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
                                      items: getSeasonsAsDropdownList(
                                          anime.seasonCount, anime.seasons),
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
                        EpisodeList(
                            (_actualSeason == null || anime.seasons == null)
                                ? null
                                : anime.seasons.elementAt(_actualSeason),
                            anime,
                            state)
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

List<DropdownMenuItem<int>> getSeasonsAsDropdownList(
    int seasonCount, List<AnimeSeason> seasons) {
  List<DropdownMenuItem<int>> namelist = [];
  for (int l = 0; l < seasonCount; l++) {
    namelist.add(DropdownMenuItem(
        value: l,
        child: Text("Season " + (seasons.elementAt(l).number).toString())));
  }
  return namelist;
}
