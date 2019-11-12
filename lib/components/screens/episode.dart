import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Episode.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/components/screens/subbox.dart';
import 'package:aniflix_app/main.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EpisodeScreen extends StatefulWidget {
  MainWidgetState state;

  String name;
  int season;
  int number;

  EpisodeScreen(this.state, this.name, this.season, this.number);

  @override
  EpisodeScreenState createState() =>
      EpisodeScreenState(state, name, season, number);
}

class EpisodeScreenState extends State<EpisodeScreen> {
  MainWidgetState mainState;
  Future<EpisodeInfo> episodedata;
  List<String> languages = [];
  int _language;
  int _hoster;
  List<DropdownMenuItem<int>> _streams;
  bool _isReported;
  List<String> possibleVotes = [null, "+", "-"];
  String _actualVote;
  int _numberOfUpVotes;
  int _numberOfDownVotes;

  setLanguage(int language, List<AnimeStream> streams) {
    setState(() {
      this._language = language;
      this._streams =
          GetStreamsAsDropdownList(streams, language, languages).getItems();
      changeHoster(0);
    });
  }

  changeHoster(int hoster) {
    setState(() {
      this._hoster = hoster;
    });
  }

  report() {
    setState(() {
      this._isReported = !_isReported;
    });
  }

  makeUpVote() {
    setState(() {
      if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
        _actualVote = possibleVotes.elementAt(1);
        _numberOfUpVotes = _numberOfUpVotes + 1;
      } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
        _actualVote = possibleVotes.elementAt(0);
        _numberOfUpVotes = _numberOfUpVotes - 1;
      } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
        _actualVote = possibleVotes.elementAt(1);
        _numberOfDownVotes = _numberOfDownVotes - 1;
        _numberOfUpVotes = _numberOfUpVotes + 1;
      }
    });
  }

  makeDownVote() {
    setState(() {
      if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
        _actualVote = possibleVotes.elementAt(2);
        _numberOfDownVotes = _numberOfDownVotes + 1;
      } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
        _actualVote = possibleVotes.elementAt(2);
        _numberOfUpVotes = _numberOfUpVotes - 1;
        _numberOfDownVotes = _numberOfDownVotes + 1;
      } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
        _actualVote = possibleVotes.elementAt(0);
        _numberOfDownVotes = _numberOfDownVotes - 1;
      }
    });
  }

  int startState(List<AnimeStream> streams, EpisodeInfo episode) {
    _language = 0;
    _streams =
        GetStreamsAsDropdownList(streams, _language, languages).getItems();
    _hoster = 0;
    return _language;
  }

  EpisodeScreenState(this.mainState, String name, int season, int number) {
    this.episodedata = APIManager.getEpisode(name, season, number);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("episode_screen"),
      child: FutureBuilder<EpisodeInfo>(
        future: episodedata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var episode = snapshot.data;
            for (var stream in episode.streams) {
              if (!languages.contains(stream.lang)) {
                languages.add(stream.lang);
              }
            }
            var formated_date = DateTime.parse(episode.created_at);
            _isReported =
                _isReported == null ? episode.hasReports == 1 : _isReported;

            if (_numberOfDownVotes == null || _numberOfUpVotes == null) {
              _numberOfDownVotes = 0;
              _numberOfUpVotes = 0;
              for (var votes in episode.votes) {
                if (votes.value == 0) {
                  _numberOfDownVotes = _numberOfDownVotes + 1;
                } else if (votes.value == 1) {
                  _numberOfUpVotes = _numberOfUpVotes + 1;
                }
              }
              if (episode.voted == 0) {
                _actualVote = possibleVotes.elementAt(2);
              } else if (episode.voted == 1) {
                _actualVote = possibleVotes.elementAt(1);
              }
            }
            return Container(
                color: Theme.of(ctx).backgroundColor,
                child: ListView(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        (episode.number > 1)
                            ? IconButton(
                                icon: Icon(
                                  Icons.navigate_before,
                                  color: Theme.of(ctx).textTheme.title.color,
                                ),
                                color: Theme.of(ctx).textTheme.title.color,
                                onPressed: () {
                                  mainState.changePage(
                                      EpisodeScreen(
                                          mainState,
                                          episode.season.show.url,
                                          episode.season.number,
                                          episode.number - 1),
                                      6);
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.navigate_before,
                                  color: Theme.of(ctx).backgroundColor,
                                ),
                                color: Theme.of(ctx).backgroundColor,
                                onPressed: () {},
                              ),
                        Row(
                          children: <Widget>[
                            Theme(
                              data: Theme.of(ctx).copyWith(
                                  canvasColor: Theme.of(ctx).backgroundColor),
                              child: DropdownButton(
                                style: TextStyle(
                                    color: Theme.of(ctx).textTheme.title.color,
                                    fontSize: 15),
                                onChanged: (newValue) {
                                  setLanguage(newValue, episode.streams);
                                },
                                items:
                                    GetLanguagesAsDropdownList(episode.streams)
                                        .getItems(),
                                value: _language == null
                                    ? startState(episode.streams, episode)
                                    : _language,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Theme(
                              data: Theme.of(ctx).copyWith(
                                  canvasColor: Theme.of(ctx).backgroundColor),
                              child: DropdownButton(
                                style: TextStyle(
                                    color: Theme.of(ctx).textTheme.title.color,
                                    fontSize: 15),
                                onChanged: (newValue) {
                                  changeHoster(newValue);
                                },
                                items: _streams,
                                value: _hoster,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: (episode.next != "")
                              ? Icon(
                                  Icons.navigate_next,
                                  color: Theme.of(ctx).textTheme.title.color,
                                )
                              : Icon(
                                  Icons.navigate_before,
                                  color: Theme.of(ctx).backgroundColor,
                                ),
                          color: (episode.next != "")
                              ? Theme.of(ctx).textTheme.title.color
                              : Theme.of(ctx).backgroundColor,
                          onPressed: (episode.next != "")
                              ? () {
                                  mainState.changePage(
                                      EpisodeScreen(
                                          mainState,
                                          episode.season.show.url,
                                          episode.season.number,
                                          (episode.number + 1)),
                                      1);
                                }
                              : () {},
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text("Player",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(ctx).textTheme.title.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Theme.of(ctx).textTheme.title.color)),
                      height: 200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      (episode != null) ? episode.name : "",
                      style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      softWrap: true,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "S " +
                              episode.season.number.toString() +
                              " E " +
                              episode.number.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(ctx).textTheme.title.color),
                        ),
                        Expanded(
                            child: FlatButton(
                          padding: EdgeInsets.only(
                              left: 10, right: 0, top: 0, bottom: 0),
                          child: Text(
                            episode.season.show.name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(ctx).textTheme.title.color),
                            softWrap: true,
                          ),
                          onPressed: () {
                            mainState.changePage(
                                AnimeScreen(episode.season.show.url, mainState),
                                7);
                          },
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              (formated_date.day.toString() +
                                  "." +
                                  formated_date.month.toString() +
                                  "." +
                                  formated_date.year.toString()),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(ctx).textTheme.title.color),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.report,
                                color: _isReported
                                    ? Theme.of(ctx).accentIconTheme.color
                                    : Theme.of(ctx).primaryIconTheme.color,
                              ),
                              onPressed: () {
                                if (!_isReported) {
                                  report();
                                }
                              },
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: _actualVote == null ||
                                            _actualVote ==
                                                possibleVotes.elementAt(2)
                                        ? Theme.of(ctx).primaryIconTheme.color
                                        : Theme.of(ctx).accentIconTheme.color,
                                  ),
                                  onPressed: () {
                                    makeUpVote();
                                  },
                                ),
                                Text(
                                  _numberOfUpVotes.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color:
                                          Theme.of(ctx).textTheme.title.color),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: (_actualVote == null ||
                                            _actualVote ==
                                                possibleVotes.elementAt(1))
                                        ? Theme.of(ctx).primaryIconTheme.color
                                        : Theme.of(ctx).accentIconTheme.color,
                                  ),
                                  onPressed: () {
                                    makeDownVote();
                                  },
                                ),
                                Text(
                                  _numberOfDownVotes.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color:
                                          Theme.of(ctx).textTheme.title.color),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    ExpandablePanel(
                      header: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Kommentare",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(ctx).textTheme.title.color),
                        ),
                      ),
                      expanded: Text(""),
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapHeaderToExpand: true,
                      tapBodyToCollapse: true,
                      hasIcon: false,
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
}

class GetStreamsAsDropdownList {
  List<AnimeStream> hosters;
  List<String> languages;
  int language;

  GetStreamsAsDropdownList(this.hosters, this.language, this.languages);

  List<DropdownMenuItem<int>> getItems() {
    List<DropdownMenuItem<int>> namelist = [];
    List<AnimeStream> streams = [];
    int l = 0;
    for (var hoster in hosters) {
      if (hoster.lang == languages.elementAt(language) &&
          !(streams.contains(hoster))) {
        streams.add(hoster);
      }
    }
    for (var stream in streams) {
      namelist.add(DropdownMenuItem(value: l, child: Text(stream.hoster.name)));
      l++;
    }
    return namelist;
  }
}

class GetLanguagesAsDropdownList {
  List<AnimeStream> streams;

  GetLanguagesAsDropdownList(this.streams);

  List<DropdownMenuItem<int>> getItems() {
    List<DropdownMenuItem<int>> namelist = [];
    List<String> languages = [];
    for (var stream in streams) {
      if (!languages.contains(stream.lang)) {
        languages.add(stream.lang);
      }
    }
    for (int l = 0; l < languages.length; l++) {
      namelist
          .add(DropdownMenuItem(value: l, child: Text(languages.elementAt(l))));
    }
    return namelist;
  }
}
