import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/components/custom/slider/slider_with_headline.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/allanime/genrewithshow.dart';
import 'package:aniflix_app/api/objects/Show.dart';

class AnimeListData {
  List<Show> allShows;
  List<GenreWithShows> allShowsWithGenres;

  AnimeListData(this.allShows, this.allShowsWithGenres);
}

class AnimeList extends StatefulWidget {
  MainWidgetState state;

  AnimeList(this.state);

  @override
  AnimeListState createState() => AnimeListState(state);
}

class AnimeListState extends State<AnimeList> {
  MainWidgetState state;
  Future<AnimeListData> animeListData;
  List<String> filterCriteria = ["Genre", "A - Z", "Bewertung", "Abos"];
  bool _onlyAiring = false;
  int _actualFilterCriteria;
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
    setState(() {
      switch(filterCriteria){
        case 0: {
          _actualSortedAnimeList = _onlyAiring ? sortedGenreAiring : sortedGenre;
        }break;
        case 1:{
          _actualSortedAnimeList = _onlyAiring ? sortedAZAiring : sortedAZ;
        }break;
        case 2:{
          _actualSortedAnimeList = _onlyAiring ? sortedBewertungAiring : sortedBewertung;
        }break;
        case 3:{
          _actualSortedAnimeList = _onlyAiring ? sortedAbosAiring : sortedAbos;
        }
      }
    });
  }

  AnimeListState(this.state) {
    this.animeListData = APIManager.getAnimeListData();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("allAnime_screen"),
      child: FutureBuilder<AnimeListData>(
        future: animeListData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(sortedGenre.length < 1 && sortedAZ.length < 1 && sortedBewertung.length < 1 && sortedAbos.length < 1 && sortedGenreAiring.length < 1 && sortedAZAiring.length < 1 && sortedBewertungAiring.length < 1 && sortedAbosAiring.length < 1){
              sortedGenre = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 0, false);
              sortedAZ = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 1, false);
              sortedBewertung = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 2, false);
              sortedAbos = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 3, false);
              sortedGenreAiring = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 0, true);
              sortedAZAiring = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 1, true);
              sortedBewertungAiring = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 2, true);
              sortedAbosAiring = getAllAnimeAsSortedList(ctx, state, snapshot.data.allShows, snapshot.data.allShowsWithGenres, 3, true);
            }
            return Container(
                color: Theme.of(ctx).backgroundColor,
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
                            hint: Text("Filter"),
                            items: getFilterCriteriaAsDropdownList(),
                            value: _actualFilterCriteria,
                            style: TextStyle(
                                color: Theme.of(ctx).textTheme.title.color,
                                fontSize: 15),
                            onChanged: (newValue) {
                              /*showDialog(
                                  context: ctx,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                        backgroundColor:
                                            Theme.of(ctx).backgroundColor,
                                        contentTextStyle: TextStyle(
                                            color: Theme.of(ctx)
                                                .textTheme
                                                .title
                                                .color),
                                        content: Text(newValue.toString()));
                                  });*/
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
                                      Theme.of(ctx).textTheme.title.color),
                              child: Checkbox(
                                onChanged: (newValue) {
                                  changeCheckbox();
                                },
                                value: _onlyAiring,
                              ),
                            ),
                            Text(
                              "Nur Airing",
                              style: TextStyle(
                                  color: Theme.of(ctx).textTheme.title.color,
                                  fontWeight: FontWeight.normal),
                            )
                          ]),
                          onPressed: () {
                            changeCheckbox();
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: _actualSortedAnimeList == null ? []: _actualSortedAnimeList
                    )
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  List<DropdownMenuItem<int>> getFilterCriteriaAsDropdownList() {
    List<DropdownMenuItem<int>> filterCriteriaAsDropdown = [];
    for (int l = 0; l < filterCriteria.length; l++) {
      filterCriteriaAsDropdown.add(
          DropdownMenuItem(value: l, child: Text(filterCriteria.elementAt(l))));
    }
    return filterCriteriaAsDropdown;
  }

  List<Widget> getAllAnimeAsSortedList(BuildContext ctx, MainWidgetState state,
      List<Show> allShows, List<GenreWithShows> allShowsWithGenres, int filterCriteria, bool airing) {
    List<Widget> sortedList = [SizedBox(height: 10)];
    switch (filterCriteria) {
      case 0:
        {
          for (var genre in allShowsWithGenres) {
            List<SliderElement> showsAsSlider = [];
            if (airing) {
              for (var show in genre.shows) {
                if (show.airing == 1) {
                  showsAsSlider.add(SliderElement(
                      image: "https://www2.aniflix.tv/storage/" +
                          show.cover_portrait,
                      name: show.name,
                      onTap: () {
                        state.changePage(AnimeScreen(show.url, state), 7);
                      }));
                }
              }
            } else {
              for (var show in genre.shows) {
                showsAsSlider.add(SliderElement(
                    image: "https://www2.aniflix.tv/storage/" +
                        show.cover_portrait,
                    name: show.name,
                    onTap: () {
                      state.changePage(AnimeScreen(show.url, state), 7);
                    }));
              }
            }
            if (showsAsSlider.length >= 1) {
              sortedList.add(HeadlineSlider(genre.name, ctx, showsAsSlider,
                  aspectRatio: 200 / 300, size: 0.4));
            }
          }
        }
        break;
      case 1:
        {
          List<String> nameList = [];
          for (var show in allShows) {
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
            for (var show in allShows) {
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
                      state.changePage(AnimeScreen(show.url, state), 6);
                    },
                    child: Row(
                      children: <Widget>[
                        Image.network(
                          "https://www2.aniflix.tv/storage/" + show.cover_portrait,
                          width: 50,
                          height: 75,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text(
                          show.name,
                          style: TextStyle(
                              color: Theme.of(ctx).textTheme.title.color,
                              fontSize: 20),
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
            for (var show in allShows) {
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
            for (var show in allShows) {
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
                  state.changePage(AnimeScreen(shows.url, state), 6);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.blue,
                      child: Text(
                        ((double.parse(shows.rating) * 10).round() / 10)
                            .toString(),
                        style: TextStyle(
                            color: Theme.of(context).textTheme.title.color),
                      ),
                    ),
                    /*Image.network(
                          "https://www2.aniflix.tv/storage/" + shows.cover_portrait,
                          width: 50,
                          height: 75,
                        ),*/
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      shows.name,
                      style: TextStyle(
                          color: Theme.of(ctx).textTheme.title.color,
                          fontSize: 20),
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
            for (var show in allShows) {
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
            for (var show in allShows) {
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
                  state.changePage(AnimeScreen(show.url, state), 6);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.blue,
                      child: Text(
                        show.howManyAbos.toString(),
                        style: TextStyle(
                            color: Theme.of(context).textTheme.title.color),
                      ),
                    ),
                    /*Image.network(
                          "https://www2.aniflix.tv/storage/" + show.cover_portrait,
                          width: 50,
                          height: 75,
                        ),*/
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      show.name,
                      style: TextStyle(
                          color: Theme.of(ctx).textTheme.title.color,
                          fontSize: 20),
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
