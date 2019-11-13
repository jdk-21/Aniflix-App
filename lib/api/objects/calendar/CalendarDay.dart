import './CalendarShow.dart';

class CalendarDay{
  int day;
  List<CalendarShow> airings;

  CalendarDay(this.day,this.airings);
  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(json["day"], CalendarShow.getCalendarShows(json["airings"]));
  }

}