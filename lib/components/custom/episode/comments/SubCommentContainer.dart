import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SubCommentContainer.dart';

class SubCommentContainer extends StatefulWidget {
  SubComment comment;
  User user;

  SubCommentContainer(SubComment comment, this.user) {
    this.comment = comment;
  }

  @override
  SubCommentContainerState createState() => SubCommentContainerState(this.comment, this.user);
}

class SubCommentContainerState extends State<SubCommentContainer> {
  int id;
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
  bool _isReported;
  User currentUser;

  SubCommentContainerState(SubComment comment, this.currentUser) {
    this.id = comment.id;
    this.text = comment.text;
    this.user = comment.user;
    this.votes = comment.votes;
    this.voted = comment.voted;
    this.createdAt = comment.created_at;
  }

  getSubCommentsAsContainers() {
    List<SubCommentContainer> containers = [];
    for (var comment in subComments) {
      SubCommentContainer cont = SubCommentContainer(comment, this.currentUser);
      containers.add(cont);
    }
    return containers;
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

  sortVotes() {
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
    var date = DateTime.parse(this.createdAt);
    String minute = date.minute.toString();
    String hour = date.hour.toString();
    if(date.minute < 10){
      minute = "0" + date.minute.toString();
    }
    if(date.hour < 10){
      hour = "0" + date.hour.toString();
    }
    return Container(
      padding: EdgeInsets.only(left: 55),
      color: Theme.of(ctx).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  (user.avatar == null)
                      ? IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Theme.of(ctx).primaryIconTheme.color,
                    ),
                    onPressed: (){},
                  )
                      : IconButton(
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
                    onPressed: (){},
                  ),
                ]),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.name + " ",
                            style:
                            TextStyle(color: Theme.of(ctx).textTheme.title.color, fontSize: 12.0),
                          ),
                          (this.createdAt != null)
                              ? Text(date.day.toString() + "." + date.month.toString() + "." + date.year.toString() + " " + hour + ":" + minute,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 9.0))
                              : Text("",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 15,
                            icon: Icon(
                              Icons.report,
                              color:
                              Theme.of(ctx).primaryIconTheme.color,
                            ),
                            onPressed: () {
                              if (!_isReported) {
                                report();
                              }
                            },
                          )
                        ],
                      ),
                      Text(
                        this.text,
                        style: TextStyle(color: Theme.of(ctx).textTheme.title.color, fontSize: 12.0),
                        softWrap: true,
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                iconSize: 12,
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
                                    APIManager.setCommentVote(this.id, null, 1);
                                  } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
                                    APIManager.setCommentVote(this.id, 1, null);
                                  } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
                                    APIManager.setCommentVote(this.id, 0, 1);
                                  }
                                  makeUpVote();
                                },
                              ),
                              Text(
                                _numberOfUpVotes.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(ctx).textTheme.title.color),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                iconSize: 12,
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
                                    APIManager.setCommentVote(this.id, null, 0);
                                  } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
                                    APIManager.setCommentVote(this.id, 1, 0);
                                  } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
                                    APIManager.setCommentVote(this.id, 0, null);
                                  }
                                  makeDownVote();
                                },
                              ),
                              Text(
                                _numberOfDownVotes.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(ctx).textTheme.title.color),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ],
          ),
          Column(
            children: getSubCommentsAsContainers(),
          )
        ],
      ),
    );
  }
}
