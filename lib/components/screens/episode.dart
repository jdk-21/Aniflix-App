import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/components/custom/comments/CommentComponent.dart';
import 'package:aniflix_app/components/custom/comments/commentContainer.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/main.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

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
  List<String> languages = [];
  List<AnimeStream> _links = [];
  int _language;
  int _hoster;
  String _stream = null;
  List<DropdownMenuItem<int>> _streams;
  List<String> _hosters = [];
  bool _isReported;
  List<String> possibleVotes = [null, "+", "-"];
  String _actualVote;
  int _numberOfUpVotes;
  int _numberOfDownVotes;
  Future<LoadInfo> episodeInfo;
  List<Comment> commentList;

  setLanguage(int language, List<AnimeStream> streams) {
    setState(() {
      this._language = language;
      var dl = GetStreamsAsDropdownList(streams, language, languages);
      this._streams = dl.getItems();
      changeHoster(0);
    });
  }

  changeHoster(int hoster) {
    setState(() {
      this._hoster = hoster;
      updateStream();
    });
  }

  updateStream() {
    setState(() {
      for (var stream in _links) {
        if (_hosters[_hoster] == stream.hoster.name &&
            languages[_language] == stream.lang) {
          this._stream = stream.link;
          return;
        }
      }
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

  updateEpisodeData(String name, int season, int number) {
    setState(() {
      this.episodeInfo = APIManager.getEpisodeInfo(name, season, number);
      this.languages = [];
      this._links = [];
      this._language = null;
      this._hoster = null;
      this._hosters = [];
      this._isReported = null;
      this._actualVote = null;
      this._numberOfUpVotes = null;
      this._numberOfDownVotes = null;
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
    this.episodeInfo = APIManager.getEpisodeInfo(name, season, number);
  }

  addComment(Comment newComment) {
    setState(() {
      commentList.add(newComment);
    });
  }


  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("episode_screen"),
      child: FutureBuilder<LoadInfo>(
        future: episodeInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var episode = snapshot.data.episodeInfo;
            for (var stream in episode.streams) {
              if (!languages.contains(stream.lang)) {
                languages.add(stream.lang);
              }
              if (!_hosters.contains(stream.hoster.name)) {
                _hosters.add(stream.hoster.name);
              }
            }
            var formated_date = DateTime.parse(episode.created_at);
            _isReported =
                _isReported == null ? episode.hasReports == 1 : _isReported;

            if (_numberOfDownVotes == null || _numberOfUpVotes == null) {
              _numberOfDownVotes = 0;
              _numberOfUpVotes = 0;
              _links = episode.streams;
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

            if (_stream == null) {
              for (var stream in _links) {
                if (_hosters[0] == stream.hoster.name &&
                    languages[0] == stream.lang) {
                  this._stream = stream.link;
                }
              }
            }

            if (commentList == null) {
              commentList = episode.comments;
            }
            List<Widget> _commentElements = [];
            for (var comment in commentList) {
              _commentElements
                  .add(CommentContainer(comment, snapshot.data.user, this));
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
                                  updateEpisodeData(
                                      episode.season.show.url,
                                      episode.season.number,
                                      (episode.number - 1));
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
                                  updateEpisodeData(
                                      episode.season.show.url,
                                      episode.season.number,
                                      (episode.number + 1));
                                }
                              : () {},
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: (_hosters[_hoster] == "Anistream")
                          ? InAppWebView(
                              initialHeaders: {},
                              initialOptions: {},
                              onWebViewCreated:
                                  (InAppWebViewController controller) {
                                controller.loadUrl(_stream);
                              })
                          : Center(
                              child: IconButton(
                                  icon: Icon(Icons.play_circle_outline),
                                  onPressed: () =>
                                      ChromeSafariBrowser(null).open(_stream))),
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
                                    if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
                                      APIManager.setEpisodeVote(episode.id, null, 1);
                                    } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
                                      APIManager.setEpisodeVote(episode.id, 1, null);
                                    } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
                                      APIManager.setEpisodeVote(episode.id, 0, 1);
                                    }
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

                                    if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
                                      APIManager.setEpisodeVote(episode.id, null, 0);
                                    } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
                                      APIManager.setEpisodeVote(episode.id, 1, 0);
                                    } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
                                      APIManager.setEpisodeVote(episode.id, 0, null);
                                    }
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
                      expanded: Column(children: [
                        CommentComponent(snapshot.data.user, this),
                        Column(children: _commentElements)
                      ]),
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
  List<DropdownMenuItem<int>> namelist = [];
  List<AnimeStream> streams = [];
  List<String> languages;
  int language;

  GetStreamsAsDropdownList(this.hosters, this.language, this.languages) {
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
  }

  List<DropdownMenuItem<int>> getItems() {
    return namelist;
  }

  List<String> getHosters() {
    List<String> list = [];
    for (var stream in streams) {
      list.add(stream.hoster.name);
    }
    return list;
  }

  List<AnimeStream> getStreams() {
    return hosters;
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

class LoadInfo {
  User user;
  EpisodeInfo episodeInfo;

  LoadInfo(this.user, this.episodeInfo);
}
