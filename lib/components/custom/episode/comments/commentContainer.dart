import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'answerBar.dart';
import 'SubCommentContainer.dart';
import '../../rating/voteBar.dart';
import '../../dialogs/reportDialog.dart';
import '../../report/reportDeleteBar.dart';
import '../../../screens/episode.dart';

class CommentContainer extends Container {
  Comment _comment;
  User _user;
  EpisodeScreenState episodeScreenState;
  Function(int, String) _onSubSend;
  Function(int) _onDelete;
  Function(int, int) _onSubDelete;

  CommentContainer(this._comment, this._user, this._onSubSend, this._onDelete,
      this._onSubDelete, this.episodeScreenState);

  @override
  Widget build(BuildContext ctx) {
    var date = DateTime.parse(this._comment.created_at);
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
        child: Column(children: [
          Column(
            children: [
              Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.ltr,
                      children: [

                            Column(children: [
                              Row(children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: (_comment.user.avatar == null)
                                      ? IconButton(
                                    icon: Icon(
                                      Icons.person,
                                      color: Theme.of(ctx).primaryIconTheme.color,
                                    ),
                                    onPressed: () {},
                                  )
                                      : IconButton(
                                    iconSize: 40,
                                    icon: new Container(
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                "https://www2.aniflix.tv/storage/" +
                                                    _comment.user.avatar,
                                              ),
                                            ))),
                                    onPressed: () {},
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  ThemeText(
                                    _comment.user.name + " ",
                                    ctx,
                                    fontSize: 20.0,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                  Row(children: [
                                    (this._comment.created_at != null)
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
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15.0))
                                        : Text("",
                                        style: TextStyle(
                                            color:
                                            Theme.of(ctx).textTheme.title.color,
                                            fontSize: 10.0)),
                                    ReportDeleteBar((_user.id == _comment.user_id), () {
                                      showDialog(
                                          context: ctx,
                                          builder: (BuildContext ctx) {
                                            return ReportDialog((text) {
                                              APIManager.reportComment(
                                                  _comment.id, text);
                                            });
                                          });
                                    }, () {
                                      _onDelete(_comment.id);
                                    })
                                  ],),
                                ],),

                              ]),


                            ],
                            ),
                        ThemeText(
                          this._comment.text,
                          ctx,
                          fontSize: 18.0,
                          softWrap: true,
                        ),
                        Row(
                          children: [
                            VoteBar(_comment.id, _comment.votes, _comment.voted,
                                (prev, next) {
                              var commentlist = episodeScreenState.comments;
                              for (int i = 0; i < commentlist.length; i++) {
                                if (commentlist[i].id == _comment.id) {
                                  episodeScreenState.setState(() {
                                    episodeScreenState.comments[i].voted = next;
                                    var contained = false;
                                    for (int j = 0;
                                        j < commentlist[i].votes.length;
                                        j++) {
                                      if (commentlist[i].votes[j].user_id ==
                                          _user.id) {
                                        if (next != null) {
                                          commentlist[i].votes[j].value = next;
                                        } else {
                                          commentlist[i].votes.removeAt(j);
                                        }
                                        contained = true;
                                        break;
                                      }
                                    }
                                    if (!contained && next != null) {
                                      commentlist[i].votes.add(Vote(
                                          0,
                                          "Comment",
                                          0,
                                          _user.id,
                                          next,
                                          DateTime.now().toString(),
                                          null,
                                          null));
                                    }
                                  });
                                }
                              }
                              APIManager.setCommentVote(
                                  _comment.id, prev, next);
                            }),
                            FlatButton(
                                onPressed: () {
                                  episodeScreenState.setState(() {
                                    var comments = episodeScreenState.comments;
                                    for (int i = 0; i < comments.length; i++) {
                                      if (comments[i].id == _comment.id) {
                                        episodeScreenState
                                                .comments[i].needAnswer =
                                            !episodeScreenState
                                                .comments[i].needAnswer;
                                      }
                                    }
                                  });
                                },
                                child: ThemeText(
                                  "Antworten",
                                  ctx,
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        ),
                      ]),
                ),
              ]),
              AnswerBar(this._user, _comment.needAnswer, (text) {
                _onSubSend(_comment.id, text);
              }),
              Column(
                children: _comment.comments.map((comment) {
                  return new SubCommentContainer(comment, _user, () {
                    _onSubDelete(_comment.id, comment.id);
                  }, episodeScreenState);
                }).toList(),
              )
            ],
          ),
        ]));
  }
}
