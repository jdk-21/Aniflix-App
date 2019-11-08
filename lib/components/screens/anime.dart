import 'package:flutter/material.dart';
import '../../api/objects/anime/Anime.dart';
import '../../api/APIManager.dart';

class AnimeScreen extends StatelessWidget {
  Future<Anime> anime;
  AnimeScreen(String name){
    this.anime = APIManager.getAnime(name);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("anime_screen"),
      child: FutureBuilder<Anime>(
        future: anime,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var anime = snapshot.data;
            var episodeCount = 0;
            if(anime.seasons != null){
              for(var season in anime.seasons){
                episodeCount += season.length;
              }
            }
            return Container(
                color: Theme.of(ctx).backgroundColor,
                child: ListView(padding: EdgeInsets.only(top: 10), children: [
                  Row(children: [
                    Image.network("https://www2.aniflix.tv/storage/"+anime.cover_portrait,width: 100,height: 150,),
                    Column(children: [
                      //Flexible(child:
                      Text(anime.name,style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                          overflow: TextOverflow.ellipsis
                      ),
                      //),

                      Text("Score: " + anime.rating,style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 20,
                      ),
                        textAlign: TextAlign.left,),
                      Text("Status: " + ((anime.airing != null) ? "Airing":"Not Airing"),style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 20,
                      ),
                        textAlign: TextAlign.left,),
                      Text("Episoden: " + episodeCount.toString(),style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 20,
                      ),
                        textAlign: TextAlign.left,)
                    ],)
                  ],),
                     Text(anime.description,overflow: TextOverflow.clip,style: TextStyle(
                      color: Theme.of(ctx).textTheme.title.color,
                      fontSize: 20,
                    ),),

                ]));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      )
    );

  }
}

class AnimeInfo extends Container{
  Anime anime;
  AnimeInfo(this.anime);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }
}

class AnimeDescription extends Container{

  String description;

  AnimeDescription(this.description);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }

}