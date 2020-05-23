import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/news/NotificationListData.dart';
import 'package:aniflix_app/components/custom/news/FriendNotification.dart';
import 'package:aniflix_app/components/custom/news/NewsNotification.dart';
import 'package:aniflix_app/components/custom/news/SubNotification.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

import '../../main.dart';

class NewsPage extends StatefulWidget implements Screen {
  @override
  getScreenName() {
    return "news_screen";
  }

  @override
  State<StatefulWidget> createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  Future<NotificationListData> news;
  NotificationListData newsdata;

  NewsPageState() {
    this.news = APIManager.getNotifications();
  }

  onDelete(int id) {
    setState(() {
      newsdata.notifications.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
        color: Theme.of(ctx).backgroundColor,
        key: Key("news_screen"),
        child: Column(
          children: <Widget>[
            (AppState.adFailed)
                ? Container()
                : SizedBox(
                    height: 50,
                  ),
            Expanded(
                child: FutureBuilder<NotificationListData>(
                    future: news,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (newsdata == null) {
                          newsdata = snapshot.data;
                        }
                        return ListView(
                            children: getNotificationsAsList(context));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default, show a loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }))
          ],
        ));
  }

  List<Widget> getNotificationsAsList(BuildContext ctx) {
    List<Widget> newsList = [
      Container(
        padding: EdgeInsets.all(5),
        child: ThemeText("Persönliche Notifications",
            fontWeight: FontWeight.bold, fontSize: 30),
      ),
    ];
    var notifications = newsdata.notifications;
    for (int y = 0; y < notifications.length; y++) {
      var actualNotification = notifications.elementAt(y);
      if (actualNotification.deleted_at == null) {
        if (actualNotification.link.contains('show')) {
          newsList.add(SubNotification(actualNotification.id,
              actualNotification.text, actualNotification.link, onDelete, ctx));
        } else if (actualNotification.link.contains('users')) {
          newsList.add(FriendNotification(
              actualNotification.id, actualNotification.text, onDelete, ctx));
        }
      }
    }
    newsList.add(Container(
      padding: EdgeInsets.all(5),
      child: ThemeText("News", fontWeight: FontWeight.bold, fontSize: 30),
    ));
    var news = newsdata.news;
    for (int v = 0; v < news.length; v++) {
      var actualNotification = news.elementAt(v);
      newsList.add(NewsNotification(actualNotification.text));
    }
    return newsList;
  }
}
