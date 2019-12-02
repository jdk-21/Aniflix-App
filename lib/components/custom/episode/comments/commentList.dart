import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/User.dart';
import './CommentComponent.dart';
import './commentContainer.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';

class CommentList extends Container {
  User _user;
  EpisodeInfo _episodeInfo;
  List<Comment> _comments;
  Function(String) _onSend;
  Function(int,String) _onSubSend;

  CommentList(this._user, this._episodeInfo, this._comments, BuildContext ctx,
      this._onSend,this._onSubSend);

  @override
  Widget build(BuildContext ctx) {
    return Container(child: ExpandablePanel(
      header: Align(
        alignment: Alignment.center,
        child: ThemeText(
          "Kommentare",
          ctx,
          fontWeight: FontWeight.bold,
        ),
      ),
      expanded: Column(children: [
        CommentComponent(_user, _onSend),
        Column(
            children: _comments.map((comment) {
              return new CommentContainer(comment, _user,_onSubSend);
            }).toList())
      ]),
      headerAlignment: ExpandablePanelHeaderAlignment.center,
      tapHeaderToExpand: true,
      tapBodyToCollapse: true,
      hasIcon: false,
    ));
  }
}
