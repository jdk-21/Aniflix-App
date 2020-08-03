import 'package:aniflix_app/api/objects/Episode.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';

class Homedata {
  List<Episode> continues;
  List<Episode> airings;
  List<Show> newshows;
  List<Show> discover;

  Homedata(this.continues, this.airings, this.newshows, this.discover);
}

class Home extends StatefulWidget implements Screen {
  Home();

  @override
  getScreenName() {
    return "home_screen";
  }

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<Homedata> homedata;
  Homedata cache;

  HomeState() {
    if (CacheManager.homedata == null) {
      this.homedata = APIManager.getHomeData();
    } else {
      cache = CacheManager.homedata;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null) {
      return Container(
        key: Key("home_screen"),
        color: Colors.transparent,
        child: FutureBuilder<Homedata>(
          future: homedata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              cache = snapshot.data;
              CacheManager.homedata = snapshot.data;
              return getLayout(ctx, snapshot.data);
            } else if (snapshot.hasError) {
              return ThemeText("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Container(
          key: Key("home_screen"),
          color: Colors.transparent,
          child: getLayout(ctx, cache));
    }
  }

  getLayout(BuildContext ctx, Homedata data) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                color: Colors.transparent,
                child: RefreshIndicator(
                  child: ListView(padding: EdgeInsets.only(top: 10), children: [
                    (data.continues.length > 0)
                        ? HeadlineSlider(
                        "Weitersehen",
                        data.continues
                            .map((ep) => getContinueSliderElement(ep))
                            .toList(),
                        220)
                        : Center(child: ThemeText("'Weitersehen' konnte nicht geladen werden!")),
                    (data.airings.length > 0)
                        ? HeadlineSlider(
                        "Neue Folgen",
                        data.airings
                            .map((ep) => getAiringSliderElement(ep))
                            .toList(),
                        250)
                        : Center(child: ThemeText("'Neue Folgen' konnte nicht geladen werden!")),
                    (data.newshows.length > 0)
                        ? HeadlineSlider(
                      "Neu auf Aniflix",
                      data.newshows
                          .map((show) => getShowSliderElement(show))
                          .toList(),
                      350,
                      size: 0.4,
                    )
                        : Center(child: ThemeText("'Neu auf Aniflix' konnte nicht geladen werden!")),
                    (data.discover.length > 0)
                        ? HeadlineSlider(
                      "Entdecken",
                      data.discover
                          .map((show) => getShowSliderElement(show))
                          .toList(),
                      350,
                      size: 0.4,
                    )
                        : Center(child: ThemeText("'Entdecken' konnte nicht geladen werden!"))
                  ]),
                  onRefresh: () async {
                    setState(() {
                      APIManager.getHomeData().then((data) {
                        CacheManager.homedata = data;
                        setState(() {
                          cache = data;
                        });
                      });
                    });
                  },
                )))
      ],
    );
  }

  SliderElement getContinueSliderElement(Episode episode) {
    var element = getAiringSliderElement(episode);
    element.close = () async {
      var continues = await APIManager.hideContinue(
        episode.season.show_id,
      );
      setState(() {
        this.cache.continues = continues;
        CacheManager.homedata.continues = continues;
      });
    };
    return element;
  }

  SliderElement getAiringSliderElement(Episode episode) {
    var desc = "";
    var date;
    if (episode.created_at != null) {
      date = DateTime.parse(episode.created_at);
    }

    var now = DateTime.now();

    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      desc = "Heute";
    } else {
      desc = date.day.toString() +
          "." +
          date.month.toString() +
          "." +
          date.year.toString();
    }
    return SliderElement(
        name: episode.season.show.name +
            " S" +
            episode.season.number.toString() +
            "E" +
            episode.number.toString(),
        description: desc,
        image: "https://www2.aniflix.tv/storage/" +
            episode.season.show.cover_landscape,
        onTap: (ctx) {
          Navigator.pushNamed(ctx, "episode",
              arguments: EpisodeScreenArguments(episode.season.show.url,
                  episode.season.number, episode.number));
        });
  }

  SliderElement getShowSliderElement(Show show) {
    return SliderElement(
      name: show.name,
      image: "https://www2.aniflix.tv/storage/" + show.cover_portrait,
      onTap: (ctx) {
        Navigator.pushNamed(ctx, "anime", arguments: show.url);
      },
      horizontal: false,
    );
  }
}
