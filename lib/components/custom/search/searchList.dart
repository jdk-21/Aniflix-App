import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class SearchList extends StatelessWidget{
  Future<List<Show>> shows;
  MainWidgetState state;

  SearchList(this.shows, this.state);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      child: FutureBuilder<List<Show>>(
        future: shows,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
           return Column(
             children:
               snapshot.data.map((show){
                 return ImageListElement(show.name, show.cover_portrait, ctx, descLine1: show.description, onTap: (){
                   state.changePage(AnimeScreen(show.url, state), 7);
                 });
               }).toList()
           );
          } else if (snapshot.hasError) {
            return ThemeText("${snapshot.error}",ctx);
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),);
  }
}