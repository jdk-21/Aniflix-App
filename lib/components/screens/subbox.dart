import 'package:flutter/material.dart';
import '../../api/APIManager.dart';
import '../../api/objects/SubEpisode.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';

class SubBox extends StatelessWidget {
  Future<List<SubEpisode>> episodes;

  SubBox() {
    this.episodes = APIManager.getSubData();
  }

  @override
  Widget build(BuildContext ctx) {
    return Center(
        key: Key("sub_screen"),
        child: FutureBuilder<List<SubEpisode>>(
          future: episodes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SubEpisode> episodes = snapshot.data;
              List<SliderElement> elements = [];
              for(var episode in episodes){
                var date = DateTime.parse(episode.created_at);
                //TODO group by Day
                elements.add(SliderElement(name: episode.show_name + " E"+episode.episode_number.toString()+"S"+episode.season_number.toString(),image: "https://www2.aniflix.tv/storage/"+episode.cover_landscape,));
              }
              return Container(
                  color: Theme.of(ctx).backgroundColor,
                  child: ListView(
                      padding: EdgeInsets.only(top: 10), children: [
                        HeadlineSlider("Test", ctx, elements)
                  ]));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ));
  }
}
