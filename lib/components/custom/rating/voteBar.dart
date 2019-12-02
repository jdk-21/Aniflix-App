import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class VoteBar extends StatefulWidget {
  int _id;
  List<Vote> _votes;
  int _voted;
  Function(int,int) _onVote;

  VoteBar(this._id, this._votes, this._voted, this._onVote);

  @override
  VoteBarState createState() =>
      VoteBarState(this._id, this._votes, this._voted, this._onVote);
}

class VoteBarState extends State<VoteBar> {
  int _id;
  List<Vote> _votes;
  int _voted;
  Function(int,int) _onVote;
  List<String> possibleVotes = [null, "+", "-"];
  String _actualVote;
  int _numberOfUpVotes;
  int _numberOfDownVotes;

  VoteBarState(this._id, this._votes, this._voted, this._onVote);

  void init() {
    _numberOfDownVotes = 0;
    _numberOfUpVotes = 0;
    for (var votes in _votes) {
      if (votes.value == 0) {
        _numberOfDownVotes = _numberOfDownVotes + 1;
      } else if (votes.value == 1) {
        _numberOfUpVotes = _numberOfUpVotes + 1;
      }
    }
    if(_voted == null){
      _actualVote = possibleVotes.elementAt(0);
    }else if (_voted == 1) {
      _actualVote = possibleVotes.elementAt(1);
    } else if (_voted == 0) {
      _actualVote = possibleVotes.elementAt(2);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  updateInfo(int id, List<Vote> votes, int voted) {
    setState(() {
      this._id = id;
      this._votes = votes;
      this._voted = voted;
      init();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Row(
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
                if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
                  _onVote(null, 1);
                } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
                  _onVote(1, null);
                } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
                  _onVote(0, 1);
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
                if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
                  _onVote(null, 0);
                } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
                  _onVote(1, 0);
                } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
                  _onVote(0, null);
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
