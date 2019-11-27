import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Watchlist extends StatelessWidget {

  MainWidgetState state;
  Future<List<Show>> watchlistdata;
  List<Show> watchlist;

  Watchlist(this.state){
    watchlistdata = APIManager.getWatchlist();
  }
  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("watchlist"),
      child: FutureBuilder(future: watchlistdata,
        builder: (context, snapshot){
        if(snapshot.hasData){
          watchlist = snapshot.data;
          return Container(
            padding: EdgeInsets.all(5),
            color: Theme.of(ctx).backgroundColor,
            child: ListView(
              children: getWatchlistAsWidgets(ctx, watchlist),
            ),
          );
        }else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
        },),
    );
  }

  List<Widget> getWatchlistAsWidgets(BuildContext ctx, List<Show> watchlist){
    List<Widget> watchlistWidget = [Container(padding: EdgeInsets.all(5),child: Text("Watchlist", style: TextStyle(color: Theme.of(ctx).textTheme.title.color, fontSize: 30, fontWeight: FontWeight.bold)))];

    for(var anime in watchlist){
      watchlistWidget.add(Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
        child: FlatButton(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
          onPressed: () {
            state.changePage(AnimeScreen(anime.url, state), 6);
          },
          child: Row(
            children: <Widget>[
              Image.network(
                          "https://www2.aniflix.tv/storage/" + anime.cover_portrait,
                          width: 50,
                          height: 75,
                        ),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                    anime.name,
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 20),
                    softWrap: true,
                  ))
            ],
          ),
        ),
      ));
    }
    return watchlistWidget;
  }
}