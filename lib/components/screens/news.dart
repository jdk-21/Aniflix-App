import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/news/News.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/news/newsContainer.dart';

import '../../main.dart';

class NewsPage extends StatelessWidget implements Screen {
  Future<List<News>> news;

  NewsPage() {
    this.news = APIManager.getNews();
  }

  @override
  getScreenName() {
    return "news_screen";
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
        color: Theme.of(ctx).backgroundColor,
        key: Key("news_screen"),
        child: Column(
          children: <Widget>[
          (AppState.adFailed) ? Container() : SizedBox(height: 50,),
            Expanded(
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
                      return Center(child: CircularProgressIndicator());
                    }))
          ],
        ));
  }

  List<Widget> getNotificationsAsList(BuildContext ctx, List<News> news) {
    List<Widget> newsList = [
      Container(
        padding: EdgeInsets.all(5),
        child:
            ThemeText("News", ctx, fontWeight: FontWeight.bold, fontSize: 30),
      ),
    ];
    for (int v = 0; v < news.length; v++) {
      var actualNotification = news.elementAt(v);
      newsList.add(NewsContainer(actualNotification.text, ctx));
    }
    return newsList;
  }
}
