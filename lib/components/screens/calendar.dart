import 'package:aniflix_app/api/objects/CalendarShow.dart';
import 'package:flutter/material.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';

class Calendar extends StatelessWidget {
  Future<List<CalendarShow>> calendarData;

  List<SliderElement> monday;
  List<SliderElement> tuesday;
  List<SliderElement> wednesday;
  List<SliderElement> thursday;
  List<SliderElement> friday;
  List<SliderElement> saturday;
  List<SliderElement> sunday;

  Calendar() {
    this.calendarData = APIManager.getCalendarData();
  }


  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("calendar_screen"),
      child: FutureBuilder<List<CalendarShow>>(
        future: calendarData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            for(int i = 0; i<=snapshot.data.length; i++){
              switch(snapshot.data[i].day){
                case 0:
                  SliderElement element = new SliderElement();
                  element.name = snapshot.data[i].show.name;
                  element.description = snapshot.data[i].details;
                  monday.add(element);
                  break;
                case 1:
                  SliderElement element = new SliderElement();
                  element.name = snapshot.data[i].show.name;
                  element.description = snapshot.data[i].details;
                  tuesday.add(element);
                  break;
                case 2:
                  SliderElement element = new SliderElement();
                  element.name = snapshot.data[i].show.name;
                  element.description = snapshot.data[i].details;
                  wednesday.add(element);
                  break;
                case 3:
                  SliderElement element = new SliderElement();
                  element.name = snapshot.data[i].show.name;
                  element.description = snapshot.data[i].details;
                  thursday.add(element);
                  break;
                case 4:
                  SliderElement element = new SliderElement();
                  element.name = snapshot.data[i].show.name;
                  element.description = snapshot.data[i].details;
                  friday.add(element);
                  break;
                case 5:
                  SliderElement element = new SliderElement();
                  element.name = snapshot.data[i].show.name;
                  element.description = snapshot.data[i].details;
                  saturday.add(element);
                  break;
                case 6:
                  SliderElement element = new SliderElement();
                  element.name = snapshot.data[i].show.name;
                  element.description = snapshot.data[i].details;
                  sunday.add(element);
                  break;
                default:
                  break;
              }
            }


            return Container(
                color: Theme
                    .of(ctx)
                    .backgroundColor,
                child: ListView(padding: EdgeInsets.only(top: 10), children: [
                  HeadlineSlider("Montag", ctx, monday,
                    aspectRatio: 200 / 300, size: 0.4,),
                  HeadlineSlider("Dienstag", ctx, tuesday,
                    aspectRatio: 200 / 300, size: 0.4,),
                  HeadlineSlider("Mittwoch", ctx, wednesday,
                    aspectRatio: 200 / 300, size: 0.4,),
                  HeadlineSlider("Donnerstag", ctx, thursday,
                    aspectRatio: 200 / 300, size: 0.4,),
                  HeadlineSlider("Freitag", ctx, friday,
                    aspectRatio: 200 / 300, size: 0.4,),
                  HeadlineSlider("Samstag", ctx, saturday,
                    aspectRatio: 200 / 300, size: 0.4,),
                  HeadlineSlider("Sonntag", ctx, sunday,
                    aspectRatio: 200 / 300, size: 0.4,),
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