import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/main.dart';

class EpisodeBar extends StatefulWidget {
  EpisodeInfo _episode;
  MainWidgetState _state;
  Function(EpisodeBarState) _created;

  EpisodeBar(this._episode, this._state,this._created);

  @override
  EpisodeBarState createState() => EpisodeBarState(this._episode, this._state,this._created);
}

class EpisodeBarState extends State<EpisodeBar> {
  EpisodeInfo _episode;
  MainWidgetState _state;
  Function(EpisodeBarState) _created;
  bool _isReported;
  List<String> possibleVotes = [null, "+", "-"];
  String _actualVote;
  int _numberOfUpVotes;
  int _numberOfDownVotes;

  EpisodeBarState(this._episode, this._state,this._created);

  void init(){
    _isReported = _episode.hasReports == 1;

    _numberOfDownVotes = 0;
    _numberOfUpVotes = 0;
    for (var votes in _episode.votes) {
      if (votes.value == 0) {
        _numberOfDownVotes = _numberOfDownVotes + 1;
      } else if (votes.value == 1) {
        _numberOfUpVotes = _numberOfUpVotes + 1;
      }
    }

    if (_episode.voted == 0) {
      _actualVote = possibleVotes.elementAt(2);
    } else if (_episode.voted == 1) {
      _actualVote = possibleVotes.elementAt(1);
    }
    _created(this);
  }

  @override
  void initState() {
      init();
      super.initState();
    }

  updateEpisode(EpisodeInfo episode) {
    setState(() {
      this._episode = episode;
      init();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var formated_date = DateTime.parse(_episode.created_at);
    return Column(
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0),
          child: Column(children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: ThemeText(
                (_episode != null) ? _episode.name : "",
                ctx,
                fontWeight: FontWeight.bold,
                softWrap: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ThemeText(
                    "S " +
                        _episode.season.number.toString() +
                        " E " +
                        _episode.number.toString(),
                    ctx,
                    fontWeight: FontWeight.bold),
                Expanded(
                  child: ThemeText(
                    _episode.season.show.name,
                    ctx,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ]),
          onPressed: () {
            _state.changePage(AnimeScreen(_episode.season.show.url, _state), 7);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                ThemeText(
                    (formated_date.day.toString() +
                        "." +
                        formated_date.month.toString() +
                        "." +
                        formated_date.year.toString()),
                    ctx,
                    fontSize: 15),
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
                      setState(() {
                        _isReported = !_isReported;
                      });
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
                                _actualVote == possibleVotes.elementAt(2)
                            ? Theme.of(ctx).primaryIconTheme.color
                            : Theme.of(ctx).accentIconTheme.color,
                      ),
                      onPressed: () {
                        if (_actualVote ==
                            possibleVotes.elementAt(0) /*null*/) {
                          APIManager.setEpisodeVote(_episode.id, null, 1);
                        } else if (_actualVote ==
                            possibleVotes.elementAt(1) /*+*/) {
                          APIManager.setEpisodeVote(_episode.id, 1, null);
                        } else if (_actualVote ==
                            possibleVotes.elementAt(2) /*-*/) {
                          APIManager.setEpisodeVote(_episode.id, 0, 1);
                        }
                        makeUpVote();
                      },
                    ),
                    ThemeText(
                      _numberOfUpVotes.toString(),
                      ctx,
                      fontSize: 15,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: (_actualVote == null ||
                                _actualVote == possibleVotes.elementAt(1))
                            ? Theme.of(ctx).primaryIconTheme.color
                            : Theme.of(ctx).accentIconTheme.color,
                      ),
                      onPressed: () {
                        if (_actualVote ==
                            possibleVotes.elementAt(0) /*null*/) {
                          APIManager.setEpisodeVote(_episode.id, null, 0);
                        } else if (_actualVote ==
                            possibleVotes.elementAt(1) /*+*/) {
                          APIManager.setEpisodeVote(_episode.id, 1, 0);
                        } else if (_actualVote ==
                            possibleVotes.elementAt(2) /*-*/) {
                          APIManager.setEpisodeVote(_episode.id, 0, null);
                        }
                        makeDownVote();
                      },
                    ),
                    ThemeText(
                      _numberOfDownVotes.toString(),
                      ctx,
                      fontSize: 15,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
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
}
