import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/news.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/episode.dart';

class NotificationContainer extends Container {
  NotificationContainer(var notification, BuildContext ctx, Function(int) onDelete)
      : super(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 1,
                  color: Theme.of(ctx).hintColor,
                  style: BorderStyle.solid))),
      child: Row(
          children: [
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    if(notification.link.contains('show')){
                      var splitLink = notification.link.split('/');
                      Navigator.pushNamed(ctx, "episode", arguments: new EpisodeScreenArguments(splitLink[2], int.parse(splitLink[5]), int.parse(splitLink[7])));
                    }else if(notification.link.contains('users')){
                      Navigator.pushNamed(ctx, "profil",arguments: CacheManager.userData.id);
                    }
                  },
                  child:
                  ThemeText(
                  notification.text,
                  ctx,
                  softWrap: true,
                ),
              ),
            ),
                IconButton(
                  onPressed: (){
                    APIManager.deleteNotification(notification.id);
                    onDelete(notification.id);
                  },
                  icon:Icon(
                    Icons.delete,
                    color: Theme.of(ctx)
                        .primaryIconTheme
                        .color,
                  ),
                )

          ]
      )
  );
}
