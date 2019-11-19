import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCommentContainer extends StatefulWidget {
  SubComment comment;

  SubCommentContainer(SubComment comment) {
    this.comment = comment;
  }

  @override
  SubCommentContainerState createState() => SubCommentContainerState(this.comment);
}

class SubCommentContainerState extends State<SubCommentContainer> {
  String text;
  User user;
  List<SubComment> subComments = [];
  List<Vote> votes = [];
  String createdAt;
  int voted;
  String _actualVote;
  List<String> possibleVotes = [null, "+", "-"];
  int _numberOfUpVotes;
  int _numberOfDownVotes;

  SubCommentContainerState(SubComment comment) {
    this.text = comment.text;
    this.user = comment.user;
    this.votes = comment.votes;
    this.voted = comment.voted;
    this.createdAt = comment.created_at;
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

  sortVotes(){
    if (_numberOfDownVotes == null || _numberOfUpVotes == null) {
      _numberOfDownVotes = 0;
      _numberOfUpVotes = 0;
      for (var votes in this.votes) {
        if (votes.value == 0) {
          _numberOfDownVotes = _numberOfDownVotes + 1;
        } else if (votes.value == 1) {
          _numberOfUpVotes = _numberOfUpVotes + 1;
        }
      }
      if (this.voted == 0) {
        _actualVote = possibleVotes.elementAt(2);
      } else if (this.voted == 1) {
        _actualVote = possibleVotes.elementAt(1);
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
    sortVotes();
    return Container(
      padding: EdgeInsets.only(left: 55),
      color: Theme.of(ctx).backgroundColor,
      child: Row(children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          (user.avatar == null)
              ? FloatingActionButton(
            backgroundColor: Theme.of(ctx).backgroundColor,
            elevation: 0,
            child: Icon(
              Icons.person,
            ),
          )
              : FloatingActionButton(
            backgroundColor: Theme.of(ctx).backgroundColor,
            elevation: 0,
            child: IconButton(
              icon: new Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "https://www2.aniflix.tv/storage/" +
                              user.avatar,
                        ),
                      ))),
            ),
          )
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            Row(
              children: [
                Text(
                  user.name + " ",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                (this.createdAt != null)
                    ? Text(this.createdAt,
                    style: TextStyle(color: Colors.white, fontSize: 9.0))
                    : Text("",
                    style: TextStyle(color: Colors.white, fontSize: 10.0))
              ],
            ),
            Row(
              children: [
                Text(
                  this.text,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: 15,
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
                          fontSize: 12,
                          color:
                          Theme.of(ctx).textTheme.title.color),
                    )
                  ],
                ),
                Row(

                  children: <Widget>[
                    IconButton(
                      iconSize: 15,
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
                          fontSize: 12,
                          color:
                          Theme.of(ctx).textTheme.title.color),
                    )
                  ],
                )
              ],
            )
          ],
        )
      ]),
    );
  }
}
