import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';
import '../../api/APIManager.dart';
import '../../api/objects/subbox/SubEpisode.dart';
import '../../main.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import './episode.dart';

class Subdata {
  List<SubEpisode> episodes;
  Subdata(this.episodes);
}

class SubBox extends StatefulWidget implements Screen {
  @override
  getScreenName() {
    return "sub_screen";
  }

  @override
  State<StatefulWidget> createState() => SubBoxState();
}

class SubBoxState extends State<SubBox> {
  Future<Subdata> data;
  Subdata cache;
  List<HeadlineSlider> days;
  List<List<SliderElement>> lists;

  SubBoxState() {
    if (CacheManager.subdata == null) {
      data = APIManager.getSubData();
    } else {
      cache = CacheManager.subdata;
    }
  }

  getDays(List<SubEpisode> episodes) {
    List<DateTime> result = [];
    for (var episode in episodes) {
      DateTime d = DateTime.parse(episode.created_at);
      if (!result.contains(d)) {
        result.add(d);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null) {
      return Container(
          color: Theme.of(ctx).backgroundColor,
          child: Center(
              key: Key("sub_screen"),
              child: FutureBuilder<Subdata>(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    CacheManager.subdata = snapshot.data;
                    return getLayout(snapshot.data, ctx);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                },
              )));
    } else {
      return Container(
          color: Theme.of(ctx).backgroundColor,
          child: Center(key: Key("sub_screen"), child: getLayout(cache, ctx)));
    }
  }

  getLayout(Subdata data, BuildContext ctx) {
    days = [];
    lists = [];
    List<SubEpisode> episodes = data.episodes;

    List<DateTime> epDays = getDays(episodes);

    for (DateTime day in epDays) {
      List<SliderElement> day = [];
      lists.add(day);
    }

    for (var i = 0; i < episodes.length; i++) {
      var date = DateTime.parse(episodes[i].created_at);

      for (var j = 0; j < epDays.length; j++) {
        var d = epDays[j];

        if (d.day == date.day && d.month == date.month && d.year == date.year) {
          SliderElement element = new SliderElement(
              name: episodes[i].show_name +
                  " E" +
                  episodes[i].episode_number.toString() +
                  "S" +
                  episodes[i].season_number.toString(),
              image: "https://www2.aniflix.tv/storage/" +
                  episodes[i].cover_landscape,
              onTap: (ctx) => Navigator.pushNamed(ctx, "episode",
                  arguments: EpisodeScreenArguments(episodes[i].show_url,
                      episodes[i].season_number, episodes[i].episode_number)));
          lists[j].add(element);
          break;
        }
      }
    }

    for (var i = 0; i < lists.length; i++) {
      if (lists[i].isNotEmpty) {
        var now = DateTime.now();
        HeadlineSlider slider;
        if (epDays[i].day == now.day &&
            epDays[i].month == now.month &&
            epDays[i].year == now.year) {
          slider = new HeadlineSlider("Heute", lists[i]);
        } else {
          slider = new HeadlineSlider(
              epDays[i].day.toString() +
                  "." +
                  epDays[i].month.toString() +
                  "." +
                  epDays[i].year.toString(),
              lists[i]);
        }
        days.add(slider);
      }
    }

    return Column(
      children: <Widget>[
          (AppState.adFailed) ? Container() : SizedBox(height: 50,),
        Expanded(
            child: Container(
                color: Theme.of(ctx).backgroundColor,
                child: RefreshIndicator(
                  child: ListView(
                      padding: EdgeInsets.only(top: 10), children: days),
                  onRefresh: () async {
                    APIManager.getSubData().then((data) {
                      CacheManager.subdata = data;
                      setState(() {
                        cache = data;
                      });
                    });
                  },
                )))
      ],
    );
  }
}
