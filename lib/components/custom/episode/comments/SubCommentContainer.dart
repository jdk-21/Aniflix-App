import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import '../../rating/voteBar.dart';
import '../../report/reportDeleteBar.dart';
import '../../../screens/episode.dart';

class SubCommentContainer extends StatelessWidget {
  SubComment _comment;
  EpisodeScreenState episodeScreenState;
  User _user;
  Function() _onSubDelete;

  SubCommentContainer(
      this._comment, this._user, this._onSubDelete, this.episodeScreenState);

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
        padding: EdgeInsets.only(left: 55),
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
                                        fontSize: 10.0)),
                            ReportDeleteBar(
                                (_user.id == _comment.user_id), () {}, () {
                              _onSubDelete();
                            })
                          ],
                        ),
                        ThemeText(
                          this._comment.text,
                          ctx,
                          fontSize: 12.0,
                          softWrap: true,
                        ),
                        Row(
                          children: [
                            VoteBar(_comment.id, _comment.votes, _comment.voted,
                                (prev, next) {
                              var commentlist = episodeScreenState.comments;
                              for (int i = 0; i < commentlist.length; i++) {
                                for(int k = 0; k < commentlist[i].comments.length; k++) {
                                  if (commentlist[i].comments[k].id == _comment.id) {
                                    episodeScreenState.setState(() {
                                      episodeScreenState.comments[i].comments[k].voted = next;
                                      var contained = false;
                                      for(int j = 0; j < commentlist[i].comments[k].votes.length; i++){
                                        if(commentlist[i].comments[k].votes[j].user_id == _user.id){
                                          if(next != null){
                                            commentlist[i].comments[k].votes[j].value = next;
                                          }else{
                                            commentlist[i].comments[k].votes.removeAt(j);
                                          }
                                          contained = true;
                                          break;
                                        }
                                      }
                                      if(!contained && next != null){
                                        commentlist[i].comments[k].votes.add(Vote(0, "Comment", 0, _user.id, next, DateTime.now().toString(), null, null));
                                      }
                                    });
                                  }
                                }
                              }
                              APIManager.setCommentVote(
                                  _comment.id, prev, next);
                            })
                          ],
                        ),
                      ]),
                ),
              ])
            ],
          ),
        ]));
  }
}