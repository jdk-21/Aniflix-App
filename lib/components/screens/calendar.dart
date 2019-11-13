import 'package:aniflix_app/api/objects/calendar/CalendarDay.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';
import 'package:aniflix_app/main.dart';

class Calendar extends StatelessWidget {

  MainWidgetState state;

  Future<List<CalendarDay>> calendarData;

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
                  HeadlineSlider("Montag", ctx, monday),
                  HeadlineSlider("Dienstag", ctx, tuesday),
                  HeadlineSlider("Mittwoch", ctx, wednesday),
                  HeadlineSlider("Donnerstag", ctx, thursday),
                  HeadlineSlider("Freitag", ctx, friday),
                  HeadlineSlider("Samstag", ctx, saturday),
                  HeadlineSlider("Sonntag", ctx, sunday),
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