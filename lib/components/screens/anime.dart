import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/AnimeSeason.dart';
import 'package:aniflix_app/api/objects/profile/Friend.dart';
import 'package:aniflix_app/api/requests/anime/AnimeRequests.dart';
import 'package:aniflix_app/api/requests/notifications/NotificationRequests.dart';
import 'package:aniflix_app/api/requests/user/ProfileRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/dialogs/ratingDialog.dart';
import 'package:aniflix_app/components/custom/anime/animeHeader.dart';
import 'package:aniflix_app/components/custom/listelements/iconListElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/components/slider/TextboxSliderElement.dart';
import 'package:aniflix_app/components/slider/carousel/TextBoxCarousel.dart';
import 'package:aniflix_app/components/custom/anime/animeDescription.dart';
import 'package:aniflix_app/components/custom/anime/episodeList.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/objects/anime/Anime.dart';

class AnimeScreen extends StatefulWidget implements Screen {
  String name;

  AnimeScreen(this.name);

  @override
  AnimeScreenState createState() => AnimeScreenState(name);

  @override
  getScreenName() {
    return "anime_screen";
  }
}

class AnimeScreenState extends State<AnimeScreen> {
  Future<Anime> anime;
  List<TextboxSliderElement> genres = [];
  List<String> genreNames = [];
  List<Friend> friendlist = [];
  bool _isSubscribed;
  int _actualSeason;
  bool _isInWatchlist;
  bool _isFavorite;
  bool _useData;
  bool _sendAnalytics = false;
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

  AnimeScreenState(String name) {
    this.anime = AnimeRequests.getAnime(name);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
        key: Key("anime_screen"),
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
                child: FutureBuilder<Anime>(
              future: anime,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var anime = snapshot.data;
                  if (!_sendAnalytics) {
                    _sendAnalytics = true;
                    var itemName = "Show_" + anime.name;
                    AppState.analytics.logViewItem(
                        itemId: anime.id.toString(),
                        itemName: itemName,
                        itemCategory: "Show");
                  }
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
                  if (_actualSeason == null) {
                    if (anime.seasons.length > 0) _actualSeason = 0;
                  }
                  return Container(
                      color: Colors.transparent,
                      child: ListView(
                          padding: EdgeInsets.only(top: 10, left: 5),
                          children: [
                            AnimeHeader(anime, episodeCount, ctx),
                            SizedBox(
                              height: 10,
                            ),
                            genres.length < 1
                                ? SizedBox(
                                    height: 0,
                                  )
                                : TextboxCarousel(genres),
                            AnimeDescription(anime.description, ctx),
                            (CacheManager.session != null)
                                ? Container(
                                    padding: EdgeInsets.only(top: 10, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        OutlineButton(
                                          onPressed: () {
                                            var analytics = AppState.analytics;
                                            analytics.logEvent(
                                                name: "change_subscription",
                                                parameters: {
                                                  "show_id": anime.id,
                                                  "sub_value": !_isSubscribed
                                                });
                                            AnimeRequests.setSubscription(
                                                anime.id, !_isSubscribed);
                                            toggleSubButton(!_isSubscribed);
                                          },
                                          child: Text(_isSubscribed
                                              ? "Deabonnieren " +
                                                  anime.howManyAbos.toString()
                                              : "Abonnieren " +
                                                  anime.howManyAbos.toString()),
                                          textColor: _isSubscribed
                                              ? Theme.of(ctx)
                                                  .primaryIconTheme
                                                  .color
                                              : Theme.of(ctx)
                                                  .accentIconTheme
                                                  .color,
                                          borderSide: BorderSide(
                                              color: _isSubscribed
                                                  ? Theme.of(ctx)
                                                      .primaryIconTheme
                                                      .color
                                                  : Theme.of(ctx)
                                                      .accentIconTheme
                                                      .color),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              var analytics =
                                                  AppState.analytics;
                                              analytics.logEvent(
                                                  name: "change_watchlist",
                                                  parameters: {
                                                    "show_id": anime.id,
                                                    "watchlist_value":
                                                        !_isInWatchlist
                                                  });
                                              AnimeRequests.setWatchlist(
                                                  anime.id, !_isInWatchlist);
                                              addToWatchlist(!_isInWatchlist);
                                            },
                                            icon: Icon(_isInWatchlist
                                                ? Icons.playlist_add_check
                                                : Icons.playlist_add),
                                            color: _isInWatchlist
                                                ? Theme.of(ctx)
                                                    .accentIconTheme
                                                    .color
                                                : Theme.of(ctx)
                                                    .primaryIconTheme
                                                    .color),
                                        IconButton(
                                            onPressed: () {
                                              var analytics =
                                                  AppState.analytics;
                                              analytics.logEvent(
                                                  name: "change_favorite",
                                                  parameters: {
                                                    "show_id": anime.id,
                                                    "favorite_value":
                                                        !_isFavorite
                                                  });
                                              AnimeRequests.setFavourite(
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
                                                    return RatingDialog(anime,
                                                        (x) {
                                                      var analytics =
                                                          AppState.analytics;
                                                      analytics.logEvent(
                                                          name: "change_rating",
                                                          parameters: {
                                                            "show_id": anime.id,
                                                            "rating_value": x
                                                          });
                                                      this._rating = x;
                                                    }, _rating);
                                                  });
                                            },
                                            icon: Icon(
                                              Icons.assessment,
                                              color: Theme.of(ctx)
                                                  .primaryIconTheme
                                                  .color,
                                            )),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: ctx,
                                                builder: (BuildContext ctx) {
                                                  return FutureBuilder(
                                                      future: ProfileRequests
                                                          .getUserFriends(
                                                              CacheManager
                                                                  .userData.id),
                                                      builder:
                                                          (context, snapshot) {
                                                        return AlertDialog(
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .backgroundColor,
                                                            contentTextStyle: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .color),
                                                            content: Container(
                                                              width: double
                                                                  .maxFinite,
                                                              child: ListView(
                                                                children:
                                                                    getFriendsAsList(
                                                                        context,
                                                                        snapshot
                                                                            .data,
                                                                        anime),
                                                              ),
                                                            ));
                                                      });
                                                });
                                          },
                                          icon: Icon(
                                            Icons.share,
                                            color: Theme.of(ctx)
                                                .primaryIconTheme
                                                .color,
                                          ),
                                        ),
                                      ],
                                    ))
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Theme(
                                    data: Theme.of(ctx).copyWith(
                                        canvasColor:
                                            Theme.of(ctx).backgroundColor),
                                    child: DropdownButton<int>(
                                      style: TextStyle(
                                          color: Theme.of(ctx)
                                              .textTheme
                                              .caption
                                              .color,
                                          fontSize: 15),
                                      items: getSeasonsAsDropdownList(
                                          anime.seasons),
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
                                                .caption
                                                .color),
                                      ),
                                    )),
                                CacheManager.session != null
                                    ? OutlineButton(
                                        onPressed: () {
                                          setSeen(anime);
                                        },
                                        child: ThemeText("Staffel Gesehen",
                                            fontSize: 15),
                                        borderSide: BorderSide(
                                            color: Theme.of(ctx)
                                                .primaryIconTheme
                                                .color),
                                      )
                                    : Container(),
                                CacheManager.session != null
                                    ? OutlineButton(
                                        onPressed: () {
                                          setUnseen(anime);
                                        },
                                        child: Text(
                                          "Staffel nicht Gesehen",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Theme.of(ctx)
                                                  .accentIconTheme
                                                  .color),
                                        ),
                                        borderSide: BorderSide(
                                            color: Theme.of(ctx)
                                                .accentIconTheme
                                                .color),
                                      )
                                    : Container()
                              ],
                            ),
                            EpisodeList(
                                (_actualSeason == null || anime.seasons == null)
                                    ? null
                                    : anime.seasons.elementAt(_actualSeason),
                                anime)
                          ]));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            ))
          ],
        ));
  }

  setSeen(Anime anime) {
    if (_actualSeason != null && anime.seasons != null) {
      int seasonNumber = _actualSeason;
      AnimeRequests.setSeasonSeen(anime.seasons.elementAt(seasonNumber).id)
          .then((value) {
        setState(() {
          anime.seasons[seasonNumber] = value;
          for (var episode in anime.seasons[seasonNumber].episodes) {
            episode.seen = 1;
          }
        });
      });
    }
  }

  setUnseen(Anime anime) {
    if (_actualSeason != null && anime.seasons != null) {
      int seasonNumber = _actualSeason;
      AnimeRequests.setSeasonUnSeen(anime.seasons.elementAt(seasonNumber).id)
          .then((value) {
        setState(() {
          anime.seasons[seasonNumber] = value;
        });
      });
    }
  }
}

List<DropdownMenuItem<int>> getSeasonsAsDropdownList(
    List<AnimeSeason> seasons) {
  List<DropdownMenuItem<int>> namelist = [];
  for (int l = 0; l < seasons.length; l++) {
    if (seasons[l].number == 0) {
      namelist.add(DropdownMenuItem(value: l, child: Text("Specials")));
    } else {
      namelist.add(DropdownMenuItem(
          value: l,
          child: Text("Season " + (seasons.elementAt(l).number).toString())));
    }
  }
  return namelist;
}

List<Widget> getFriendsAsList(
    BuildContext ctx, FriendListData friendlistdata, Anime anime) {
  List<Friend> friendlist = friendlistdata.friendlist;
  List<Widget> friendlistwidget = [];

  for (var friend in friendlist) {
    if (friend.status == 0) {
      if (friend.friend.id == CacheManager.userData.id) {
        friendlistwidget.add(IconListElement(
          friend.user.name,
          friend.user.avatar,
          ctx,
          onTap: () {
            NotificationRequests.addRecommendNotification(
                CacheManager.userData, friend.user, anime);
            Navigator.of(ctx).pop();
          },
        ));
      } else {
        friendlistwidget.add(IconListElement(
          friend.friend.name,
          friend.friend.avatar,
          ctx,
          onTap: () {
            NotificationRequests.addRecommendNotification(
                CacheManager.userData, friend.friend, anime);
            Navigator.of(ctx).pop();
          },
        ));
      }
    }
  }

  return friendlistwidget;
}
