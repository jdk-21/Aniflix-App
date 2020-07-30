import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/slider/slider_with_headline.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/allanime/genrewithshow.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/Show.dart';

class AnimeListData {
  List<Show> allShows;
  List<GenreWithShows> allShowsWithGenres;

  AnimeListData(this.allShows, this.allShowsWithGenres);
}

class AnimeList extends StatefulWidget implements Screen {
  AnimeList();

  @override
  getScreenName() {
    return "allAnime_screen";
  }

  @override
  AnimeListState createState() => AnimeListState();
}

class AnimeListState extends State<AnimeList> {
  Future<AnimeListData> animeListData;
  AnimeListData cache;
  List<String> filterCriteria = ["Genre", "A - Z", "Bewertung", "Abos"];
  bool _onlyAiring = false;
  int _actualFilterCriteria;
  int _maxShows = 25;
  List<Widget> sortedGenre = [];
  List<Widget> sortedAZ = [];
  List<Widget> sortedBewertung = [];
  List<Widget> sortedAbos = [];
  List<Widget> sortedGenreAiring = [];
  List<Widget> sortedAZAiring = [];
  List<Widget> sortedBewertungAiring = [];
  List<Widget> sortedAbosAiring = [];
  List<Widget> _actualSortedAnimeList = [];

  changeCheckbox() {
    setState(() {
      _onlyAiring = !_onlyAiring;
      updateAnimeList(_actualFilterCriteria);
    });
  }

  changeActualFilterCriteria(int newValue) {
    setState(() {
      _actualFilterCriteria = newValue;
    });
  }

  updateAnimeList(filterCriteria) {
    var analytics = AppState.analytics;
    setState(() {
      switch (filterCriteria) {
        case 0:
          {
            analytics.logEvent(name: "change_allanime_filter", parameters: {
              "filter_name": "Genre",
              "filter_airing": _onlyAiring
            });
            if (_onlyAiring) {
              _actualSortedAnimeList = sortedGenreAiring;
            } else {
              _actualSortedAnimeList = sortedGenre;
            }
          }
          break;
        case 1:
          {
            analytics.logEvent(name: "change_allanime_filter", parameters: {
              "filter_name": "SortedAZ",
              "filter_airing": _onlyAiring
            });
            if (_onlyAiring) {
              _actualSortedAnimeList = [];
              for (var i = 0; i < sortedAZAiring.length; i++) {
                if (i < _maxShows) {
                  _actualSortedAnimeList.add(sortedAZAiring[i]);
                }
              }
            } else {
              _actualSortedAnimeList = [];
              for (var i = 0; i < sortedAZ.length; i++) {
                if (i < _maxShows) {
                  _actualSortedAnimeList.add(sortedAZ[i]);
                }
              }
            }
          }
          break;
        case 2:
          {
            analytics.logEvent(name: "change_allanime_filter", parameters: {
              "filter_name": "SortedBewertung",
              "filter_airing": _onlyAiring
            });
            if (_onlyAiring) {
              _actualSortedAnimeList = [];
              for (var i = 0; i < sortedBewertungAiring.length; i++) {
                if (i < _maxShows) {
                  _actualSortedAnimeList.add(sortedBewertungAiring[i]);
                }
              }
            } else {
              _actualSortedAnimeList = [];
              for (var i = 0; i < sortedBewertung.length; i++) {
                if (i < _maxShows) {
                  _actualSortedAnimeList.add(sortedBewertung[i]);
                }
              }
            }
          }
          break;
        case 3:
          {
            analytics.logEvent(name: "change_allanime_filter", parameters: {
              "filter_name": "SortedAbos",
              "filter_airing": _onlyAiring
            });

            if (_onlyAiring) {
              _actualSortedAnimeList = [];
              for (var i = 0; i < sortedAbosAiring.length; i++) {
                if (i < _maxShows) {
                  _actualSortedAnimeList.add(sortedAbosAiring[i]);
                }
              }
            } else {
              _actualSortedAnimeList = [];
              for (var i = 0; i < sortedAbos.length; i++) {
                if (i < _maxShows) {
                  _actualSortedAnimeList.add(sortedAbos[i]);
                }
              }
            }
          }
      }
    });
  }

  AnimeListState() {
    if (CacheManager.animeListData == null) {
      this.animeListData = APIManager.getAnimeListData();
    } else {
      cache = CacheManager.animeListData;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null) {
      return Container(
        key: Key("allAnime_screen"),
        color: Colors.transparent,
        child: FutureBuilder<AnimeListData>(
          future: animeListData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CacheManager.animeListData = snapshot.data;
              return getLayout(snapshot.data, ctx);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Container(
          key: Key("allAnime_screen"),
          color: Colors.transparent,
          child: getLayout(cache, ctx));
    }
  }

  getLayout(AnimeListData data, BuildContext ctx) {
    if (sortedGenre.length < 1 &&
        sortedAZ.length < 1 &&
        sortedBewertung.length < 1 &&
        sortedAbos.length < 1 &&
        sortedGenreAiring.length < 1 &&
        sortedAZAiring.length < 1 &&
        sortedBewertungAiring.length < 1 &&
        sortedAbosAiring.length < 1) {
      sortedGenre = getAllAnimeAsSortedList(ctx, data, 0, false);
      sortedAZ = getAllAnimeAsSortedList(ctx, data, 1, false);
      sortedBewertung = getAllAnimeAsSortedList(ctx, data, 2, false);
      sortedAbos = getAllAnimeAsSortedList(ctx, data, 3, false);
      sortedGenreAiring = getAllAnimeAsSortedList(ctx, data, 0, true);
      sortedAZAiring = getAllAnimeAsSortedList(ctx, data, 1, true);
      sortedBewertungAiring = getAllAnimeAsSortedList(ctx, data, 2, true);
      sortedAbosAiring = getAllAnimeAsSortedList(ctx, data, 3, true);
    }
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                color: Colors.transparent,
                child: ListView(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Theme(
                          data: Theme.of(ctx).copyWith(
                              canvasColor: Theme.of(ctx).backgroundColor),
                          child: DropdownButton(
                            hint: ThemeText("Filter"),
                            items: getFilterCriteriaAsDropdownList(ctx),
                            value: _actualFilterCriteria,
                            style: TextStyle(
                                color: Theme.of(ctx).textTheme.caption.color,
                                fontSize: 15),
                            onChanged: (newValue) {
                              changeActualFilterCriteria(newValue);
                              updateAnimeList(_actualFilterCriteria);
                            },
                          ),
                        ),
                        FlatButton(
                          child: Row(children: <Widget>[
                            Theme(
                              data: Theme.of(ctx).copyWith(
                                  unselectedWidgetColor:
                                      Theme.of(ctx).textTheme.caption.color),
                              child: Checkbox(
                                onChanged: (newValue) {
                                  changeCheckbox();
                                },
                                value: _onlyAiring,
                              ),
                            ),
                            ThemeText("Nur Airing")
                          ]),
                          onPressed: () {
                            changeCheckbox();
                          },
                        ),
                      ],
                    ),
                    Column(
                        children: _actualSortedAnimeList == null
                            ? []
                            : _actualSortedAnimeList),
                    (_actualSortedAnimeList == null ||
                            (_actualFilterCriteria == null ||
                                _actualFilterCriteria == 0))
                        ? Container()
                        : FlatButton(
                            child: ThemeText("Mehr anzeigen"),
                            onPressed: () {
                              setState(() {
                                this._maxShows += 25;
                                updateAnimeList(_actualFilterCriteria);
                              });
                            },
                          )
                  ],
                )))
      ],
    );
  }

  List<DropdownMenuItem<int>> getFilterCriteriaAsDropdownList(
      BuildContext ctx) {
    List<DropdownMenuItem<int>> filterCriteriaAsDropdown = [];
    for (int l = 0; l < filterCriteria.length; l++) {
      filterCriteriaAsDropdown.add(DropdownMenuItem(
          value: l, child: ThemeText(filterCriteria.elementAt(l))));
    }
    return filterCriteriaAsDropdown;
  }

  List<Widget> getAllAnimeAsSortedList(
      BuildContext ctx, AnimeListData data, int filterCriteria, bool airing) {
    List<Widget> sortedList = [SizedBox(height: 10)];
    switch (filterCriteria) {
      case 0:
        {
          for (var genre in data.allShowsWithGenres) {
            List<SliderElement> showsAsSlider = [];
            if (airing) {
              for (var show in genre.shows) {
                if (show.airing == 1) {
                  showsAsSlider.add(SliderElement(
                      image: "https://www2.aniflix.tv/storage/" +
                          show.cover_portrait,
                      name: show.name,
                      onTap: (ctx) {
                        Navigator.pushNamed(ctx, "anime", arguments: show.url);
                      }));
                }
              }
            } else {
              for (var show in genre.shows) {
                showsAsSlider.add(SliderElement(
                    image: "https://www2.aniflix.tv/storage/" +
                        show.cover_portrait,
                    name: show.name,
                    onTap: (ctx) {
                      Navigator.pushNamed(ctx, "anime", arguments: show.url);
                    }));
              }
            }
            if (showsAsSlider.length >= 1) {
              sortedList.add(
                  HeadlineSlider(genre.name, showsAsSlider, 200, size: 0.4));
            }
          }
        }
        break;
      case 1:
        {
          List<String> nameList = [];
          for (var show in data.allShows) {
            if (airing) {
              if (show.airing == 1) {
                nameList.add(show.name);
              }
            } else {
              nameList.add(show.name);
            }
          }
          nameList.sort();
          for (var name in nameList) {
            for (var show in data.allShows) {
              if (show.name == name) {
                sortedList.add(Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 1,
                              color: Theme.of(ctx).hintColor,
                              style: BorderStyle.solid))),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(ctx, "anime", arguments: show.url);
                    },
                    child: Row(
                      children: <Widget>[
                        /*Image.network(
                          "https://www2.aniflix.tv/storage/" + show.cover_portrait,
                          width: 50,
                          height: 75,
                        ),*/
                        SizedBox(width: 10),
                        Expanded(
                            child: ThemeText(
                          show.name,
                          softWrap: true,
                        ))
                      ],
                    ),
                  ),
                ));
              }
            }
          }
        }
        break;
      case 2:
        {
          List<Show> sortedShows = [];
          if (airing) {
            for (var show in data.allShows) {
              if (show.airing == 1) {
                if (sortedShows.length < 1) {
                  sortedShows.add(show);
                } else {
                  for (var l = 0; l < sortedShows.length; l++) {
                    if (double.parse(sortedShows.elementAt(l).rating) <
                        double.parse(show.rating)) {
                      sortedShows.insert(l, show);
                      break;
                    } else if (double.parse(sortedShows.elementAt(l).rating) >=
                            double.parse(show.rating) &&
                        l == (sortedShows.length - 1)) {
                      sortedShows.add(show);
                      break;
                    }
                  }
                }
              }
            }
          } else {
            for (var show in data.allShows) {
              if (sortedShows.length < 1) {
                sortedShows.add(show);
              } else {
                for (var l = 0; l < sortedShows.length; l++) {
                  if (double.parse(sortedShows.elementAt(l).rating) <
                      double.parse(show.rating)) {
                    sortedShows.insert(l, show);
                    break;
                  } else if (double.parse(sortedShows.elementAt(l).rating) >=
                          double.parse(show.rating) &&
                      l == (sortedShows.length - 1)) {
                    sortedShows.add(show);
                    break;
                  }
                }
              }
            }
          }
          for (var shows in sortedShows) {
            sortedList.add(Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 1,
                          color: Theme.of(ctx).hintColor,
                          style: BorderStyle.solid))),
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(ctx, "anime", arguments: shows.url);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.blue,
                      child: Text(
                        ((double.parse(shows.rating) * 10).round() / 10)
                            .toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    /*Image.network(
                          "https://www2.aniflix.tv/storage/" + shows.cover_portrait,
                          width: 50,
                          height: 75,
                        ),*/
                    SizedBox(width: 10),
                    Expanded(
                        child: ThemeText(
                      shows.name,
                      softWrap: true,
                    ))
                  ],
                ),
              ),
            ));
          }
        }
        break;
      case 3:
        {
          List<Show> sortedShows = [];
          if (airing) {
            for (var show in data.allShows) {
              if (show.airing == 1) {
                if (sortedShows.length < 1) {
                  sortedShows.add(show);
                } else {
                  for (var l = 0; l < sortedShows.length; l++) {
                    if (show.howManyAbos >
                        sortedShows.elementAt(l).howManyAbos) {
                      sortedShows.insert(l, show);
                      break;
                    } else if (show.howManyAbos <=
                            sortedShows.elementAt(l).howManyAbos &&
                        l == (sortedShows.length - 1)) {
                      sortedShows.add(show);
                      break;
                    }
                  }
                }
              }
            }
          } else {
            for (var show in data.allShows) {
              if (sortedShows.length < 1) {
                sortedShows.add(show);
              } else {
                for (var l = 0; l < sortedShows.length; l++) {
                  if (show.howManyAbos > sortedShows.elementAt(l).howManyAbos) {
                    sortedShows.insert(l, show);
                    break;
                  } else if (show.howManyAbos <=
                          sortedShows.elementAt(l).howManyAbos &&
                      l == (sortedShows.length - 1)) {
                    sortedShows.add(show);
                    break;
                  }
                }
              }
            }
          }
          for (var show in sortedShows) {
            sortedList.add(Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 1,
                          color: Theme.of(ctx).hintColor,
                          style: BorderStyle.solid))),
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(ctx, "anime", arguments: show.url);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.blue,
                      child: Text(
                        show.howManyAbos.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: ThemeText(
                      show.name,
                      softWrap: true,
                    ))
                  ],
                ),
              ),
            ));
          }
        }
        break;
    }
    return sortedList;
  }
}
