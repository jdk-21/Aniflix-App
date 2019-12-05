import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/User.dart';
import './CommentComponent.dart';
import './commentContainer.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import '../../../screens/episode.dart';

class CommentList extends Container {
  User _user;
  EpisodeInfo _episodeInfo;
  EpisodeScreenState episodeScreenState;
  List<Comment> _comments;
  Function(String) _onSend;
  Function(int,String) _onSubSend;
  Function(int) _onDelete;
  Function(int,int) _onSubDelete;

  CommentList(this._user, this._episodeInfo, this._comments, BuildContext ctx,
      this._onSend,this._onSubSend,this._onDelete,this._onSubDelete,this.episodeScreenState);

  @override
  Widget build(BuildContext ctx) {
    List<CommentContainer> commentContainers = _comments.map((comment) {
      return new CommentContainer(comment, _user,_onSubSend,_onDelete,_onSubDelete,episodeScreenState);
    }).toList();
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
            children: commentContainers)
      ]),
      headerAlignment: ExpandablePanelHeaderAlignment.center,
      tapHeaderToExpand: true,
      tapBodyToCollapse: true,
      hasIcon: false,
    ));
  }
}
