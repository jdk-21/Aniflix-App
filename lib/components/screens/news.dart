import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/news/News.dart';

class NewsPage extends StatelessWidget {
  Future<List<News>> news;

  NewsPage() {
    this.news = APIManager.getNews();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      color: Theme.of(ctx).backgroundColor,
        key: Key("notification_screen"),
        child: FutureBuilder<List<News>>(
            future: news,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var news = snapshot.data;
                return ListView(
                    children: getNotificationsAsList(context, news));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            }));
  }

  List<Widget> getNotificationsAsList(BuildContext ctx, List<News> news) {
    List<Widget> newsList = [
      Container(
        padding: EdgeInsets.all(5),
        child: Text("News",
            style: TextStyle(
                color: Theme.of(ctx).textTheme.title.color,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
      ),
    ];
    for (int v = 0; v < news.length; v++) {
      var actualNotification = news.elementAt(v);
      newsList.add(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
        child: Text(
          actualNotification.text,
          style: TextStyle(
              color: Theme.of(ctx).textTheme.title.color, fontSize: 20),
          softWrap: true,
        ),
      ));
    }
    return newsList;
  }
}
