import 'package:aniflix_app/api/objects/calendar/CalendarDay.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';
import 'package:aniflix_app/main.dart';

class Calendar extends StatelessWidget implements Screen{

  MainWidgetState state;

  Future<List<CalendarDay>> calendarData;

  List<SliderElement> special = [];
  List<SliderElement> monday = [];
  List<SliderElement> tuesday = [];
  List<SliderElement> wednesday = [];
  List<SliderElement> thursday= [];
  List<SliderElement> friday= [];
  List<SliderElement> saturday= [];
  List<SliderElement> sunday= [];

  Calendar(this.state) {
    this.calendarData = APIManager.getCalendarData();
  }

  @override
  getScreenName() {
    return "calendar_screen";
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("calendar_screen"),
      child: FutureBuilder<List<CalendarDay>>(
        future: calendarData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            List<CalendarDay> days = snapshot.data;

            for(int i = 0; i < days.length; i++){
              var day = days[i];
              var airings = day.airings;
              for(int j = 0; j < airings.length; j++){
                var airing = airings[j];
                var show = airing.show;

                SliderElement element = new SliderElement(name: show.name,description: airing.details,image: "https://www2.aniflix.tv/storage/"+show.cover_landscape,);
                switch(day.day){
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


            return Container(
                color: Theme
                    .of(ctx)
                    .backgroundColor,
                child: ListView(padding: EdgeInsets.only(top: 10), children: [
                  (monday.length > 0) ? HeadlineSlider("Montag", ctx, monday): Container(),
                  (tuesday.length > 0) ? HeadlineSlider("Dienstag", ctx, tuesday): Container(),
                  (wednesday.length > 0) ? HeadlineSlider("Mittwoch", ctx, wednesday): Container(),
                  (thursday.length > 0) ? HeadlineSlider("Donnerstag", ctx, thursday): Container(),
                  (friday.length > 0) ? HeadlineSlider("Freitag", ctx, friday): Container(),
                  (saturday.length > 0) ? HeadlineSlider("Samstag", ctx, saturday): Container(),
                  (sunday.length > 0) ? HeadlineSlider("Sonntag", ctx, sunday): Container(),
                  (special.length > 0) ? HeadlineSlider("Unregelmäßig", ctx, special): Container()
                ]));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),);
  }
}