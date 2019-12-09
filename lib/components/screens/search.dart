import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/components/custom/search/searchList.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchAnime extends StatefulWidget implements Screen{
  MainWidgetState state;

  SearchAnime(this.state);

  @override
  getScreenName() {
    return "search_screen";
  }

  @override
  SearchAnimeState createState() => SearchAnimeState(state);
}

class SearchAnimeState extends State<SearchAnime> {
  Future<SearchAnime> searchAnimeData;
  MainWidgetState state;
  Future<List<Show>> shows;


  SearchAnimeState(this.state);

  updateSearchList(String searchText) {
    setState(() {
      this.shows = APIManager.searchShows(searchText);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var controller = TextEditingController();


    return Container(
      key: Key("search_screen"),
      color: Theme
          .of(ctx)
          .backgroundColor,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
                  keyboardType: TextInputType.multiline,
                  controller: controller,
                  maxLines: null,
                  maxLength: 100,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: 'Search..'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Theme.of(ctx).primaryIconTheme.color,
                onPressed: () {
                  var analytics = state.analytics;
                  analytics.logSearch(searchTerm: controller.text);
                  updateSearchList(controller.text);
                  controller.text = "";
                },
              )
            ],
          ),
          (shows == null)?Container()
          : SearchList(shows, state)
        ],
      )


    );

  }
}
