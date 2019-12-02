import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'answerBar.dart';
import 'SubCommentContainer.dart';
import '../../rating/voteBar.dart';
import '../../report/reportDeleteBar.dart';

class CommentContainer extends Container {
  Comment _comment;
  User _user;
  AnswerBarState answerBarState;
  Function(int,String) _onSubSend;

  CommentContainer(this._comment, this._user,this._onSubSend);

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
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.ltr,
                      children: [
                        Row(
                          children: [
                            ThemeText(
                              _comment.user.name + " ",
                              ctx,
                              fontSize: 12.0,
                            ),
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 9.0))
                                : Text("",
                                    style: TextStyle(
                                        color:
                                            Theme.of(ctx).textTheme.title.color,
                                        fontSize:
                                            10.0)),
                            ReportDeleteBar((_user.id == _comment.user_id),false,(){},(){},(state){})
                          ],
                        ),
                        ThemeText(
                          this._comment.text,
                          ctx,
                          fontSize: 12.0,
                          softWrap: true,
                        ),
                        Row(children: [
                          VoteBar(_comment.id, _comment.votes, _comment.voted,
                                  (prev, next) {
                                APIManager.setCommentVote(_comment.id, prev, next);
                              }),
                          FlatButton(
                              onPressed: () {
                                if (this.answerBarState != null) {
                                  this.answerBarState.toggleState();
                                }
                              },
                              child: ThemeText(
                                "Antworten",
                                ctx,
                                fontWeight: FontWeight.normal,
                              )),
                        ],),

                      ]),
                ),


              ]),
              AnswerBar(this._user, (state) {
                this.answerBarState = state;
              },(text){
                _onSubSend(_comment.id,text);
              }),
              Column(
                children: _comment.comments.map((comment) {
                  return new SubCommentContainer(comment, _user);
                }).toList(),
              )
            ],
          ),
        ]));
  }
}