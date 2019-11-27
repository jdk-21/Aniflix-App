import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/components/custom/comments/CommentComponent.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AnswerCommentComponent.dart';
import 'SubCommentContainer.dart';

class CommentContainer extends StatefulWidget {
  Comment comment;
  User user;
  EpisodeScreenState episodeScreenState;

  CommentContainer(Comment comment, this.user, this.episodeScreenState) {
    this.comment = comment;
  }

  @override
  CommentContainerState createState() =>
      CommentContainerState(this.comment, this.user, this.episodeScreenState);
}

class CommentContainerState extends State<CommentContainer> {
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
  var reports;
  User currentUser;
  bool _needAnswer = false;
  EpisodeScreenState state;

  CommentContainerState(Comment comment, this.currentUser, this.state) {
    this.text = comment.text;
    this.user = comment.user;
    this.subComments = comment.comments;
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

  changeNeedAnswer(){
    setState(() {
      _needAnswer = !_needAnswer;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    sortVotes();
    var date = DateTime.parse(this.createdAt);
    String minute = date.minute.toString();
    String hour = date.hour.toString();
    if (date.minute < 10) {
      minute = "0" + date.minute.toString();
    }
    if (date.hour < 10) {
      hour = "0" + date.hour.toString();
    }
    return Container(
      color: Theme.of(ctx).backgroundColor,
      child: Column(
        children: [
          Column(
            children: [
              Row(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: (user.avatar == null)
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

                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.name + " ",
                            style: TextStyle(
                                color: Theme.of(ctx).textTheme.title.color,
                                fontSize: 12.0),
                          ),
                          (this.createdAt != null)
                              ? Text(
                                  date.day.toString() +
                                      "." +
                                      date.month.toString() +
                                      "." +
                                      date.year.toString() +
                                      " " +
                                      hour +
                                      ":" +
                                      minute,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 9.0))
                              : Text("",
                                  style: TextStyle(
                                      color:
                                          Theme.of(ctx).textTheme.title.color,
                                      fontSize: 10.0)),
                          (user.id == currentUser.id)
                              ? IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 15,
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(ctx).primaryIconTheme.color,
                                  ),
                                  onPressed: () {
                                    if (!_isReported) {
                                      report();
                                    }
                                  },
                                )
                              : Container(),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 15,
                            icon: Icon(
                              Icons.report,
                              color: Theme.of(ctx).primaryIconTheme.color,
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
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.title.color,
                            fontSize: 12.0),
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
                          _needAnswer ? SizedBox() : FlatButton(onPressed: (){changeNeedAnswer();},child: Text("Antworten", style: TextStyle(fontWeight: FontWeight.normal, color: Theme.of(ctx).textTheme.title.color),),)
                        ],
                      ),
                    ],
                  ),
                )
              ]),
              _needAnswer ? AnswerCommentComponent(this.currentUser, this) : SizedBox()
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
