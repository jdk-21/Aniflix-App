import 'package:aniflix_app/api/objects/news/NotificationListData.dart';
import 'package:aniflix_app/api/requests/notifications/NotificationRequests.dart';
import 'package:aniflix_app/components/custom/news/FriendNotification.dart';
import 'package:aniflix_app/components/custom/news/NewsNotification.dart';
import 'package:aniflix_app/components/custom/news/PersonalNotification.dart';
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
    this.news = NotificationRequests.getNotifications();
  }

  onDelete(int id) {
    setState(() {
      newsdata.notifications.removeWhere((element) => element.id == id);
    });
  }

  onDeleteAll() async {
    var tmp = [];
    tmp.addAll(newsdata.notifications);
    setState(() {
      newsdata.notifications = [];
    });
    for (var notification in tmp) {
      if (notification.deleted_at == null) {
        await NotificationRequests.deleteNotification(notification.id);
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
        color: Colors.transparent,
        key: Key("news_screen"),
        child: Column(
          children: <Widget>[
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
      newsdata.notifications != null && newsdata.notifications.length > 0
          ? Container(
              padding: EdgeInsets.all(5),
              child: ThemeText("Persönliche Notifications",
                  fontWeight: FontWeight.bold, fontSize: 30),
            )
          : Container(),
    ];
    List<PersonalNotification> personalNews = [];
    if (newsdata.notifications != null) {
      var notifications = newsdata.notifications;
      for (int y = 0; y < notifications.length; y++) {
        var actualNotification = notifications.elementAt(y);
        if (actualNotification.deleted_at == null) {
          if (actualNotification.link.contains('show')) {
            personalNews.add(SubNotification(
                actualNotification.id,
                actualNotification.text,
                actualNotification.link,
                onDelete,
                ctx));
          } else if (actualNotification.link.contains('users')) {
            personalNews.add(FriendNotification(
                actualNotification.id, actualNotification.text, onDelete, ctx));
          }
        }
      }
    }
    if (personalNews.length > 0) {
      newsList.add(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
        child: FlatButton(
          onPressed: () {
            onDeleteAll();
          },
          child: ThemeText(
            "Alle Löschen",
            softWrap: true,
          ),
        ),
      ));
      newsList.addAll(personalNews);
    } else {
      newsList.add(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
        child: FlatButton(
          onPressed: () {},
          child: ThemeText(
            "Du hast derzeit keine Benachrichtigungen!",
            softWrap: true,
          ),
        ),
      ));
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
