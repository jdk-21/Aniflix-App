import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/news/PersonalNotification.dart';
import 'package:aniflix_app/components/screens/episode.dart';

class SubNotification extends PersonalNotification {
  SubNotification(int _id, String _message, String _link,
      Function(int) onDelete, BuildContext ctx)
      : super(_id, _message, () {
          var splitLink = _link.split('/');
          Navigator.pushNamed(ctx, "episode",
              arguments: new EpisodeScreenArguments(splitLink[2],
                  int.parse(splitLink[5]), int.parse(splitLink[7])));
        }, onDelete, ctx);
}
