import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:expandable/expandable.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import './CommentComponent.dart';
import './commentContainer.dart';

class CommentPanel extends StatefulWidget {
  User _user;
  EpisodeInfo _episodeInfo;
  Function(CommentPanelState) _created;
  Function _onSend;

  CommentPanel(this._user, this._episodeInfo, this._created,this._onSend);

  @override
  CommentPanelState createState() =>
      CommentPanelState(_user, _episodeInfo, _created,_onSend);
}

class CommentPanelState extends State<CommentPanel> {
  User _user;
  EpisodeInfo _episodeInfo;
  List<Comment> _comments;
  Function(CommentPanelState) _created;
  Function(String) _onSend;

  CommentPanelState(this._user, this._episodeInfo, this._created,this._onSend);

  void init() {
    this._comments = _episodeInfo.comments;
    _created(this);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  updateEpisode(EpisodeInfo episode) {
    setState(() {
      this._episodeInfo = episode;
      init();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return ExpandablePanel(
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
        Column(children: _comments.map((comment){
          return CommentContainer(comment, _user);
        }).toList())
      ]),
      headerAlignment: ExpandablePanelHeaderAlignment.center,
      tapHeaderToExpand: true,
      tapBodyToCollapse: true,
      hasIcon: false,
    );
  }
}
