import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favoriten extends StatelessWidget {

  MainWidgetState state;
  Future<List<Show>> favouriteData;
  List<Show> favouriteList;

  Favoriten(this.state){
    favouriteData = APIManager.getFavourite();
  }
  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("favourites"),
      child: FutureBuilder(future: favouriteData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            favouriteList = snapshot.data;
            return Container(
              padding: EdgeInsets.all(5),
              color: Theme.of(ctx).backgroundColor,
              child: ListView(
                children: getFavouritesAsWidgets(ctx, favouriteList),
              ),
            );
          }else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },),
    );
  }

  List<Widget> getFavouritesAsWidgets(BuildContext ctx, List<Show> favouriteList){
    List<Widget> watchlistWidget = [Container(padding: EdgeInsets.all(5),child: Text("Favoriten", style: TextStyle(color: Theme.of(ctx).textTheme.title.color, fontSize: 30, fontWeight: FontWeight.bold)))];

    for(var anime in favouriteList){
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