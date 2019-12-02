import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchAnime extends StatefulWidget {
  MainWidgetState state;

  SearchAnime(this.state);

  @override
  SearchAnimeState createState() => SearchAnimeState(state);
}

class SearchAnimeState extends State<SearchAnime> {
  Future<SearchAnime> searchAnimeData;
  MainWidgetState state;


  SearchAnimeState(this.state);

  updateSearchList(String searchText) {
    setState(() {});
  }

  @override
  Widget build(BuildContext ctx) {
    var controller = TextEditingController();
    return Container(
      color: Theme
          .of(ctx)
          .backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
              keyboardType: TextInputType.multiline,
              controller: controller,
              maxLines: null,
              maxLength: 1000,
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
              updateSearchList(controller.text);
              controller.text = "";
            },
          )
        ],
      ),

    );

  }
}
