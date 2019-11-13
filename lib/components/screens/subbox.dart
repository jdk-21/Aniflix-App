import 'package:flutter/material.dart';
import '../../api/APIManager.dart';
import '../../api/objects/subbox/SubEpisode.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../main.dart';
import './episode.dart';

class SubBox extends StatelessWidget {
  Future<List<SubEpisode>> episodes;
  List<HeadlineSlider> days = [];
  List<List<SliderElement>> lists = [];

  SubBox() {
    this.episodes = APIManager.getSubData();
  }

  getDays(List<SubEpisode> episodes) {
    List<DateTime> result = [];
    for (var episode in episodes) {
      DateTime d = DateTime.parse(episode.created_at);
      if(!result.contains(d)){
        result.add(d);
      }
    }
    return result;
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

              List<DateTime> epDays = getDays(episodes);

              for(DateTime day in epDays){
                List<SliderElement> day = [];
                lists.add(day);
              }

              for (var i = 0; i <episodes.length; i++) {

                var date = DateTime.parse(episodes[i].created_at);
                var dateNow = DateTime.now();

                for (var j=0; j<epDays.length; j++) {
                  var d = epDays[j];

                  if (d.day == date.day && d.month == date.month && d.year == date.year) {

                    SliderElement element = new SliderElement(
                        name: episodes[i].show_name + " E" +
                            episodes[i].episode_number.toString() + "S" +
                            episodes[i].season_number.toString(), image: "https://www2.aniflix.tv/storage/" +
                            episodes[i].cover_landscape,
                    onTap:() => 
                      MainWidget.of(ctx).changePage(EpisodeScreen(MainWidget.of(ctx),episodes[i].show_url,episodes[i].season_number,episodes[i].episode_number), 10)
                    );
                    lists[j].add(element);
                    break;
                  }

                }
              }

              for (var i = 0; i < lists.length; i++) {
                if (lists[i].isNotEmpty) {
                  HeadlineSlider slider = new HeadlineSlider(epDays[i].day.toString() + "."
                      + epDays[i].month.toString() + "." + epDays[i].year.toString(), ctx, lists[i]);
                  days.add(slider);
                }
              }

              return Container(
                  color: Theme.of(ctx).backgroundColor,
                  child: ListView(
                      padding: EdgeInsets.only(top: 10),
                      children: days));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ));
  }
}
