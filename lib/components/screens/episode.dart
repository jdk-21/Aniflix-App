import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Episode.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EpisodeScreen extends StatelessWidget {
  MainWidgetState state;

  Future<EpisodeInfo> episodedata;

  EpisodeScreen(this.state,String name, int season, int number){
    this.episodedata = APIManager.getEpisode(name, season, number);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("episode_screen"),
      child: FutureBuilder<EpisodeInfo>(
        future: episodedata,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var episode = snapshot.data;
            return Container(
                color: Theme.of(ctx).backgroundColor,
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        (false)
                            ? OutlineButton(
                          textColor: Theme.of(ctx).textTheme.title.color,
                          borderSide: BorderSide(
                              color: Theme.of(ctx).textTheme.title.color),
                          child: Icon(Icons.navigate_before),
                          onPressed: () {},
                        )
                            : SizedBox(),
                        Row(
                          children: <Widget>[
                            Theme(
                              data: Theme.of(ctx).copyWith(
                                  canvasColor: Theme.of(ctx).backgroundColor),
                              child: DropdownButton(
                                style: TextStyle(
                                    color: Theme.of(ctx).textTheme.title.color,
                                    fontSize: 15),
                                onChanged: (newValue) {},
                                items: [
                                  DropdownMenuItem(value: 0, child: Text("Sub")),
                                  DropdownMenuItem(value: 1, child: Text("Dub"))
                                ],
                                hint: Text(
                                  "Sub/Dub",
                                  style: TextStyle(
                                      color: Theme.of(ctx).textTheme.title.color),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Theme(
                              data: Theme.of(ctx).copyWith(
                                  canvasColor: Theme.of(ctx).backgroundColor),
                              child: DropdownButton(
                                style: TextStyle(
                                    color: Theme.of(ctx).textTheme.title.color,
                                    fontSize: 15),
                                onChanged: (newValue) {},
                                items: [
                                  DropdownMenuItem(
                                      value: 0, child: Text("Stream A")),
                                  DropdownMenuItem(
                                      value: 1, child: Text("Stream B"))
                                ],
                                hint: Text(
                                  "Stream",
                                  style: TextStyle(
                                      color: Theme.of(ctx).textTheme.title.color),
                                ),
                              ),
                            ),
                          ],
                        ),
                        (false)
                            ? OutlineButton(
                          textColor: Theme.of(ctx).textTheme.title.color,
                          borderSide: BorderSide(
                              color: Theme.of(ctx).textTheme.title.color),
                          child: Icon(Icons.navigate_next),
                          onPressed: () {},
                        )
                            : SizedBox(),
                      ],
                    ),
                    (episode != null)? Text(episode.name,style: TextStyle(
                      color: Theme.of(ctx).textTheme.title.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),):Text("null",style: TextStyle(
                      color: Theme.of(ctx).textTheme.title.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),)
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
