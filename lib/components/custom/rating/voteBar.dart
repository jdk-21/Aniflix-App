import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class VoteBar extends StatelessWidget {
  int _id;
  List<Vote> _votes;
  int _voted;
  Function(int,int) _onVote;
  List<String> possibleVotes = [null, "+", "-"];
  String _actualVote;
  int _numberOfUpVotes;
  int _numberOfDownVotes;

  VoteBar(this._id, this._votes, this._voted, this._onVote){
    init();
  }

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
  Widget build(BuildContext ctx) {
    return Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                size: 20,
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
              },
            ),
            ThemeText(
              _numberOfUpVotes.toString(),
              fontSize: 15,
            )
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.thumb_down,
                size: 20,
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
              },
            ),
            ThemeText(
              _numberOfDownVotes.toString(),
              fontSize: 15,
            )
          ],
        )
      ],
    );
  }
}
