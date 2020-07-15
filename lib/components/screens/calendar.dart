import 'package:aniflix_app/api/objects/calendar/CalendarDay.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';

class Calendardata {
  List<CalendarDay> days;
  Calendardata(this.days);
}

class Calendar extends StatefulWidget implements Screen {
  @override
  getScreenName() {
    return "calendar_screen";
  }

  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  Future<Calendardata> calendarData;
  Calendardata cache;

  List<SliderElement> special = [];
  List<SliderElement> monday = [];
  List<SliderElement> tuesday = [];
  List<SliderElement> wednesday = [];
  List<SliderElement> thursday = [];
  List<SliderElement> friday = [];
  List<SliderElement> saturday = [];
  List<SliderElement> sunday = [];

  CalendarState() {
    if (CacheManager.calendardata == null) {
      this.calendarData = APIManager.getCalendarData();
    } else {
      this.cache = CacheManager.calendardata;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null) {
      return Container(
        color: Theme.of(ctx).backgroundColor,
        key: Key("calendar_screen"),
        child: FutureBuilder<Calendardata>(
          future: calendarData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CacheManager.calendardata = snapshot.data;
              return getLayout(snapshot.data, ctx);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Container(
          color: Theme.of(ctx).backgroundColor,
          key: Key("calendar_screen"),
          child: getLayout(cache, ctx));
    }
  }

  getLayout(Calendardata data, BuildContext ctx) {
    List<CalendarDay> days = data.days;

    for (int i = 0; i < days.length; i++) {
      var day = days[i];
      var airings = day.airings;
      for (int j = 0; j < airings.length; j++) {
        var airing = airings[j];
        var show = airing.show;

        SliderElement element = new SliderElement(
          name: show.name,
          description: (airing.released) ? "Verlinkt" : (airing.details.length > 25) ? airing.details.substring(0,24) : airing.details,
          image: "https://www2.aniflix.tv/storage/" + show.cover_landscape,
          desccolor:
              (airing.released) ? Colors.green : Color.fromRGBO(15, 15, 15, 1),
          onTap: (ctx) {
            Navigator.pushNamed(ctx, "anime", arguments: show.url);
          },
          highlight: airing.highlight,
        );
        switch (day.day) {
          case 0:
            special.add(element);
            break;
          case 1:
            monday.add(element);
            break;
          case 2:
            tuesday.add(element);
            break;
          case 3:
            wednesday.add(element);
            break;
          case 4:
            thursday.add(element);
            break;
          case 5:
            friday.add(element);
            break;
          case 6:
            saturday.add(element);
            break;
          case 7:
            sunday.add(element);
            break;
          default:
            break;
        }
      }
    }

    var list = <Widget>[];

    list.add(
        (monday.length > 0) ? HeadlineSlider("Montag", monday) : Container());
    list.add((tuesday.length > 0)
        ? HeadlineSlider("Dienstag", tuesday)
        : Container());
    list.add((wednesday.length > 0)
        ? HeadlineSlider("Mittwoch", wednesday)
        : Container());
    list.add((thursday.length > 0)
        ? HeadlineSlider("Donnerstag", thursday)
        : Container());
    list.add(
        (friday.length > 0) ? HeadlineSlider("Freitag", friday) : Container());
    list.add((saturday.length > 0)
        ? HeadlineSlider("Samstag", saturday)
        : Container());
    list.add(
        (sunday.length > 0) ? HeadlineSlider("Sonntag", sunday) : Container());

    var date = DateTime.now();

    var sortedList = list.sublist(date.weekday - 1);
    if (date.weekday >= 2) {
      sortedList.addAll(list.sublist(0, date.weekday - 1));
    }
    sortedList.add((special.length > 0)
        ? HeadlineSlider("Unregelmäßig", special)
        : Container());
    var i = 0;
    for (var k = 0; k < sortedList.length; k++) {
      Widget element = sortedList[k];
      if (element is HeadlineSlider) {
        HeadlineSlider slider = element;
        if (i == 0) {
          slider.title = "Heute";
          sortedList[k] = slider;
          i++;
        } else if (i == 1) {
          slider.title = "Morgen";
          sortedList[k] = slider;
          i++;
          break;
        }
      }
    }

    return 
    Column(children: <Widget>[
          (AppState.adFailed) ? Container() : SizedBox(height: 50,),
      Expanded(child: Container(
        color: Theme.of(ctx).backgroundColor,
        child: RefreshIndicator(
            child: ListView(
                padding: EdgeInsets.only(top: 10), children: sortedList),
            onRefresh: () async {
              APIManager.getCalendarData().then((data) {
                setState(() {
                  cache = data;
                  CacheManager.calendardata = data;
                });
              });
            })))
    ],)
    ;
  }
}
