
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/requests/search/SearchRequests.dart';
import 'package:aniflix_app/components/custom/search/searchList.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchAnime extends StatefulWidget implements Screen {
  SearchAnime();

  @override
  getScreenName() {
    return "search_screen";
  }

  @override
  SearchAnimeState createState() => SearchAnimeState();
}

class SearchAnimeState extends State<SearchAnime> {
  Future<SearchAnime> searchAnimeData;
  Future<List<Show>> shows;

  SearchAnimeState();

  updateSearchList(String searchText) {
    setState(() {
      this.shows = SearchRequests.searchShows(searchText);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var controller = TextEditingController();
    return Container(
        key: Key("search_screen"),
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (text) {
                          submit(controller);
                        },
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.caption.color),
                        keyboardType: TextInputType.multiline,
                        controller: controller,
                        maxLines: null,
                        maxLength: 100,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Search..'),
                        autofocus: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      color: Theme.of(ctx).primaryIconTheme.color,
                      onPressed: () {
                        submit(controller);
                      },
                    )
                  ],
                ),
                (shows == null) ? Container() : SearchList(shows),
              ],
            ))
          ],
        ));
  }

  submit(
    TextEditingController controller,
  ) {
    var text = controller.text;
    if (RegExp("^[a-zA-Z0-9_: ]*\$").hasMatch(text)) {
      var analytics = AppState.analytics;
      analytics.logSearch(searchTerm: controller.text);
      updateSearchList(controller.text);
    }
  }
}
